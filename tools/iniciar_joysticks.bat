@echo off
REM Cozinha Maluca - liga os joysticks (ESP32 pelo cabo USB) ao jogo.
REM Deixe esta janela aberta enquanto joga. Para sair: feche a janela ou Ctrl+C.
cd /d "%~dp0"
python serial_to_udp.py %*
if errorlevel 1 pause
