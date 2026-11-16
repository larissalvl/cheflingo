class_name Item
extends Node2D
## Um ingrediente que pode ser carregado pelo chef ou ficar numa bancada.
## Placeholder desenhado em código (troca por Sprite2D quando a arte chegar).

const SIZE := Vector2(46, 26)

## Cor de cada ingrediente.
const COLORS := {
	"FLOUR": Color(0.97, 0.95, 0.88),
	"EGGS": Color(1.0, 0.82, 0.3),
	"SUGAR": Color(0.98, 0.7, 0.85),
}

var ingredient: String = "FLOUR"


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
