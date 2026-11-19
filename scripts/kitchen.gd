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


# DEBUG: remover antes da entrega
# F1 = vitória, F2 = game over, F3 = reinicia a partida (igual a "Jogar de novo"),
# 7 = fogão: vazia -> cru -> cozido -> vazia, 8 = entrega o pedido certo, 9 = entrega um pedido errado.
func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_F1:
			GameState.win()
		KEY_F2:
			GameState.lose()
		KEY_F3:
			GameState.restart_game()
		KEY_7, KEY_KP_7:
			_debug_cycle_stove()
		KEY_8, KEY_KP_8:
			OrderManager.submit_dish(OrderManager.current_items.duplicate())
		KEY_9, KEY_KP_9:
			OrderManager.submit_dish(_debug_wrong_dish())


# DEBUG: remover antes da entrega
# Fogão: frigideira vazia -> com cru -> com cozido -> vazia (cada volta um ingrediente).
func _debug_cycle_stove() -> void:
	var stove: Stove = $Stations/Stove
	stove.debug_cycle()


# DEBUG: remover antes da entrega
# Pedido atual sem o último item e com um ingrediente a mais (se houver algum fora do pedido).
func _debug_wrong_dish() -> Array:
	var dish := OrderManager.current_items.duplicate()
	dish.pop_back()
	for id in Ingredients.ids():
		if id not in OrderManager.current_items:
			dish.append(id)
			break
	return dish
