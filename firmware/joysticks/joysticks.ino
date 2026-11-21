// Cheflingo — Firmware de 1 ESP32 com os 2 joysticks (J1 e J2), pelo cabo USB.
//
// Lê os dois joysticks HW-504, calibra o centro de cada um no boot e imprime no
// Serial (USB), 50 vezes por segundo, uma linha por jogador:
//   J1,x,y,sw
//   J2,x,y,sw
// x e y vão de -1 a 1 (com zona morta), sw = 1 quando o botão está apertado.
// No PC, tools/serial_to_udp.py lê essas linhas e repassa para o jogo (UDP local).
// Linhas que começam com "#" são diagnóstico (o script mostra, mas não repassa).
// Não usa Wi-Fi (por isso os pinos ADC2, como 25 e 26, também leem analógico).
//
// Ligações (os dois joysticks no MESMO ESP32; 3V3 e GND pelo trilho da protoboard):
//   HW-504 J1            HW-504 J2
//   GND  -> GND          GND  -> GND
//   +5V  -> 3V3          +5V  -> 3V3     (alimentar com 3,3V, NÃO 5V)
//   VRx  -> GPIO 34      VRx  -> GPIO 36 (pino "VP" ou "SVP" na placa)
//   VRy  -> GPIO 35      VRy  -> GPIO 39 (pino "VN" ou "SVN" na placa)
//   SW   -> GPIO 32      SW   -> GPIO 33
// SW usa INPUT_PULLUP (34 a 39 não têm pull-up interno, por isso o SW fica no 32/33).
// Se a sua placa não tiver VP/VN: J2 em VRx=25, VRy=26, SW=27 (mude PINS abaixo).
//
// ATENÇÃO: protoboards grandes costumam ter os trilhos laterais (+ e -) CORTADOS
// no meio. Se um joystick estiver depois do corte, ele fica sem 3V3/GND e o sinal
// "flutua" (vai de -1 a 1 sozinho) ou trava em 4095.
//
// Recalibrar sem reiniciar (quando o chef anda sozinho): segure o botão do
// joystick apertado por 2 segundos e SOLTE o joystick. Meio segundo depois ele
// recalibra o centro daquele joystick.
//
// Proteção: se a calibração de um joystick der errado (centro grudado em 0 ou
// 4095, ou sinal muito instável), aquele joystick manda 0,0 (o chef fica parado,
// sem "nan") e o firmware tenta calibrar de novo a cada 3 s, sozinho.
//
// Arduino IDE: placa "ESP32 Dev Module". Serial Monitor em 115200 só para
// diagnóstico (FECHE o Serial Monitor antes de rodar o script Python: a porta
// só pode ser usada por um programa de cada vez).

// ---------------- configuração ----------------

// true = imprime 10x por segundo uma linha "# RAW ..." com o valor bruto (0 a 4095)
// dos dois joysticks. As linhas J1/J2 continuam iguais (o jogo não percebe).
const bool DEBUG_RAW = false;

const int NUM_PLAYERS = 2;
const char* PLAYER_IDS[NUM_PLAYERS] = {"J1", "J2"};
//                         VRx  VRy  SW
const int PINS[NUM_PLAYERS][3] = {
  {34, 35, 32},   // J1
  {36, 39, 33},   // J2
};

const float DEADZONE = 0.10;              // zona morta de 10%
const int READ_SAMPLES = 8;               // média de 8 leituras por eixo (suaviza ruído)
const int CALIBRATION_SAMPLES = 100;      // calibração do boot / do botão
const int RETRY_SAMPLES = 40;             // recalibração automática (rápida, não trava o J1)
const int CENTER_MIN = 500;               // centro fora de 500..3595 = fio solto
const int CENTER_MAX = 3595;
const int NOISE_LIMIT = 400;              // variação máx. com o joystick parado
const int SEND_HZ = 50;
const unsigned long SEND_INTERVAL_MS = 1000 / SEND_HZ;
const unsigned long DIAG_INTERVAL_MS = 2000;      // diagnóstico a cada 2 s
const unsigned long DEBUG_INTERVAL_MS = 100;      // linha RAW a cada 0,1 s
const unsigned long RECAL_HOLD_MS = 2000;         // segurar o botão por 2 s = recalibrar
const unsigned long RECAL_WAIT_MS = 500;          // espera depois de soltar
const unsigned long RETRY_MS = 3000;              // nova tentativa se a calibração falhou

// Mude se algum eixo andar ao contrário no jogo (por jogador).
const bool INVERT_X[NUM_PLAYERS] = {false, false};
const bool INVERT_Y[NUM_PLAYERS] = {false, false};

