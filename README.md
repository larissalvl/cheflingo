# Cozinha Maluca

Jogo educativo cooperativo (2 jogadores) para crianças de 8 a 10 anos, feito na Godot 4.7.2.
Cada jogador controla um chef com um joystick ligado a um ESP32, que manda os comandos por Wi-Fi (UDP).

## Rodar o jogo
1. Abra a Godot 4.7.2 → **Importar** → escolha `project.godot`.
2. Aperte **F5**.

Controles de teclado (sempre funcionam como reserva):

| Jogador | Mover | Ação (pegar/soltar/usar) |
|---|---|---|
| J1 | W A S D | E |
| J2 | Setas | Enter |

A barra no topo da tela mostra quem controla cada chef: `[teclado]` ou `[ESP32]`.

## Pastas
- `scenes/` — cenas (`kitchen.tscn` é a principal; estações em `scenes/stations/`)
- `scripts/` — código GDScript (`input_manager.gd` é o autoload de controles)
- `firmware/` — código dos ESP32 (Arduino IDE)
- `tools/` — scripts auxiliares em Python
- `assets/` — arte e sons (quando chegarem)

## Hardware
Materiais: 2 ESP32, 2 joysticks HW-504, protoboard, jumpers.

| HW-504 | ESP32 |
|---|---|
| GND | GND |
| +5V | **3V3** |
| VRx | GPIO 34 |
| VRy | GPIO 35 |
| SW | GPIO 32 |

Protocolo: cada ESP32 manda texto `J1,x,y,sw` (ou `J2,...`) por UDP para a porta **4210** do PC, 50 vezes por segundo.
x e y vão de -1 a 1; sw = 1 quando o botão está apertado.
Se nenhum pacote chegar por 0,5 s, o jogo volta automaticamente para o teclado.

### Gravar o J1
1. Em `firmware/j1/`, copie `config.example.h` para `config.h` e preencha Wi-Fi (2,4 GHz) e o IP do PC (`ipconfig`).
2. Abra `firmware/j1/j1.ino` na Arduino IDE, placa **ESP32 Dev Module**, e grave.
3. Serial Monitor em 115200: deve mostrar calibração, `Wi-Fi: CONECTADO`, IP e os valores.

`SERIAL_ONLY` no topo do `.ino`: `true` desliga o Wi-Fi e só imprime os pacotes no Serial (para isolar problemas).

### Testar UDP sem hardware
Com o jogo rodando: `python tools/fake_joystick.py` (ou `... J2`). O chef anda em círculo por 6 s.

## Plano B: Serial por USB (sem Wi-Fi)
Se o Wi-Fi do local bloquear o ESP32 ou o PC:
1. Grave o firmware com `SERIAL_ONLY true` e ligue o ESP32 no PC pela USB.
2. Rode `python tools/serial_to_udp.py COM5` (porta do ESP32 no Gerenciador de Dispositivos).
3. O script repassa o Serial para UDP local (127.0.0.1:4210). A Godot não muda nada.

> Estado: estrutura do script pronta; implementação e teste previstos para o D9.

Plano C: teclado (sempre funciona).
