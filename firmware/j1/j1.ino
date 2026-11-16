// Cozinha Maluca — Firmware do J1 (Dia 2)
// Lê o joystick HW-504, calibra o centro no boot e envia "J1,x,y,sw" por UDP a 50 Hz.
// Baseado no sketch testado no D1 (firmware/joystick_serial), mesmos pinos.
//
// Ligações (HW-504 -> ESP32):
//   GND  -> GND
//   +5V  -> 3V3   (alimentar com 3,3V, NÃO 5V)
//   VRx  -> GPIO 34  (ADC1, funciona com Wi-Fi)
//   VRy  -> GPIO 35  (ADC1, funciona com Wi-Fi)
//   SW   -> GPIO 32  (INPUT_PULLUP; 34-39 não têm pull-up interno)
//
// ANTES DE COMPILAR: copie config.example.h para config.h (nesta mesma pasta)
// e preencha o nome/senha do Wi-Fi e o IP do PC.
//
// Arduino IDE: placa "ESP32 Dev Module", Serial Monitor em 115200.

#include <WiFi.h>
#include <WiFiUdp.h>
#include "config.h"

// ---- Modo de teste ----
// true  = NÃO usa Wi-Fi; imprime "J1,x,y,sw" no Serial a 50 Hz (isola problema de joystick,
//         e é o formato que o plano B Serial -> Python -> UDP vai ler).
// false = modo normal: Wi-Fi + UDP, com diagnóstico no Serial.
#define SERIAL_ONLY false

const char* PLAYER_ID = "J1";

const int PIN_X  = 34;
const int PIN_Y  = 35;
const int PIN_SW = 32;

const float DEADZONE = 0.10;        // zona morta de 10%
const int CALIBRATION_SAMPLES = 100;
const int SEND_HZ = 50;
const unsigned long SEND_INTERVAL_MS = 1000 / SEND_HZ;
const unsigned long DIAG_INTERVAL_MS = 200;      // diagnóstico no Serial 5x por segundo
const unsigned long WIFI_RETRY_MS = 5000;

const bool INVERT_X = false;        // mude se o eixo andar ao contrário no jogo
const bool INVERT_Y = false;

int centerX = 2048;
int centerY = 2048;

WiFiUDP udp;
IPAddress pcIp;
unsigned long lastSend = 0;
unsigned long lastDiag = 0;
unsigned long lastWifiTry = 0;
unsigned long packetsSent = 0;

// ---------------- joystick ----------------

int readAvg(int pin, int samples) {
  long sum = 0;
  for (int i = 0; i < samples; i++) {
    sum += analogRead(pin);
    delay(3);
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

void calibrate() {
  Serial.println("# ==============================================");
  Serial.println("# CALIBRANDO: NAO MEXA NO JOYSTICK!");
  for (int i = 3; i > 0; i--) {
    Serial.printf("# comecando em %d...\n", i);
    delay(500);
  }
  centerX = readAvg(PIN_X, CALIBRATION_SAMPLES);
  centerY = readAvg(PIN_Y, CALIBRATION_SAMPLES);
  Serial.printf("# calibrado: centroX=%d centroY=%d (ideal perto de 1800-2100)\n", centerX, centerY);
  if (centerX < 1000 || centerX > 3000 || centerY < 1000 || centerY > 3000) {
    Serial.println("# AVISO: centro estranho. Confira os fios VRx/VRy/3V3/GND e reinicie.");
  }
  Serial.println("# ==============================================");
}

// ---------------- Wi-Fi ----------------

const char* wifiStatusText(wl_status_t s) {
  switch (s) {
    case WL_CONNECTED:      return "CONECTADO";
    case WL_NO_SSID_AVAIL:  return "REDE NAO ENCONTRADA (nome errado ou rede 5 GHz?)";
    case WL_CONNECT_FAILED: return "FALHOU (senha errada?)";
    case WL_DISCONNECTED:   return "DESCONECTADO";
    case WL_IDLE_STATUS:    return "AGUARDANDO";
    default:                return "CONECTANDO...";
  }
}

void startWifi() {
  Serial.printf("# Wi-Fi: conectando em \"%s\"...\n", WIFI_SSID);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);              // menos atraso nos pacotes
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  lastWifiTry = millis();

  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < 15000) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  printWifiStatus();
}

void printWifiStatus() {
  wl_status_t s = WiFi.status();
  Serial.printf("# Wi-Fi: %s\n", wifiStatusText(s));
  if (s == WL_CONNECTED) {
    Serial.printf("# IP do ESP32: %s | sinal: %d dBm\n", WiFi.localIP().toString().c_str(), WiFi.RSSI());
    Serial.printf("# enviando para %s:%d\n", PC_IP, PC_PORT);
  }
}

void keepWifiAlive() {
  if (WiFi.status() == WL_CONNECTED) return;
  if (millis() - lastWifiTry < WIFI_RETRY_MS) return;
  lastWifiTry = millis();
  Serial.printf("# Wi-Fi caiu (%s). Tentando reconectar...\n", wifiStatusText(WiFi.status()));
  WiFi.disconnect();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

// ---------------- programa ----------------

void setup() {
  Serial.begin(115200);
  delay(300);
  Serial.println();
  Serial.printf("# Cozinha Maluca - firmware %s (%s)\n", PLAYER_ID, SERIAL_ONLY ? "MODO SO-SERIAL" : "MODO WI-FI/UDP");

  pinMode(PIN_SW, INPUT_PULLUP);
  analogReadResolution(12);
  analogSetAttenuation(ADC_11db);    // faixa completa até ~3,3V

  calibrate();

  if (!SERIAL_ONLY) {
    if (!pcIp.fromString(PC_IP)) {
      Serial.printf("# ERRO: PC_IP invalido no config.h: \"%s\"\n", PC_IP);
    }
    startWifi();
  }
}

void loop() {
  unsigned long now = millis();
  if (now - lastSend < SEND_INTERVAL_MS) return;
  lastSend = now;

  int rawX = analogRead(PIN_X);
  int rawY = analogRead(PIN_Y);
  float x = normalize(rawX, centerX);
  float y = normalize(rawY, centerY);
  if (INVERT_X) x = -x;
  if (INVERT_Y) y = -y;
  int sw = digitalRead(PIN_SW) == LOW ? 1 : 0;   // com pull-up, apertado = LOW

  char packet[32];
  snprintf(packet, sizeof(packet), "%s,%.2f,%.2f,%d", PLAYER_ID, x, y, sw);

  if (SERIAL_ONLY) {
    Serial.println(packet);                       // formato exato, 50x por segundo
    return;
  }

  keepWifiAlive();
  bool online = WiFi.status() == WL_CONNECTED;
  if (online) {
    udp.beginPacket(pcIp, PC_PORT);
    udp.print(packet);
    udp.endPacket();
    packetsSent++;
  }

  if (now - lastDiag >= DIAG_INTERVAL_MS) {       // linhas de diagnóstico começam com "#"
    lastDiag = now;
    Serial.printf("# %s | bruto x=%4d y=%4d | wifi=%s | enviados=%lu\n",
                  packet, rawX, rawY, online ? "OK" : "OFF", packetsSent);
  }
}
