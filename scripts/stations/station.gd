class_name Station
extends StaticBody2D
## Base de todas as estações (caixa, bancada, tigela, forno, entrega).
## - O StaticBody2D bloqueia os chefs.
## - A InteractArea (Area2D) avisa o chef quando ele chega perto.
## - Cada tipo de estação sobrescreve interact() e get_label_text().

const SIZE := Vector2(64, 64)
const HIGHLIGHT_COLOR := Color(1.0, 0.85, 0.1)

@export var title: String = "STATION"
@export var color: Color = Color(0.55, 0.4, 0.28)

## Chefs que estão com esta estação como "a mais próxima".
var _highlighted_by: Array[Node] = []

@onready var _visual: ColorRect = $Visual
@onready var _label: Label = $Label
@onready var _slot: Marker2D = $ItemSlot


func _ready() -> void:
	_visual.color = color
	$InteractArea.body_entered.connect(_on_body_entered)
	$InteractArea.body_exited.connect(_on_body_exited)
	update_label()


## Chamado pelo chef ao apertar ação. Retorna true se algo aconteceu.
func interact(_chef: Chef) -> bool:
	return false


## Texto mostrado na estação.
func get_label_text() -> String:
	return title


func update_label() -> void:
	_label.text = get_label_text()


## Mostra um texto por um instante e depois volta ao normal.
func flash_text(text: String, seconds: float = 0.8) -> void:
	_label.text = text
	await get_tree().create_timer(seconds).timeout
	if is_inside_tree():
		update_label()


func set_highlight(chef: Node, on: bool) -> void:
	if on and chef not in _highlighted_by:
		_highlighted_by.append(chef)
	elif not on:
		_highlighted_by.erase(chef)
	queue_redraw()


func is_highlighted() -> bool:
	return not _highlighted_by.is_empty()


func _draw() -> void:
	# Contorno amarelo quando algum chef pode interagir com esta estação.
	if is_highlighted():
		draw_rect(Rect2(-SIZE / 2 - Vector2(4, 4), SIZE + Vector2(8, 8)), HIGHLIGHT_COLOR, false, 4.0)


func _on_body_entered(body: Node) -> void:
	if body is Chef:
		body.station_entered(self)


func _on_body_exited(body: Node) -> void:
	if body is Chef:
		body.station_exited(self)
