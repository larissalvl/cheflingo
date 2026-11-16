"""Simula um ESP32 mandando pacotes UDP para o jogo, sem hardware.

Uso (com o jogo rodando):
    python tools/fake_joystick.py          # simula o J1
    python tools/fake_joystick.py J2       # simula o J2

O chef anda em círculo por 6 segundos, aperta o botão de ação 3 vezes e para.
Depois que o script termina, o jogo volta para o teclado em 0,5 s.
Só usa a biblioteca padrão do Python.
"""
import math
import socket
import sys
import time

HOST = "127.0.0.1"
PORT = 4210
HZ = 50


def main() -> None:
    player = sys.argv[1] if len(sys.argv) > 1 else "J1"
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    print(f"Enviando {player} para {HOST}:{PORT} a {HZ} Hz por 6 s...")
    start = time.time()
    while (t := time.time() - start) < 6.0:
        x = math.cos(t * 2.0)
        y = math.sin(t * 2.0)
        sw = 1 if (t % 2.0) < 0.15 else 0      # aperta a cada 2 s
        packet = f"{player},{x:.2f},{y:.2f},{sw}"
        sock.sendto(packet.encode("ascii"), (HOST, PORT))
        time.sleep(1 / HZ)
    print("Fim. O jogo deve voltar para o teclado.")


if __name__ == "__main__":
    main()
