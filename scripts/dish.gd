class_name Dish
extends Item
## Prato montado: pode ir para a mão do chef, para uma bancada ou para o balcão.
## É um Item (o chef e as bancadas já sabem carregá-lo, e o tamanho não muda com
## a escala de quem segura), mas em vez de um ingrediente desenha:
## - o sprite do prato que corresponde EXATAMENTE aos itens (id + cru/cozido),
##   pela tabela de plates.gd;
## - sem sprite para essa combinação: o prato vazio com os ícones dos itens em cima;
## - sempre, ao lado direito, a lista dos itens (ícone + nome em inglês).
## O visual não muda a validação da entrega (ver OrderManager.submit_dish).

const PLATE_COLOR := Color(0.95, 0.92, 0.85)
## Largura do prato na tela (com ou sem itens).
const PLATE_WIDTH := 124.0
## Altura do prato placeholder (proporção dos sprites de prato).
const PLACEHOLDER_HEIGHT := 84.0
## Ícones em cima do prato vazio (quando a combinação não tem sprite).
const ON_PLATE_ICON := 40.0
## Lista ao lado do prato.
const LIST_GAP := 6.0
const LIST_ICON := 28.0
const LIST_ROW_H := 31.0
const LIST_FONT_SIZE := 17
const LIST_BG := Color(0.08, 0.04, 0.02, 0.55)

## Ingredientes no prato, na ordem em que entraram: [{"id": "EGG", "cooked": true}, ...]
var entries: Array = []


static func create_empty() -> Dish:
	var dish := Dish.new()
	dish.ingredient = "PLATE"
	dish.name = "Dish"
	return dish


func is_empty() -> bool:
	return entries.is_empty()


func has_ingredient(id: String) -> bool:
	for e in entries:
		if e["id"] == id:
			return true
	return false


## Põe um ingrediente no prato (o nó do item é descartado; o prato guarda id + estado).
func add(it: Item) -> void:
	entries.append({"id": it.ingredient, "cooked": it.is_cooked()})
	it.queue_free()
	queue_redraw()


func clear() -> void:
	entries.clear()
	queue_redraw()


## Ids de todos os ingredientes do prato.
func ids() -> Array:
	var result: Array = []
	for e in entries:
		result.append(e["id"])
	return result


## Ids dos ingredientes cozinháveis que ainda estão crus.
func raw_ids() -> Array:
	var result: Array = []
	for e in entries:
		if Ingredients.is_cookable(e["id"]) and not e["cooked"]:
			result.append(e["id"])
	return result


## Itens no formato da tabela de pratos: {"EGG": true, "BUN": false}.
func items_dict() -> Dictionary:
	var result := {}
	for e in entries:
		result[e["id"]] = Ingredients.is_cookable(e["id"]) and e["cooked"]
	return result


## true se a combinação atual tem sprite de prato próprio.
func has_combo_sprite() -> bool:
	return not is_empty() and Plates.texture_for(items_dict()) != null


func _draw() -> void:
	var n := entries.size()
	var combo_tex: Texture2D = Plates.texture_for(items_dict()) if n > 0 else null

	var plate_rect: Rect2
	if combo_tex != null:
		# Sprite da combinação exata.
		plate_rect = _rect_for_width(combo_tex, PLATE_WIDTH)
		draw_texture_rect(combo_tex, plate_rect, false)
	else:
		# Prato vazio (sprite ou placeholder) + ícones dos itens em cima.
		plate_rect = _draw_empty_plate(n == 0)
		_draw_icons_on_plate(plate_rect)

	if n == 0:
		draw_label(self, "plate", Vector2(0, plate_rect.end.y + 2), 18)
		return
	_draw_list(Vector2(plate_rect.end.x + LIST_GAP, 0))


