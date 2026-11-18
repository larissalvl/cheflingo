extends Node2D
## Cena da cozinha. Mostra na barra de cima quem controla cada chef
## (teclado ou ESP32), para facilitar o teste do hardware.
## Enquanto a tela inicial não existe, a partida começa assim que a cozinha abre.

@onready var _hud: Label = $Hud


func _ready() -> void:
	InputManager.source_changed.connect(func(_p, _s): _update_hud())
	_update_hud()
	GameState.start_game()


func _update_hud() -> void:
	var udp := "UDP %d ok" % InputManager.UDP_PORT if InputManager.is_udp_listening() else "UDP FECHADO"
	_hud.text = "J1: WASD + E  [%s]     |     J2: setas + Enter  [%s]     |     %s" % [
		InputManager.get_source(1), InputManager.get_source(2), udp]


# DEBUG: remover antes da entrega
# F1 = vitória, F2 = game over, F3 = reinicia a partida.
func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_F1:
			GameState.win()
		KEY_F2:
			GameState.lose()
		KEY_F3:
			GameState.start_game()
