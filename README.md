# Cheflingo

Jogo educativo cooperativo (2 jogadores) para crianças de 8 a 10 anos, feito na Godot 4.7.2.
Cada jogador controla um chef com um joystick. Os dois joysticks ficam ligados a **um ESP32**, que manda os comandos para o PC pelo **cabo USB**.

## Rodar o jogo
1. Abra a Godot 4.7.2 → **Importar** → escolha `project.godot`.
2. (Com os joysticks) Ligue o ESP32 no PC e dê dois cliques em `tools/iniciar_joysticks.bat`. Deixe a janela aberta.
3. Aperte **F5**. Na tela inicial, aperte o botão do joystick (ou E / Enter) em "Jogar".

Controles de teclado (sempre funcionam como reserva, e valem nas telas também):

| Jogador | Mover | Ação (pegar/soltar/usar, apertar botão) |
|---|---|---|
| J1 | W A S D | E |
| J2 | Setas | Enter |

A barra no topo da tela mostra quem controla cada chef: `[teclado]` ou `[ESP32]`.

## Pastas
- `scenes/` — cenas (`kitchen.tscn` é a principal; estações em `scenes/stations/`; telas em `scenes/ui/`)
- `scripts/` — código GDScript (`input_manager.gd` é o autoload de controles)
- `firmware/` — código do ESP32 (Arduino IDE)
- `tools/` — ponte USB → jogo e simulador de joystick (Python)
- `sprites/` — arte (convenção de nomes no `CLAUDE.md`)

## Hardware
Materiais: 1 ESP32 (o outro fica de reserva), 2 joysticks HW-504, protoboard, jumpers e o cabo USB do ESP32 (cabo de **dados**, não só de carga).

Os dois joysticks no mesmo ESP32 (3V3 e GND pelo trilho da protoboard):

| HW-504 | J1 → ESP32 | J2 → ESP32 |
|---|---|---|
| GND | GND | GND |
| +5V | **3V3** | **3V3** |
| VRx | GPIO 34 | GPIO 36 (VP) |
| VRy | GPIO 35 | GPIO 39 (VN) |
| SW | GPIO 32 | GPIO 33 |

Se a placa não tiver os pinos VP/VN: ligue o J2 em VRx=25, VRy=26, SW=27 e troque a linha do J2 em `PINS`, no topo do firmware.

Como funciona: o ESP32 imprime no cabo USB, 50 vezes por segundo, `J1,x,y,sw` e `J2,x,y,sw` (x e y de -1 a 1; sw = 1 apertado). O script `tools/serial_to_udp.py` repassa cada linha para o jogo por UDP local (porta 4210). Se nada chegar por 0,5 s, o jogo volta para o teclado sozinho.

### Preparar (uma vez)
1. Instale a biblioteca Python: `pip install pyserial`.
2. Abra `firmware/joysticks/joysticks.ino` na Arduino IDE, placa **ESP32 Dev Module**, e grave.
3. (Opcional) Serial Monitor em 115200: aparece a calibração dos dois joysticks e as linhas `J1,...` e `J2,...`. **Feche o Serial Monitor** antes de rodar o script (a porta só aceita um programa de cada vez).

### Jogar
1. Ligue o ESP32 no PC com os joysticks **soltos**: ele calibra o centro ao ligar.
2. Rode `tools/iniciar_joysticks.bat` (ou `python tools/serial_to_udp.py`; para escolher a porta, `python tools/serial_to_udp.py COM5`).
3. A janela deve mostrar `repassando para o jogo -> J1: 50/s  J2: 50/s`.

### Problemas comuns
- **Chef anda sozinho:** o joystick estava tocado na calibração. Segure o botão daquele joystick por 2 s e solte: ele recalibra. (Ou aperte o botão EN/RST do ESP32 com os joysticks soltos.)
- **"porta OCUPADA":** feche o Serial Monitor da Arduino IDE.
- **"Nenhum ESP32 encontrado":** troque o cabo (alguns só carregam) ou instale o driver do chip USB da placa (CP210x ou CH340).
- **Um eixo ao contrário:** mude `INVERT_X` / `INVERT_Y` daquele jogador no firmware.

### Testar sem hardware
Com o jogo rodando: `python tools/fake_joystick.py` (ou `... J2`). O chef anda em círculo por 6 s.

### Reserva
- Plano B: teclado (sempre funciona).
- O firmware antigo com Wi-Fi de um joystick só (`firmware/j1/`) continua no projeto, mas não é mais usado.