// ---------------- estado ----------------

int centerX[NUM_PLAYERS] = {2048, 2048};
int centerY[NUM_PLAYERS] = {2048, 2048};
bool calibOk[NUM_PLAYERS] = {false, false};
unsigned long lastCalibTry[NUM_PLAYERS] = {0, 0};

// Recalibração pelo botão
unsigned long pressStart[NUM_PLAYERS] = {0, 0};
bool wasPressed[NUM_PLAYERS] = {false, false};
bool recalArmed[NUM_PLAYERS] = {false, false};
unsigned long releasedAt[NUM_PLAYERS] = {0, 0};

unsigned long lastSend = 0;
unsigned long lastDiag = 0;
unsigned long lastDebug = 0;
int lastRawX[NUM_PLAYERS] = {0, 0};
int lastRawY[NUM_PLAYERS] = {0, 0};
int lastNoiseX[NUM_PLAYERS] = {0, 0};   // max - min das 8 leituras do último quadro
int lastNoiseY[NUM_PLAYERS] = {0, 0};
bool lastPressed[NUM_PLAYERS] = {false, false};

// ---------------- leitura ----------------

// Média de várias leituras seguidas; devolve também a variação (max - min).
int readAxis(int pin, int samples, int delayMs, int &noise) {
  long sum = 0;
  int lo = 4095, hi = 0;
  for (int i = 0; i < samples; i++) {
    int v = analogRead(pin);
    sum += v;
    if (v < lo) lo = v;
    if (v > hi) hi = v;
    if (delayMs > 0) delay(delayMs);
  }
  noise = hi - lo;
  return sum / samples;
}

// Converte leitura bruta (0..4095) em -1..1 usando o centro calibrado e a zona morta.
// Nunca divide por zero e nunca devolve nan.
float normalize(int raw, int center) {
  int up = max(4095 - center, 1);
  int down = max(center, 1);
  float v;
  if (raw >= center) v = (float)(raw - center) / up;
  else               v = (float)(raw - center) / down;
  if (!isfinite(v)) return 0.0;
  if (fabs(v) < DEADZONE) return 0.0;
  float s = (fabs(v) - DEADZONE) / (1.0 - DEADZONE);   // recomeça do 0 depois da zona morta
  return constrain(v > 0 ? s : -s, -1.0, 1.0);
}

// ---------------- calibração ----------------

void calibrate(int p, int samples, int delayMs, bool verbose) {
  int noiseX, noiseY;
  int cx = readAxis(PINS[p][0], samples, delayMs, noiseX);
  int cy = readAxis(PINS[p][1], samples, delayMs, noiseY);
  lastCalibTry[p] = millis();

  bool centerOk = cx >= CENTER_MIN && cx <= CENTER_MAX && cy >= CENTER_MIN && cy <= CENTER_MAX;
  bool quiet = noiseX <= NOISE_LIMIT && noiseY <= NOISE_LIMIT;
  bool ok = centerOk && quiet;
  bool changed = ok != calibOk[p];

  centerX[p] = cx;
  centerY[p] = cy;
  calibOk[p] = ok;

  // Na tentativa automática só imprime quando muda (para não lotar a tela).
  if (!verbose && !changed) return;

  Serial.printf("# %s calibrado: centroX=%d centroY=%d ruidoX=%d ruidoY=%d (ideal: centro 1800-2100, ruido < 150)\n",
                PLAYER_IDS[p], cx, cy, noiseX, noiseY);
  if (ok) {
    Serial.printf("# %s OK.\n", PLAYER_IDS[p]);
    return;
  }
  if (!centerOk) {
    if (cx >= 4000 || cy >= 4000)
      Serial.printf("# ERRO %s: leitura grudada em ~4095. O GND do joystick nao chega (confira o fio GND e o trilho -).\n", PLAYER_IDS[p]);
    else if (cx <= 100 || cy <= 100)
      Serial.printf("# ERRO %s: leitura grudada em ~0. O 3V3 do joystick nao chega (confira o fio +5V->3V3 e o trilho +).\n", PLAYER_IDS[p]);
    else
      Serial.printf("# ERRO %s: centro estranho. Joystick tocado? Confira VRx/VRy/3V3/GND.\n", PLAYER_IDS[p]);
  }
  if (!quiet) {
    Serial.printf("# ERRO %s: sinal instavel (pino flutuando). Quase sempre e 3V3 ou GND solto, ou fio fora do furo.\n", PLAYER_IDS[p]);
  }
  Serial.printf("# %s DESATIVADO (manda 0,0). Tento de novo a cada 3 s.\n", PLAYER_IDS[p]);
}

