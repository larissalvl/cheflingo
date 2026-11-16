// Cozinha Maluca — Dia 1: ler 1 joystick HW-504 no ESP32 e mostrar no Serial.
// Saída já no formato do jogo: J1,x,y,sw   (x,y de -1 a 1; sw=1 apertado)
//
// Ligações (HW-504 -> ESP32):
//   GND  -> GND
//   +5V  -> 3V3   (alimentar com 3,3V, NÃO 5V)
//   VRx  -> GPIO 34
//   VRy  -> GPIO 35
//   SW   -> GPIO 32  (GPIO 34-39 não têm pull-up interno, por isso o SW vai no 32)
//
// Arduino IDE: placa "ESP32 Dev Module", Serial Monitor em 115200.

const char* PLAYER_ID = "J1";   // troque para "J2" no segundo ESP32

const int PIN_X  = 34;
const int PIN_Y  = 35;
const int PIN_SW = 32;

const float DEADZONE = 0.12;    // zona morta: ignora pequenas variações perto do centro
const int SEND_HZ = 50;         // pacotes por segundo
const bool INVERT_X = false;    // mude se o eixo andar ao contrário
const bool INVERT_Y = false;

int centerX = 2048;
int centerY = 2048;

int readAvg(int pin, int samples) {
  long sum = 0;
  for (int i = 0; i < samples; i++) {
    sum += analogRead(pin);
    delay(2);
  }
  return sum / samples;
}

// Converte leitura bruta (0..4095) em -1..1 usando o centro calibrado.
float normalize(int raw, int center) {
  float v;
  if (raw >= center) v = (float)(raw - center) / (4095 - center);
  else               v = (float)(raw - center) / center;
  if (fabs(v) < DEADZONE) return 0.0;
  // reescala para começar em 0 logo após a zona morta
  float s = (fabs(v) - DEADZONE) / (1.0 - DEADZONE);
  return constrain(v > 0 ? s : -s, -1.0, 1.0);
}

void setup() {
  Serial.begin(115200);
  pinMode(PIN_SW, INPUT_PULLUP);
  analogReadResolution(12);
  analogSetAttenuation(ADC_11db);   // faixa completa até ~3,3V

  delay(300);
  // Calibração: NÃO mexa no joystick nos primeiros segundos após ligar.
  centerX = readAvg(PIN_X, 64);
  centerY = readAvg(PIN_Y, 64);
  Serial.printf("# calibrado: centroX=%d centroY=%d\n", centerX, centerY);
}

void loop() {
  int rawX = analogRead(PIN_X);
  int rawY = analogRead(PIN_Y);
  float x = normalize(rawX, centerX);
  float y = normalize(rawY, centerY);
  if (INVERT_X) x = -x;
  if (INVERT_Y) y = -y;
  int sw = digitalRead(PIN_SW) == LOW ? 1 : 0;   // com pull-up, apertado = LOW

  Serial.printf("%s,%.2f,%.2f,%d\n", PLAYER_ID, x, y, sw);
  delay(1000 / SEND_HZ);
}
