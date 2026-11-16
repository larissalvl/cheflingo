extends Node2D
## Cena da cozinha. Por enquanto só mostra na barra de cima quem controla cada chef
## (teclado ou ESP32), para facilitar o teste do hardware.

@onready var _hud: Label = $Hud


func _ready() -> void:
	InputManager.source_changed.connect(func(_p, _s): _update_hud())
	_update_hud()


func _update_hud() -> void:
	var udp := "UDP %d ok" % InputManager.UDP_PORT if InputManager.is_udp_listening() else "UDP FECHADO"
	_hud.text = "J1: WASD + E  [%s]     |     J2: setas + Enter  [%s]     |     %s" % [
		InputManager.get_source(1), InputManager.get_source(2), udp]
