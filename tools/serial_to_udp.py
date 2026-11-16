"""PLANO B (estrutura pronta, implementação no D9): Serial USB -> UDP local.

Quando o Wi-Fi falhar, o ESP32 roda em SERIAL_ONLY=true e imprime "J1,x,y,sw"
no Serial. Este script lê essas linhas pela USB e repassa cada uma por UDP para
127.0.0.1:4210. A Godot não muda nada: ela continua só escutando UDP.

Uso planejado:
    pip install pyserial
    python tools/serial_to_udp.py COM5            # um ESP32
    python tools/serial_to_udp.py COM5 COM6       # dois ESP32 (J1 e J2)

Regras:
- Linhas que começam com "#" são diagnóstico e são ignoradas.
- Só repassa linhas no formato J1,x,y,sw ou J2,x,y,sw.
"""
import sys

UDP_HOST = "127.0.0.1"
UDP_PORT = 4210
BAUD = 115200


def is_valid_packet(line: str) -> bool:
    """True se a linha for 'J1,x,y,sw' ou 'J2,x,y,sw'."""
    raise NotImplementedError("Plano B: implementar no D9")


def bridge_port(port_name: str) -> None:
    """Abre a porta serial e repassa cada linha válida por UDP (uma thread por porta)."""
    raise NotImplementedError("Plano B: implementar no D9")


def main() -> None:
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    raise NotImplementedError("Plano B: implementar no D9")


if __name__ == "__main__":
    main()
