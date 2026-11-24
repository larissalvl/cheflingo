extends Node2D
## Cena da cozinha. Mostra na barra de cima quem controla cada chef
## (teclado ou ESP32), para facilitar o teste do hardware.
## Ao abrir: mostra a tela inicial (MENU) ou, se veio de "Jogar de novo",
## já começa a partida. As telas ficam em scenes/ui/screens.tscn.

@onready var _hud: Label = $Hud

func _ready() -> void:
	InputManager.source_changed.connect(_on_source_changed)
	_update_hud()
	# Prepara todos os sprites antes de começar (evita engasgo no meio da partida).
	Ingredients.preload_all()
	Plates.preload_all()
	if GameState.consume_restart_request():
		GameState.start_game()
	else:
		GameState.reset()  # tela inicial


func _on_source_changed(_player: int, _source: String) -> void:
	_update_hud()


func _update_hud() -> void:
	var udp := "UDP %d ok" % InputManager.UDP_PORT if InputManager.is_udp_listening() else "UDP FECHADO"
	_hud.text = "J1: WASD + E  [%s]     |     J2: setas + Enter  [%s]     |     %s" % [
		InputManager.get_source(1), InputManager.get_source(2), udp]
