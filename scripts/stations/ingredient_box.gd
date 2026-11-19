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
## Área de alcance do chef. (0, 0) = padrão da estação (112×112).
## As caixas de egg e bacon ficam no meio da ilha: o alcance delas é mais alto e
## deslocado para baixo, para o chef alcançar pela frente da ilha.
@export var reach_size: Vector2 = Vector2.ZERO
@export var reach_offset: Vector2 = Vector2.ZERO

var _box_tex: Texture2D = null


func _ready() -> void:
	_box_tex = Ingredients.box_icon(ingredient)
	super()
	_apply_reach()
	# Retângulo colorido só aparece como placeholder (sprite da caixa faltando).
	# Egg e bacon não têm sprite de caixa porque a caixa já está desenhada no fundo.
	if _box_tex != null or Ingredients.DATA.get(ingredient, {}).get("box_sprite", "") == "":
		_visual.visible = false
	if _box_tex != null:
		_visual.visible = false
		highlight_size = Vector2(BOX_DRAW_SIZE, BOX_DRAW_SIZE)
		# Nome embaixo da caixa, um pouco maior.
		_label.position = Vector2(-60, BOX_DRAW_SIZE / 2 - 6)
		_label.size = Vector2(120, 24)
		_label.add_theme_font_size_override("font_size", 18)
		update_label()
		queue_redraw()


## Aplica reach_size / reach_offset numa cópia da forma (a original é
## compartilhada por todas as estações).
func _apply_reach() -> void:
	if reach_size == Vector2.ZERO:
		return
	var area_shape: CollisionShape2D = $InteractArea/CollisionShape2D
	var rect := RectangleShape2D.new()
	rect.size = reach_size
	area_shape.shape = rect
	area_shape.position = reach_offset


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
