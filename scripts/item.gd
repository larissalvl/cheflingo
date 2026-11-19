class_name Item
extends Node2D
## Um ingrediente que pode estar na mão do chef, numa bancada ou no fogão.
## Tem um id (`ingredient`, ex.: "EGG") e um estado: CRU ou COZIDO.
## Mostra o sprite do estado atual (ou o placeholder) e, logo abaixo, o nome em
## inglês — o nome é o mesmo cru ou cozido. Dados vêm de Ingredients.
## O tamanho na tela é sempre o mesmo, não importa a escala de quem segura.

enum State { CRU, COZIDO }

const ICON_SIZE := 56.0
const NAME_FONT_SIZE := 22
const NAME_GAP := 4.0
const NAME_COLOR := Color(1.0, 0.97, 0.9)
const OUTLINE_COLOR := Color(0.1, 0.05, 0.0)
const OUTLINE_SIZE := 7

## Id do ingrediente (chave de Ingredients.DATA).
var ingredient: String = "EGG"
var state: State = State.CRU
## false = desenha só o nome (usado no fogão quando a frigideira já mostra a comida).
var show_icon: bool = true:
	set(value):
		show_icon = value
		queue_redraw()


static func create(ingredient_name: String) -> Item:
	var item := Item.new()
	item.ingredient = ingredient_name
	item.name = ingredient_name.capitalize()
	return item


func is_cooked() -> bool:
	return state == State.COZIDO


## Muda para COZIDO (true) ou CRU (false) e troca o sprite.
func set_cooked(cooked: bool) -> void:
	state = State.COZIDO if cooked else State.CRU
	queue_redraw()


func _ready() -> void:
	z_index = 5  # sempre por cima de chefs e estações
	queue_redraw()


func _process(_delta: float) -> void:
	# Anula a escala herdada (bancadas aumentadas, pulinho do chef): tamanho fixo.
	if not global_scale.is_equal_approx(Vector2.ONE):
		global_scale = Vector2.ONE


func _draw() -> void:
	var box := Rect2(Vector2(-ICON_SIZE, -ICON_SIZE) / 2, Vector2(ICON_SIZE, ICON_SIZE))
	if show_icon:
		Ingredients.draw_icon(self, ingredient, is_cooked(), box)
	draw_label(self, Ingredients.english(ingredient),
		Vector2(0, ICON_SIZE / 2 + NAME_GAP), NAME_FONT_SIZE)


## Escreve `text` centralizado, com contorno, começando (topo) em `top_center`.
static func draw_label(canvas: CanvasItem, text: String, top_center: Vector2, font_size: int) -> void:
	var font := ThemeDB.fallback_font
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var pos := Vector2(top_center.x - w / 2, top_center.y + font.get_ascent(font_size))
	var outline := maxi(4, int(font_size * 0.32))
	canvas.draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, outline, OUTLINE_COLOR)
	canvas.draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, NAME_COLOR)
