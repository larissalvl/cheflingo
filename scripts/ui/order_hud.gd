extends CanvasLayer
## Menu do pedido atual (canto superior esquerdo) e dica de erro (centro inferior).
## O menu mostra só o inglês; a tradução aparece apenas na dica, depois de um erro.

const ICON_SIZE := Vector2(48, 48)
const ROW_FONT_SIZE := 30
const CHECK_SECONDS := 1.0
const HINT_SECONDS := 3.0
const CHECK_COLOR := Color(0.25, 0.9, 0.3)
const CHECK_OUTLINE := Color(0.02, 0.2, 0.02)

## Aumenta a cada ✔/dica para um timer antigo não esconder o novo.
var _check_gen := 0
var _hint_gen := 0
var _showing_check := false

@onready var _order_panel: PanelContainer = $OrderPanel
@onready var _content: VBoxContainer = $OrderPanel/Content
@onready var _title: Label = $OrderPanel/Content/Title
@onready var _rows: VBoxContainer = $OrderPanel/Content/Rows
## O ✔ é desenhado com linhas (o caractere vira emoji colorido no Windows).
@onready var _check: Control = $OrderPanel/Check
@onready var _hint_panel: PanelContainer = $HintPanel
@onready var _hint_label: Label = $HintPanel/HintLabel


func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	OrderManager.order_changed.connect(_on_order_changed)
	OrderManager.order_delivered_ok.connect(_on_delivered_ok)
	OrderManager.order_delivered_wrong.connect(_on_delivered_wrong)
	_check.visible = false
	_check.draw.connect(_draw_check)
	_hint_panel.visible = false
	_refresh()
	_on_state_changed(GameState.state)


# ---------------- sinais ----------------

func _on_state_changed(new_state: GameState.State) -> void:
	var playing := new_state == GameState.State.JOGANDO
	_order_panel.visible = playing
	if not playing:
		_hide_hint()
	else:
		_cancel_check()
		_refresh()


func _on_order_changed(_index: int, _items: Array) -> void:
	# Durante o ✔ a troca espera; o _refresh roda quando o ✔ some.
	if not _showing_check:
		_refresh()


func _on_delivered_ok() -> void:
	_hide_hint()
	_check_gen += 1
	var gen := _check_gen
	_showing_check = true
	_check.visible = true
	_content.modulate.a = 0.3
	await get_tree().create_timer(CHECK_SECONDS).timeout
	if gen == _check_gen:
		_cancel_check()
		_refresh()


func _on_delivered_wrong(missing: Array, extra: Array) -> void:
	var lines: Array[String] = []
	if not missing.is_empty():
		lines.append("Faltou: " + _translate_list(missing))
	if not extra.is_empty():
		lines.append("Sobrou: " + _translate_list(extra))
	_hint_label.text = "\n".join(lines)
	_hint_panel.visible = true
	_hint_gen += 1
	var gen := _hint_gen
	await get_tree().create_timer(HINT_SECONDS).timeout
	if gen == _hint_gen:
		_hide_hint()


# ---------------- desenho ----------------

## Redesenha o painel com o pedido atual do OrderManager.
func _refresh() -> void:
	for child in _rows.get_children():
		child.queue_free()
	if OrderManager.current_index == 0:
		_title.text = "Pedido"
		return
	_title.text = "Pedido %d" % OrderManager.current_index
	for id in OrderManager.current_items:
		_rows.add_child(_make_row(id))


## Uma linha: ícone (sprite ou retângulo colorido) + nome em inglês.
func _make_row(id: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var tex := Ingredients.icon(id)
	if tex != null:
		var icon := TextureRect.new()
		icon.texture = tex
		icon.custom_minimum_size = ICON_SIZE
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		row.add_child(icon)
	else:
		var placeholder := ColorRect.new()
		placeholder.color = Ingredients.color(id)
		placeholder.custom_minimum_size = ICON_SIZE
		row.add_child(placeholder)

	var label := Label.new()
	label.text = Ingredients.english(id)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", ROW_FONT_SIZE)
	label.add_theme_color_override("font_color", Color(1.0, 0.97, 0.9))
	label.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.0))
	label.add_theme_constant_override("outline_size", 6)
	row.add_child(label)
	return row


## Desenha o ✔ verde no centro do painel.
func _draw_check() -> void:
	var s := minf(_check.size.x, _check.size.y) * 0.8
	var c := _check.size / 2
	var pts := PackedVector2Array([
		c + Vector2(-0.4, 0.0) * s,
		c + Vector2(-0.12, 0.28) * s,
		c + Vector2(0.42, -0.3) * s,
	])
	_check.draw_polyline(pts, CHECK_OUTLINE, s * 0.22, true)
	_check.draw_polyline(pts, CHECK_COLOR, s * 0.14, true)


## "ovo (egg), alface (lettuce)"
func _translate_list(ids: Array) -> String:
	var parts: Array[String] = []
	for id in ids:
		parts.append("%s (%s)" % [Ingredients.portuguese(id), Ingredients.english(id)])
	return ", ".join(parts)


func _cancel_check() -> void:
	_check_gen += 1
	_showing_check = false
	_check.visible = false
	_content.modulate.a = 1.0


func _hide_hint() -> void:
	_hint_gen += 1
	_hint_panel.visible = false
