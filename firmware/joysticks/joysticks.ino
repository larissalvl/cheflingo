// Cozinha Maluca — Firmware de 1 ESP32 com os 2 joysticks (J1 e J2), pelo cabo USB.
//
// Lê os dois joysticks HW-504, calibra o centro de cada um no boot e imprime no
// Serial (USB), 50 vezes por segundo, uma linha por jogador:
//   J1,x,y,sw
//   J2,x,y,sw
// x e y vão de -1 a 1 (com zona morta), sw = 1 quando o botão está apertado.
// No PC, tools/serial_to_udp.py lê essas linhas e repassa para o jogo (UDP local).
// Linhas que começam com "#" são diagnóstico (o script mostra, mas não repassa).
// Não usa Wi-Fi.
//
// Ligações (os dois joysticks no MESMO ESP32; 3V3 e GND pelo trilho da protoboard):
//   HW-504 J1            HW-504 J2
//   GND  -> GND          GND  -> GND
//   +5V  -> 3V3          +5V  -> 3V3     (alimentar com 3,3V, NÃO 5V)
//   VRx  -> GPIO 34      VRx  -> GPIO 36 (pino "VP" ou "SVP" na placa)
//   VRy  -> GPIO 35      VRy  -> GPIO 39 (pino "VN" ou "SVN" na placa)
//   SW   -> GPIO 32      SW   -> GPIO 33
// SW usa INPUT_PULLUP (34 a 39 não têm pull-up interno, por isso o SW fica no 32/33).
// Se a sua placa não tiver VP/VN: J2 em VRx=25, VRy=26, SW=27 (mude PINS abaixo;
// sem Wi-Fi, esses pinos também leem analógico).
//
// Recalibrar sem reiniciar (quando o chef anda sozinho): segure o botão do
// joystick apertado por 2 segundos e SOLTE o joystick. Meio segundo depois ele
// recalibra o centro daquele joystick.
//
// Arduino IDE: placa "ESP32 Dev Module". Serial Monitor em 115200 só para
// diagnóstico (FECHE o Serial Monitor antes de rodar o script Python: a porta
// só pode ser usada por um programa de cada vez).

const int NUM_PLAYERS = 2;
const char* PLAYER_IDS[NUM_PLAYERS] = {"J1", "J2"};
//                         VRx  VRy  SW
const int PINS[NUM_PLAYERS][3] = {
  {34, 35, 32},   // J1
  {36, 39, 33},   // J2
};

const float DEADZONE = 0.10;              // zona morta de 10%
const int CALIBRATION_SAMPLES = 100;
const int SEND_HZ = 50;
const unsigned long SEND_INTERVAL_MS = 1000 / SEND_HZ;
const unsigned long DIAG_INTERVAL_MS = 2000;      // diagnóstico a cada 2 s
const unsigned long RECAL_HOLD_MS = 2000;         // segurar o botão por 2 s = recalibrar
const unsigned long RECAL_WAIT_MS = 500;          // espera depois de soltar

// Mude se algum eixo andar ao contrário no jogo (por jogador).
const bool INVERT_X[NUM_PLAYERS] = {false, false};
const bool INVERT_Y[NUM_PLAYERS] = {false, false};

int centerX[NUM_PLAYERS] = {2048, 2048};
int centerY[NUM_PLAYERS] = {2048, 2048};

// Recalibração pelo botão
unsigned long pressStart[NUM_PLAYERS] = {0, 0};
bool wasPressed[NUM_PLAYERS] = {false, false};
bool recalArmed[NUM_PLAYERS] = {false, false};
unsigned long releasedAt[NUM_PLAYERS] = {0, 0};

unsigned long lastSend = 0;
unsigned long lastDiag = 0;
int lastRawX[NUM_PLAYERS] = {0, 0};
int lastRawY[NUM_PLAYERS] = {0, 0};

// ---------------- joystick ----------------

int readAvg(int pin, int samples) {
  long sum = 0;
  for (int i = 0; i < samples; i++) {
    sum += analogRead(pin);
    delay(2);
  }
  return sum / samples;
}

// Converte leitura bruta (0..4095) em -1..1 usando o centro calibrado e a zona morta.
float normalize(int raw, int center) {
  float v;
  if (raw >= center) v = (float)(raw - center) / (4095 - center);
  else               v = (float)(raw - center) / center;
  if (fabs(v) < DEADZONE) return 0.0;
  float s = (fabs(v) - DEADZONE) / (1.0 - DEADZONE);   // recomeça do 0 depois da zona morta
  return constrain(v > 0 ? s : -s, -1.0, 1.0);
}

void calibrate(int p) {
  centerX[p] = readAvg(PINS[p][0], CALIBRATION_SAMPLES);
  centerY[p] = readAvg(PINS[p][1], CALIBRATION_SAMPLES);
  Serial.printf("# %s calibrado: centroX=%d centroY=%d (ideal perto de 1800-2100)\n",
                PLAYER_IDS[p], centerX[p], centerY[p]);
  if (centerX[p] < 1000 || centerX[p] > 3000 || centerY[p] < 1000 || centerY[p] > 3000) {
    Serial.printf("# AVISO %s: centro estranho. Confira os fios VRx/VRy/3V3/GND.\n", PLAYER_IDS[p]);
  }
}

void calibrateAll() {
  Serial.println("# ==============================================");
  Serial.println("# CALIBRANDO OS 2 JOYSTICKS: NAO MEXA NELES!");
  for (int i = 3; i > 0; i--) {
    Serial.printf("# comecando em %d...\n", i);
    delay(400);
  }
  for (int p = 0; p < NUM_PLAYERS; p++) calibrate(p);
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
    calibrate(p);
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
  Serial.println("# Cozinha Maluca - firmware 1 ESP32 / 2 joysticks (USB Serial)");
  calibrateAll();
}

void loop() {
  unsigned long now = millis();
  if (now - lastSend < SEND_INTERVAL_MS) return;
  lastSend = now;

  for (int p = 0; p < NUM_PLAYERS; p++) {
    int rawX = analogRead(PINS[p][0]);
    int rawY = analogRead(PINS[p][1]);
    bool pressed = digitalRead(PINS[p][2]) == LOW;   // pull-up: apertado = LOW
    lastRawX[p] = rawX;
    lastRawY[p] = rawY;

    checkRecalibration(p, pressed, now);

    float x = normalize(rawX, centerX[p]);
    float y = normalize(rawY, centerY[p]);
    if (INVERT_X[p]) x = -x;
    if (INVERT_Y[p]) y = -y;
    Serial.printf("%s,%.2f,%.2f,%d\n", PLAYER_IDS[p], x, y, pressed ? 1 : 0);
  }

  if (now - lastDiag >= DIAG_INTERVAL_MS) {
    lastDiag = now;
    Serial.printf("# bruto J1 x=%4d y=%4d | J2 x=%4d y=%4d\n",
                  lastRawX[0], lastRawY[0], lastRawX[1], lastRawY[1]);
  }
}