## Desenha o prato vazio centralizado e devolve o retângulo dele.
func _draw_empty_plate(full_placeholder_text: bool) -> Rect2:
	var tex := Plates.empty_texture()
	if tex != null:
		var r := _rect_for_width(tex, PLATE_WIDTH)
		draw_texture_rect(tex, r, false)
		return r
	var rect := Rect2(Vector2(-PLATE_WIDTH, -PLACEHOLDER_HEIGHT) / 2, Vector2(PLATE_WIDTH, PLACEHOLDER_HEIGHT))
	if full_placeholder_text:
		Ingredients.draw_placeholder(self, rect, PLATE_COLOR, Plates.EMPTY_FILE)
	else:
		# Com itens em cima: o nome do arquivo esperado vai pequeno, no rodapé.
		draw_rect(rect, PLATE_COLOR)
		draw_rect(rect, Ingredients.PLACEHOLDER_OUTLINE, false, 2.0)
		var font := ThemeDB.fallback_font
		var w := font.get_string_size(Plates.EMPTY_FILE, HORIZONTAL_ALIGNMENT_LEFT, -1, 9).x
		draw_string(font, Vector2(-w / 2, rect.end.y - 3), Plates.EMPTY_FILE,
			HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Ingredients.PLACEHOLDER_TEXT)
	return rect


## Ícones dos itens organizados em grade de 2 colunas dentro do prato.
func _draw_icons_on_plate(plate_rect: Rect2) -> void:
	var n := entries.size()
	if n == 0:
		return
	var cols := 1 if n == 1 else 2
	var rows := ceili(n / float(cols))
	var area := plate_rect.grow_individual(-12, -8, -12, -14)
	var cell := Vector2(area.size.x / cols, area.size.y / rows)
	var s := minf(ON_PLATE_ICON, minf(cell.x, cell.y))
	for i in n:
		var col := i % cols
		var row := i / cols
		# Última linha com 1 item só fica centralizada.
		var cols_in_row := cols if (row < rows - 1 or n % cols == 0) else n % cols
		var x := area.position.x + (area.size.x - cols_in_row * cell.x) / 2 + (col + 0.5) * cell.x
		var y := area.position.y + (row + 0.5) * cell.y
		Ingredients.draw_icon(self, entries[i]["id"], entries[i]["cooked"],
			Rect2(Vector2(x, y) - Vector2(s, s) / 2, Vector2(s, s)))


## Lista (ícone + nome em inglês), uma linha por item, centralizada na altura.
func _draw_list(left_middle: Vector2) -> void:
	var n := entries.size()
	var font := ThemeDB.fallback_font
	var widest := 0.0
	for e in entries:
		widest = maxf(widest, font.get_string_size(Ingredients.english(e["id"]),
			HORIZONTAL_ALIGNMENT_LEFT, -1, LIST_FONT_SIZE).x)
	var total_h := n * LIST_ROW_H
	var top := left_middle.y - total_h / 2
	var bg := Rect2(left_middle.x, top - 3, LIST_ICON + 6 + widest + 10, total_h + 6)
	draw_style_box(_list_style(), bg)
	for i in n:
		var row_mid := top + (i + 0.5) * LIST_ROW_H
		var icon_rect := Rect2(Vector2(left_middle.x + 4, row_mid - LIST_ICON / 2), Vector2(LIST_ICON, LIST_ICON))
		Ingredients.draw_icon(self, entries[i]["id"], entries[i]["cooked"], icon_rect)
		var pos := Vector2(icon_rect.end.x + 6,
			row_mid - font.get_height(LIST_FONT_SIZE) / 2 + font.get_ascent(LIST_FONT_SIZE))
		var text := Ingredients.english(entries[i]["id"])
		draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, LIST_FONT_SIZE, 5, OUTLINE_COLOR)
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, LIST_FONT_SIZE, NAME_COLOR)


static var _style: StyleBoxFlat

static func _list_style() -> StyleBoxFlat:
	if _style == null:
		_style = StyleBoxFlat.new()
		_style.bg_color = LIST_BG
		_style.set_corner_radius_all(8)
	return _style


## Retângulo centralizado com a largura pedida e a proporção da textura.
static func _rect_for_width(tex: Texture2D, width: float) -> Rect2:
	var s := tex.get_size() * (width / tex.get_size().x)
	return Rect2(-s / 2, s)
