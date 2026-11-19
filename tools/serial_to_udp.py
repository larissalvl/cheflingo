"""Ponte USB Serial -> jogo (caminho PRINCIPAL dos joysticks).

O ESP32 (firmware/joysticks) imprime no cabo USB, 50 vezes por segundo:
    J1,x,y,sw
    J2,x,y,sw
Este script lê essas linhas e repassa cada uma por UDP para 127.0.0.1:4210.
A Godot não muda nada: ela continua só escutando UDP (InputManager).

Uso:
    pip install pyserial                      (só uma vez)
    python tools/serial_to_udp.py             (acha a porta do ESP32 sozinho)
    python tools/serial_to_udp.py COM5        (ou diga a porta)
    ou dê dois cliques em tools/iniciar_joysticks.bat

Regras:
- Linhas que começam com "#" são diagnóstico: aparecem aqui, mas não vão para o jogo.
- Só repassa linhas no formato J1,x,y,sw ou J2,x,y,sw.
- Se o cabo sair, tenta reconectar sozinho a cada 2 s.
- Ctrl+C para sair.
"""
import re
import socket
import sys
import threading
import time

try:
    import serial
    from serial.tools import list_ports
except ImportError:
    print("Falta a biblioteca pyserial. Rode uma vez:  pip install pyserial")
    sys.exit(1)

UDP_HOST = "127.0.0.1"
UDP_PORT = 4210
BAUD = 115200
RETRY_SECONDS = 2.0
STATS_SECONDS = 5.0

PACKET_RE = re.compile(r"^J[12],-?\d+(\.\d+)?,-?\d+(\.\d+)?,[01]$")
# Chips USB-Serial comuns nas placas ESP32.
ESP_HINTS = ("CP210", "CH340", "CH341", "CH910", "SILICON LABS", "USB-SERIAL", "USB SERIAL", "UART")


def is_valid_packet(line: str) -> bool:
    """True se a linha for 'J1,x,y,sw' ou 'J2,x,y,sw'."""
    return bool(PACKET_RE.match(line))


class Stats:
    """Conta pacotes repassados por jogador (para mostrar a taxa na tela)."""

    def __init__(self) -> None:
        self.lock = threading.Lock()
        self.counts = {"J1": 0, "J2": 0}

    def add(self, player: str) -> None:
        with self.lock:
            self.counts[player] = self.counts.get(player, 0) + 1

    def take(self) -> dict:
        with self.lock:
            c = dict(self.counts)
            self.counts = {k: 0 for k in self.counts}
        return c


def handle_line(line: str, sock: socket.socket, stats: Stats, tag: str = "") -> None:
    """Repassa um pacote válido para o jogo; mostra o diagnóstico; ignora o resto."""
    line = line.strip()
    if not line:
        return
    if line.startswith("#"):
        print(f"{tag}{line}")
        return
    if is_valid_packet(line):
        sock.sendto(line.encode("ascii"), (UDP_HOST, UDP_PORT))
        stats.add(line[:2])


def find_esp_ports() -> list:
    """Portas que parecem ser um ESP32 (pelo nome do chip USB)."""
    found = []
    for p in list_ports.comports():
        text = f"{p.description} {p.manufacturer or ''} {p.hwid}".upper()
        if any(h in text for h in ESP_HINTS):
            found.append(p.device)
    return found


def bridge_port(port_name: str, sock: socket.socket, stats: Stats, stop: threading.Event) -> None:
    """Abre a porta serial e repassa cada linha válida por UDP. Reconecta se cair."""
    tag = f"[{port_name}] "
    while not stop.is_set():
        try:
            with serial.serial_for_url(port_name, BAUD, timeout=0.5) as ser:
                print(f"{tag}conectado. O ESP32 reinicia e calibra: NAO mexa nos joysticks por 2 s.")
                while not stop.is_set():
                    raw = ser.readline()
                    if raw:
                        handle_line(raw.decode("ascii", errors="ignore"), sock, stats, tag)
        except serial.SerialException as e:
            msg = str(e)
            if "PermissionError" in msg or "Acesso negado" in msg or "Access is denied" in msg:
                print(f"{tag}porta OCUPADA. Feche o Serial Monitor da Arduino IDE (e outros programas).")
            else:
                print(f"{tag}sem conexão ({msg.splitlines()[0] if msg else 'cabo desligado?'}).")
            print(f"{tag}tentando de novo em {RETRY_SECONDS:.0f} s...")
            stop.wait(RETRY_SECONDS)


def choose_ports(args: list) -> list:
    if args:
        return args
    while True:
        ports = find_esp_ports()
        if ports:
            print(f"ESP32 encontrado em: {', '.join(ports)}")
            return ports[:1]  # um ESP32 com os dois joysticks
        print("Nenhum ESP32 encontrado. Ligue o cabo USB (precisa ser cabo de DADOS, não só de carga).")
        print("Portas vistas:", ", ".join(f"{p.device} ({p.description})" for p in list_ports.comports()) or "nenhuma")
        time.sleep(RETRY_SECONDS)


def main() -> None:
    print(f"Cozinha Maluca - ponte USB -> jogo (UDP {UDP_HOST}:{UDP_PORT}). Ctrl+C para sair.")
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    stats = Stats()
    stop = threading.Event()
    try:
        ports = choose_ports(sys.argv[1:])
        for name in ports:
            threading.Thread(target=bridge_port, args=(name, sock, stats, stop), daemon=True).start()
        while True:
            time.sleep(STATS_SECONDS)
            c = stats.take()
            rates = "  ".join(f"{k}: {v / STATS_SECONDS:.0f}/s" for k, v in sorted(c.items()))
            print(f"repassando para o jogo -> {rates}" + ("   (nada chegando: confira o cabo e o firmware)" if not any(c.values()) else ""))
    except KeyboardInterrupt:
        print("\nSaindo.")
    finally:
        stop.set()
        sock.close()


if __name__ == "__main__":
    main()
