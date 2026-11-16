// MODELO de configuração. Copie este arquivo para "config.h" (mesma pasta) e preencha.
// O config.h NÃO vai para o GitHub (está no .gitignore), então a senha fica só no seu PC.

#pragma once

// Rede Wi-Fi 2,4 GHz (o ESP32 NÃO conecta em rede 5 GHz).
#define WIFI_SSID     "NOME_DA_REDE"
#define WIFI_PASSWORD "SENHA_DA_REDE"

// IP do PC que está rodando o jogo (no Windows: abra o PowerShell e rode "ipconfig",
// procure "Endereço IPv4" do adaptador Wi-Fi). Ex.: "192.168.0.15"
#define PC_IP   "192.168.0.15"
#define PC_PORT 4210
