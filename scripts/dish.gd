class_name Dish
extends Item
## Prato montado: pode ir para a mão do chef, para uma bancada ou para o balcão.
## É um Item (o chef e as bancadas já sabem carregá-lo), mas em vez de um
## ingrediente desenha o prato com os ingredientes por cima, cada um com
## sprite + nome em inglês, em grade de 2 colunas.

const PLATE_SPRITE := "res://sprites/pratoVazio.PNG"
const PLATE_FILE := "pratoVazio.PNG"
const PLATE_COLOR := Color(0.95, 0.92, 0.85)
const EMPTY_PLATE_WIDTH := 84.0
const CELL := Vector2(82, 64)
const CELL_ICON := 38.0
const CELL_FONT_SIZE := 16

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


func _draw() -> void:
	var n := entries.size()
	var cols := 1 if n <= 1 else 2
	var rows := maxi(1, ceili(n / float(cols)))
	var grid := Vector2(cols * CELL.x, rows * CELL.y)

	# Prato por baixo, do tamanho da grade (ou pequeno, se vazio).
	var plate_w := EMPTY_PLATE_WIDTH if n == 0 else grid.x + 20.0
	var plate_rect := Rect2(Vector2(-plate_w / 2, -plate_w * 0.33), Vector2(plate_w, plate_w * 0.66))
	if n > 0:
		plate_rect = Rect2(-grid / 2 - Vector2(10, 4), grid + Vector2(20, 8))
	var plate_tex := Ingredients.cropped(PLATE_SPRITE)
	if plate_tex != null:
		if n == 0:
			Ingredients.draw_texture_fit(self, plate_tex, plate_rect)
		else:
			draw_texture_rect(plate_tex, plate_rect, false)
	else:
		Ingredients.draw_placeholder(self, plate_rect, PLATE_COLOR, PLATE_FILE)

	if n == 0:
		draw_label(self, "plate", Vector2(0, plate_rect.end.y + 2), 18)
		return

	for i in n:
		var col := i % cols
		var row := i / cols
		var center := Vector2((col - (cols - 1) / 2.0) * CELL.x, (row - (rows - 1) / 2.0) * CELL.y)
		var icon_rect := Rect2(center + Vector2(-CELL_ICON / 2, -CELL.y / 2 + 2), Vector2(CELL_ICON, CELL_ICON))
		Ingredients.draw_icon(self, entries[i]["id"], entries[i]["cooked"], icon_rect)
		draw_label(self, Ingredients.english(entries[i]["id"]), Vector2(center.x, icon_rect.end.y), CELL_FONT_SIZE)
