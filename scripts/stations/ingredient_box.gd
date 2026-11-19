class_name IngredientBox
extends Station
## Caixa de ingrediente: chef de mão vazia aperta ação e recebe 1 item.
## Se o ingrediente tem `box_sprite` em Ingredients, a caixa desenha esse sprite
## e o nome em inglês embaixo. Senão fica o retângulo colorido (egg e bacon usam
## as caixas desenhadas no fundo).

## Tamanho da caixa desenhada na tela.
const BOX_DRAW_SIZE := 84.0

@export var ingredient: String = "EGG"
## Nome do arquivo de sprite que ainda falta. Se preenchido e o sprite não
## existir, aparece no rótulo (a caixa vira um placeholder).
@export var placeholder_sprite: String = ""

var _box_tex: Texture2D = null


func _ready() -> void:
	_box_tex = Ingredients.box_icon(ingredient)
	super()
	if _box_tex != null:
		_visual.visible = false
		highlight_size = Vector2(BOX_DRAW_SIZE, BOX_DRAW_SIZE)
		# Nome embaixo da caixa, um pouco maior.
		_label.position = Vector2(-60, BOX_DRAW_SIZE / 2 - 6)
		_label.size = Vector2(120, 24)
		_label.add_theme_font_size_override("font_size", 18)
		update_label()
		queue_redraw()


func get_label_text() -> String:
	if _box_tex != null:
		return Ingredients.english(ingredient)
	if placeholder_sprite != "":
		return "%s\n%s" % [ingredient, placeholder_sprite]
	return ingredient


func interact(chef: Chef) -> bool:
	if chef.has_item():
		return false
	chef.hold(Item.create(ingredient))
	return true


func _draw() -> void:
	if _box_tex != null:
		var s := Vector2(BOX_DRAW_SIZE, BOX_DRAW_SIZE)
		Ingredients.draw_texture_fit(self, _box_tex, Rect2(-s / 2, s))
	super()
