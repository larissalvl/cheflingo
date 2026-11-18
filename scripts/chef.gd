class_name Chef
extends CharacterBody2D
## Chef controlado por um jogador. Placeholder desenhado em código até a arte chegar.
## Interage só com a estação mais próxima dentro do alcance.

@export var player_id: int = 1
@export var color: Color = Color(0.9, 0.3, 0.3)
@export var speed: float = 320.0

const RADIUS := 24.0

var held_item: Item = null

## Estações cuja área de interação o chef está tocando.
var _stations_in_reach: Array[Station] = []
var _nearest: Station = null

@onready var _hold_point: Marker2D = $HoldPoint

func _ready():
	if player_id == 1:
		$AnimatedSprite2D.set_animation("raposa")
	else:
		$AnimatedSprite2D.set_animation("esquilo")


func _physics_process(_delta: float) -> void:
	velocity = InputManager.get_move(player_id) * speed
	move_and_slide()

	_update_nearest()
	if InputManager.is_action_just_pressed(player_id) and _nearest != null:
		if _nearest.interact(self):
			_pulse()


# ---------------- itens ----------------

func has_item() -> bool:
	return held_item != null


## Coloca um item na mão (em cima da cabeça).
func hold(item: Item) -> void:
	held_item = item
	if item.get_parent() != null:
		item.reparent(_hold_point, false)
	else:
		_hold_point.add_child(item)
	item.position = Vector2.ZERO


## Tira o item da mão e devolve (quem chamou decide onde ele vai).
func take_item() -> Item:
	var item := held_item
	held_item = null
	return item


# ---------------- estações ----------------

func station_entered(station: Station) -> void:
	if station not in _stations_in_reach:
		_stations_in_reach.append(station)


func station_exited(station: Station) -> void:
	_stations_in_reach.erase(station)


func get_nearest_station() -> Station:
	return _nearest


func _update_nearest() -> void:
	var best: Station = null
	var best_dist := INF
	for s in _stations_in_reach:
		var d := global_position.distance_squared_to(s.global_position)
		if d < best_dist:
			best_dist = d
			best = s
	if best != _nearest:
		if _nearest != null:
			_nearest.set_highlight(self, false)
		if best != null:
			best.set_highlight(self, true)
		_nearest = best


# ---------------- visual ----------------

## Pulinho para confirmar que a ação funcionou.
func _pulse() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.06)
	tween.tween_property(self, "scale", Vector2.ONE, 0.10)
