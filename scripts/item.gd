class_name Item
extends Node2D
## Um ingrediente que pode ser carregado pelo chef ou ficar numa bancada.
## Mostra o sprite (ou um retângulo colorido, se ainda não houver arte) e,
## logo abaixo, o nome em inglês — para a criança associar desenho e palavra.
## Sprite, cor e nome vêm de Ingredients (scripts/ingredients.gd).
## O tamanho na tela é sempre o mesmo, não importa a escala de quem segura.

const ICON_SIZE := 56.0
const NAME_FONT_SIZE := 22
const NAME_GAP := 4.0
const NAME_COLOR := Color(1.0, 0.97, 0.9)
const OUTLINE_COLOR := Color(0.1, 0.05, 0.0)
const OUTLINE_SIZE := 7

var ingredient: String = "EGG"

var _texture: Texture2D = null


static func create(ingredient_name: String) -> Item:
	var item := Item.new()
	item.ingredient = ingredient_name
	item.name = ingredient_name.capitalize()
	return item


func _ready() -> void:
	z_index = 5  # sempre por cima de chefs e estações
	_texture = Ingredients.icon(ingredient)
	queue_redraw()


func _process(_delta: float) -> void:
	# Anula a escala herdada (bancadas aumentadas, pulinho do chef): tamanho fixo.
	if not global_scale.is_equal_approx(Vector2.ONE):
		global_scale = Vector2.ONE


func _draw() -> void:
	# Ícone centralizado na origem do item.
	var box := Rect2(Vector2(-ICON_SIZE, -ICON_SIZE) / 2, Vector2(ICON_SIZE, ICON_SIZE))
	if _texture != null:
		var tex_size := _texture.get_size()
		var k := minf(ICON_SIZE / tex_size.x, ICON_SIZE / tex_size.y)
		var draw_size := tex_size * k
		draw_texture_rect(_texture, Rect2(-draw_size / 2, draw_size), false)
	else:
		draw_rect(box, Ingredients.color(ingredient))
		draw_rect(box, OUTLINE_COLOR, false, 2.0)

	# Nome em inglês logo abaixo do ícone.
	var font := ThemeDB.fallback_font
	var text := Ingredients.english(ingredient)
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, NAME_FONT_SIZE)
	var pos := Vector2(-text_size.x / 2, ICON_SIZE / 2 + NAME_GAP + font.get_ascent(NAME_FONT_SIZE))
	draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, NAME_FONT_SIZE, OUTLINE_SIZE, OUTLINE_COLOR)
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, NAME_FONT_SIZE, NAME_COLOR)
