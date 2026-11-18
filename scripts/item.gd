class_name Item
extends Node2D
## Um ingrediente que pode ser carregado pelo chef ou ficar numa bancada.
## Placeholder desenhado em código (troca por Sprite2D quando a arte chegar).

const SIZE := Vector2(46, 26)

## Cor de cada ingrediente.
const COLORS := {
	"EGG": Color(1.0, 0.82, 0.3),
	"BACON": Color(0.85, 0.35, 0.3),
	"BEEF PATTY": Color(0.5, 0.3, 0.18),
	"LETTUCE": Color(0.45, 0.8, 0.35),
}

var ingredient: String = "EGG"


static func create(ingredient_name: String) -> Item:
	var item := Item.new()
	item.ingredient = ingredient_name
	item.name = ingredient_name.capitalize()
	return item


func _ready() -> void:
	z_index = 5  # sempre por cima de chefs e estações


func _draw() -> void:
	var rect := Rect2(-SIZE / 2, SIZE)
	draw_rect(rect, COLORS.get(ingredient, Color.GRAY))
	draw_rect(rect, Color(0.25, 0.15, 0.05), false, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(-SIZE.x / 2, 5), ingredient,
		HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 11, Color(0.25, 0.15, 0.05))