void calibrateAll() {
  Serial.println("# ==============================================");
  Serial.println("# CALIBRANDO OS 2 JOYSTICKS: NAO MEXA NELES!");
  for (int i = 3; i > 0; i--) {
    Serial.printf("# comecando em %d...\n", i);
    delay(400);
  }
  for (int p = 0; p < NUM_PLAYERS; p++) calibrate(p, CALIBRATION_SAMPLES, 2, true);
  Serial.println("# ==============================================");
}

// Segurar o botão por 2 s arma a recalibração; ela acontece meio segundo depois de soltar.
void checkRecalibration(int p, bool pressed, unsigned long now) {
  if (pressed && !wasPressed[p]) pressStart[p] = now;
  if (pressed && !recalArmed[p] && now - pressStart[p] >= RECAL_HOLD_MS) {
    recalArmed[p] = true;
    Serial.printf("# %s: SOLTE o joystick para recalibrar...\n", PLAYER_IDS[p]);
  }
  if (!pressed && wasPressed[p] && recalArmed[p]) releasedAt[p] = now;
  if (!pressed && recalArmed[p] && releasedAt[p] != 0 && now - releasedAt[p] >= RECAL_WAIT_MS) {
    calibrate(p, CALIBRATION_SAMPLES, 2, true);
    recalArmed[p] = false;
    releasedAt[p] = 0;
  }
  wasPressed[p] = pressed;
}

// ---------------- setup / loop ----------------

void setup() {
  Serial.begin(115200);
  delay(300);
  analogReadResolution(12);
  for (int p = 0; p < NUM_PLAYERS; p++) {
    analogSetPinAttenuation(PINS[p][0], ADC_11db);   // faixa 0-3,3 V
    analogSetPinAttenuation(PINS[p][1], ADC_11db);
    pinMode(PINS[p][2], INPUT_PULLUP);
  }
  Serial.println("# Cheflingo - firmware 1 ESP32 / 2 joysticks (USB Serial)");
  if (DEBUG_RAW) Serial.println("# DEBUG_RAW ligado: linhas '# RAW' com o valor bruto (0 a 4095).");
  calibrateAll();
}

void loop() {
  unsigned long now = millis();
  if (now - lastSend < SEND_INTERVAL_MS) return;
  lastSend = now;

  for (int p = 0; p < NUM_PLAYERS; p++) {
    // Calibração falhou: tenta de novo sozinho (rápido, ~40 ms).
    if (!calibOk[p] && now - lastCalibTry[p] >= RETRY_MS) {
      calibrate(p, RETRY_SAMPLES, 1, false);
    }

    int rawX = readAxis(PINS[p][0], READ_SAMPLES, 0, lastNoiseX[p]);
    int rawY = readAxis(PINS[p][1], READ_SAMPLES, 0, lastNoiseY[p]);
    bool pressed = digitalRead(PINS[p][2]) == LOW;   // pull-up: apertado = LOW
    lastRawX[p] = rawX;
    lastRawY[p] = rawY;
    lastPressed[p] = pressed;

    checkRecalibration(p, pressed, now);

    float x = 0.0, y = 0.0;
    if (calibOk[p]) {
      x = normalize(rawX, centerX[p]);
      y = normalize(rawY, centerY[p]);
      if (INVERT_X[p]) x = -x;
      if (INVERT_Y[p]) y = -y;
    }
    Serial.printf("%s,%.2f,%.2f,%d\n", PLAYER_IDS[p], x, y, pressed ? 1 : 0);
  }

  if (DEBUG_RAW && now - lastDebug >= DEBUG_INTERVAL_MS) {
    lastDebug = now;
    Serial.printf("# RAW J1 x=%4d y=%4d sw=%d ruido=%3d/%3d %s | J2 x=%4d y=%4d sw=%d ruido=%3d/%3d %s\n",
                  lastRawX[0], lastRawY[0], lastPressed[0], lastNoiseX[0], lastNoiseY[0], calibOk[0] ? "ok" : "OFF",
                  lastRawX[1], lastRawY[1], lastPressed[1], lastNoiseX[1], lastNoiseY[1], calibOk[1] ? "ok" : "OFF");
  } else if (!DEBUG_RAW && now - lastDiag >= DIAG_INTERVAL_MS) {
    lastDiag = now;
    Serial.printf("# bruto J1 x=%4d y=%4d | J2 x=%4d y=%4d\n",
                  lastRawX[0], lastRawY[0], lastRawX[1], lastRawY[1]);
  }
}
