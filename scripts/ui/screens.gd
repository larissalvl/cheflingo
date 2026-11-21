extends CanvasLayer
## Telas do jogo: inicial (MENU), instruções, vitória e game over. Só nós de UI do Godot.
## Mostra a tela certa ouvindo GameState.state_changed. A tela de instruções
## é aberta pelo botão do menu (não é um estado do GameState); Voltar ou Esc
## retornam ao menu.
##
## Navegação SEM mouse, pelos dois jogadores (via InputManager, então vale
## teclado e joystick/ESP32):
##   - mover para cima/baixo (ou esquerda/direita) troca o botão em foco;
##   - botão de ação (E, Enter ou SW do joystick) aperta o botão em foco.
## O mouse também funciona (clique).
## As ações nativas da Godot (ui_accept, ui_up...) são bloqueadas aqui para o
## Enter não apertar o botão duas vezes.

const DIM_COLOR := Color(0.05, 0.02, 0.0, 0.62)
const PANEL_COLOR := Color(0.16, 0.08, 0.04, 0.95)
const PANEL_BORDER := Color(1.0, 0.75, 0.3)
const TITLE_COLOR := Color(1.0, 0.85, 0.35)
const TEXT_COLOR := Color(1.0, 0.97, 0.9)
const OUTLINE_COLOR := Color(0.1, 0.05, 0.0)
const BUTTON_COLOR := Color(0.85, 0.42, 0.12)
const BUTTON_HOVER := Color(0.95, 0.52, 0.18)
const FOCUS_BORDER := Color(1.0, 0.95, 0.2)
const BUTTON_SIZE := Vector2(360, 76)
## Ao abrir uma tela, ignora o botão de ação por este tempo (o mesmo clique que
## entregou o último prato não pode apertar "Jogar de novo" sem querer).
const INPUT_DELAY_MS := 700
## Quanto o joystick precisa inclinar para trocar de botão.
const NAV_THRESHOLD := 0.6
const UI_ACTIONS := ["ui_accept", "ui_select", "ui_up", "ui_down", "ui_left", "ui_right",
	"ui_focus_next", "ui_focus_prev", "ui_cancel"]

# Tela de instruções
const PAGE_INSTRUCTIONS := "instructions"
const TAB_KEYBOARD := 0
const TAB_JOYSTICK := 1
const TAB_BUTTON_SIZE := Vector2(260, 64)
## Aba não selecionada: botão mais apagado.
const TAB_OFF_COLOR := Color(0.45, 0.3, 0.2)
## Trocar de aba não precisa da espera longa das outras telas.
const TAB_INPUT_DELAY_MS := 200
const CARD_COLOR := Color(0.1, 0.05, 0.02, 0.9)
const KEY_COLOR := Color(0.96, 0.92, 0.84)
const KEY_TEXT := Color(0.15, 0.08, 0.03)
const KEY_SIZE := 54.0
## Cores dos chefs (as mesmas de scenes/kitchen.tscn).
const J1_COLOR := Color(0.95, 0.4, 0.35)
const J2_COLOR := Color(0.45, 0.65, 1.0)
const BODY_SIZE := 26

## Tela aberta agora ("" = menu/vitória/game over; PAGE_INSTRUCTIONS = instruções).
var _page := ""
var _buttons: Array[Button] = []
var _focus := 0
var _ignore_until_ms := 0
## Direção do joystick no frame anterior, por jogador (para trocar 1 botão por inclinada).
var _prev_dir := {1: 0, 2: 0}

var _dim: ColorRect
var _box: VBoxContainer
var _stars: Control
var _stars_count := 0


func _ready() -> void:
	layer = 20
	_build_base()
	GameState.state_changed.connect(_on_state_changed)
	_on_state_changed(GameState.state)


func _exit_tree() -> void:
	# As estrelas ficam fora da árvore quando a tela não é a de vitória: libera aqui.
	if is_instance_valid(_stars) and _stars.get_parent() == null:
		_stars.free()


# ---------------- telas ----------------

func _on_state_changed(new_state: GameState.State) -> void:
	match new_state:
		GameState.State.MENU:
			_show_menu()
		GameState.State.VITORIA:
			_show_victory()
		GameState.State.GAME_OVER:
			_show_game_over()
		_:
			_hide()


## focus_index: botão que começa em foco (1 = "Instruções", ao voltar de lá).
func _show_menu(focus_index: int = 0) -> void:
	_clear()
	_add_label("Cheflingo", 84, TITLE_COLOR)
	_add_label("Cozinhem juntos e aprendam os nomes em inglês!", 26, TEXT_COLOR)
	_add_spacer(16)
	_add_button("Jogar", _on_play)
	_add_button("Instruções", _on_instructions)
	_add_spacer(8)
	_add_label("J1: W A S D + E      J2: setas + Enter      (ou joystick + botão)", 18, TEXT_COLOR)
	_open(focus_index)


## Tela de instruções (só a partir do menu). tab: TAB_KEYBOARD ou TAB_JOYSTICK.
## Botões: [Teclado] [Joystick] (abas) e [Voltar]. Esc também volta.
func _show_instructions(tab: int, focus_index: int = 0) -> void:
	_clear()
	_page = PAGE_INSTRUCTIONS
	_add_label("Instruções", 56, TITLE_COLOR)
	_box.add_child(_goal_block())
	var tabs := HBoxContainer.new()
	tabs.alignment = BoxContainer.ALIGNMENT_CENTER
	tabs.add_theme_constant_override("separation", 24)
	_box.add_child(tabs)
	_add_button("Teclado", _show_instructions.bind(TAB_KEYBOARD, 0), tabs, TAB_BUTTON_SIZE, tab == TAB_KEYBOARD)
	_add_button("Joystick", _show_instructions.bind(TAB_JOYSTICK, 1), tabs, TAB_BUTTON_SIZE, tab == TAB_JOYSTICK)
	_box.add_child(_keyboard_section() if tab == TAB_KEYBOARD else _joystick_section())
	_add_button("Voltar", _on_instructions_back)
	_open(focus_index, TAB_INPUT_DELAY_MS)


func _show_victory() -> void:
	_clear()
	_add_label("Vitória!", 84, TITLE_COLOR)
	_add_label("Vocês entregaram os 3 pedidos!", 28, TEXT_COLOR)
	_stars_count = GameState.stars
	_box.add_child(_stars)
	_add_label("Tempo restante: %s" % _format_time(GameState.final_time_left), 26, TEXT_COLOR)
	_add_spacer(10)
	_add_button("Jogar de novo", _on_play_again)
	_add_button("Menu", _on_menu)
	_open()


func _show_game_over() -> void:
	_clear()
	_add_label("Game Over", 84, TITLE_COLOR)
	_add_label("O tempo acabou!", 30, TEXT_COLOR)
	_add_label("Pedidos entregues: %d de %d" % [GameState.orders_delivered(), OrderManager.total_orders()], 26, TEXT_COLOR)
	_add_spacer(10)
	_add_button("Jogar de novo", _on_play_again)
	_add_button("Menu", _on_menu)
	_open()


# ---------------- botões ----------------

func _on_play() -> void:
	# A cozinha do menu está zerada (acabou de ser carregada): começa direto.
	GameState.start_game()


func _on_instructions() -> void:
	_show_instructions(TAB_KEYBOARD)


func _on_instructions_back() -> void:
	_show_menu(1)


func _on_play_again() -> void:
	GameState.restart_game()


func _on_menu() -> void:
	GameState.go_to_menu()


# ---------------- navegação (teclado / joystick) ----------------

func _physics_process(_delta: float) -> void:
	if not visible or _buttons.is_empty():
		return
	var blocked := Time.get_ticks_msec() < _ignore_until_ms
	for p in [1, 2]:
		var v: Vector2 = InputManager.get_move(p)
		var dir := 0
		if v.y > NAV_THRESHOLD or v.x > NAV_THRESHOLD:
			dir = 1
		elif v.y < -NAV_THRESHOLD or v.x < -NAV_THRESHOLD:
			dir = -1
		if not blocked and dir != 0 and _prev_dir[p] == 0:
			_set_focus(_focus + dir)
		_prev_dir[p] = dir
		if not blocked and InputManager.is_action_just_pressed(p):
			_press(_focus)
			return


## Bloqueia as ações nativas da Godot enquanto a tela está aberta: quem navega
## é o _physics_process acima (assim Enter não aperta o botão duas vezes).
func _input(event: InputEvent) -> void:
	if not visible:
		return
	# Esc na tela de instruções = Voltar.
	if _page == PAGE_INSTRUCTIONS and event is InputEventKey and event.pressed \
			and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_on_instructions_back()
		return
	for action in UI_ACTIONS:
		if event.is_action(action):
			get_viewport().set_input_as_handled()
			return


func _set_focus(index: int) -> void:
	if _buttons.is_empty() or not is_inside_tree():
		return
	_focus = posmod(index, _buttons.size())
	_buttons[_focus].grab_focus()


func _press(index: int) -> void:
	var b := _buttons[index]
	# Pequeno "apertão" visual antes da ação.
	b.pivot_offset = b.size / 2
	var tw := b.create_tween()
	tw.tween_property(b, "scale", Vector2(0.92, 0.92), 0.05)
	tw.tween_property(b, "scale", Vector2.ONE, 0.05)
	b.pressed.emit()


# ---------------- montagem ----------------

func _build_base() -> void:
	_dim = ColorRect.new()
	_dim.color = DIM_COLOR
	_dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dim.add_child(center)

	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL_COLOR
	style.border_color = PANEL_BORDER
	style.set_border_width_all(5)
	style.set_corner_radius_all(24)
	style.content_margin_left = 70
	style.content_margin_right = 70
	style.content_margin_top = 36
	style.content_margin_bottom = 40
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	_box = VBoxContainer.new()
	_box.add_theme_constant_override("separation", 14)
	_box.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(_box)

	# Estrelas (desenhadas com polígonos: o caractere ★ não existe na fonte padrão).
	_stars = Control.new()
	_stars.custom_minimum_size = Vector2(330, 100)
	_stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stars.draw.connect(_draw_stars)


func _clear() -> void:
	_buttons.clear()
	_focus = 0
	_page = ""
	for child in _box.get_children():
		_box.remove_child(child)
		if child != _stars:
			child.queue_free()


func _open(focus_index: int = 0, delay_ms: int = INPUT_DELAY_MS) -> void:
	visible = true
	_ignore_until_ms = Time.get_ticks_msec() + delay_ms
	_prev_dir = {1: 0, 2: 0}
	_set_focus.call_deferred(focus_index)
	_stars.queue_redraw()


func _hide() -> void:
	visible = false
	_buttons.clear()


func _add_label(text: String, size: int, color: Color) -> void:
	_box.add_child(_make_label(text, size, color))


func _make_label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	l.add_theme_constant_override("outline_size", maxi(6, size / 7))
	return l


func _add_spacer(height: int) -> void:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, height)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_box.add_child(c)


## parent: onde o botão entra (null = coluna principal da tela).
## active = false: botão apagado (aba não selecionada).
func _add_button(text: String, action: Callable, parent: Container = null,
		min_size: Vector2 = BUTTON_SIZE, active: bool = true) -> void:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.focus_mode = Control.FOCUS_ALL
	b.add_theme_font_size_override("font_size", 36 if min_size == BUTTON_SIZE else 30)
	b.add_theme_color_override("font_color", TEXT_COLOR)
	b.add_theme_color_override("font_focus_color", TEXT_COLOR)
	b.add_theme_color_override("font_hover_color", TEXT_COLOR)
	b.add_theme_color_override("font_pressed_color", TEXT_COLOR)
	b.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	b.add_theme_constant_override("outline_size", 6)
	var base := BUTTON_COLOR if active else TAB_OFF_COLOR
	b.add_theme_stylebox_override("normal", _button_style(base, false))
	b.add_theme_stylebox_override("hover", _button_style(base.lightened(0.1), false))
	b.add_theme_stylebox_override("pressed", _button_style(base.lightened(0.1), true))
	# Foco bem visível: borda amarela grossa por cima do botão.
	b.add_theme_stylebox_override("focus", _focus_style())
	b.pressed.connect(action)
	var index := _buttons.size()
	b.focus_entered.connect(func(): _focus = index)  # clique do mouse também move o foco
	b.mouse_entered.connect(func(): _set_focus(index))
	_buttons.append(b)
	(parent if parent != null else _box).add_child(b)


func _button_style(color: Color, pressed: bool) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color.darkened(0.15) if pressed else color
	s.set_corner_radius_all(16)
	s.border_color = OUTLINE_COLOR
	s.set_border_width_all(3)
	return s


func _focus_style() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.draw_center = false
	s.border_color = FOCUS_BORDER
	s.set_border_width_all(7)
	s.set_corner_radius_all(18)
	s.expand_margin_left = 6
	s.expand_margin_right = 6
	s.expand_margin_top = 6
	s.expand_margin_bottom = 6
	return s


# ---------------- instruções (conteúdo) ----------------
# Teclas e joystick são desenhados com formas simples (sem arte ainda): a colega
# pode trocar por sprites depois, mexendo só em _keycap() e _joystick_icon().

## "Objetivo do jogo": só regras que existem no jogo (relógio, 3 pedidos, lixeira).
func _goal_block() -> Control:
	var card := _card("Objetivo do jogo", TITLE_COLOR)
	for line in [
		"O pedido aparece no canto da tela, com os nomes em inglês.",
		"Os dois chefs trabalham juntos: pegam, cozinham e montam o prato.",
		"Entreguem no balcão antes do tempo acabar! São 3 pedidos.",
		"Errou o prato? Jogue na lixeira e comece de novo.",
	]:
		card.get_meta("body").add_child(_make_label(line, BODY_SIZE, TEXT_COLOR))
	return card


func _keyboard_section() -> Control:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 28)

	var j1 := _card("Jogador 1 (raposa)", J1_COLOR)
	j1.get_meta("body").add_child(_hint_row(_key_cross(["W", "A", "S", "D"]), "Andar"))
	j1.get_meta("body").add_child(_hint_row(_keycap("E"), "Pegar, soltar e usar"))
	row.add_child(j1)

	var j2 := _card("Jogador 2 (esquilo)", J2_COLOR)
	j2.get_meta("body").add_child(_hint_row(_key_cross([Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]), "Andar"))
	j2.get_meta("body").add_child(_hint_row(_keycap("Enter", Vector2.ZERO, 110.0), "Pegar, soltar e usar"))
	row.add_child(j2)
	return row


func _joystick_section() -> Control:
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	col.add_child(_make_label("Cada jogador tem o seu joystick.", BODY_SIZE + 2, TEXT_COLOR))

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 28)
	var move := _card("Empurre", TITLE_COLOR)
	move.get_meta("body").add_child(_hint_row(_joystick_icon(false), "para andar"))
	row.add_child(move)
	var press := _card("Aperte para baixo", TITLE_COLOR)
	press.get_meta("body").add_child(_hint_row(_joystick_icon(true), "para pegar,\nsoltar e usar"))
	row.add_child(press)
	col.add_child(row)

	col.add_child(_make_label("Nas telas: empurre para escolher e aperte para confirmar.", 22, TEXT_COLOR))
	return col


## Cartão com título colorido. O conteúdo vai em card.get_meta("body") (VBox).
func _card(title: String, title_color: Color) -> PanelContainer:
	var card := PanelContainer.new()
	var s := StyleBoxFlat.new()
	s.bg_color = CARD_COLOR
	s.set_corner_radius_all(16)
	s.content_margin_left = 22
	s.content_margin_right = 22
	s.content_margin_top = 10
	s.content_margin_bottom = 14
	card.add_theme_stylebox_override("panel", s)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 8)
	body.add_child(_make_label(title, 30, title_color))
	card.add_child(body)
	card.set_meta("body", body)
	return card


## Desenho (tecla/joystick) à esquerda + frase curta à direita.
func _hint_row(icon: Control, text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(icon)
	var l := _make_label(text, BODY_SIZE, TEXT_COLOR)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(l)
	return row


## 4 teclas em "T invertido": [cima] / [esquerda][baixo][direita].
## Cada item é uma letra (String) ou uma seta (Vector2).
func _key_cross(keys: Array) -> Control:
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	var cells := [null, keys[0], null, keys[1], keys[2], keys[3]]
	for k in cells:
		if k == null:
			var gap := Control.new()
			gap.custom_minimum_size = Vector2(KEY_SIZE, KEY_SIZE)
			grid.add_child(gap)
		elif k is Vector2:
			grid.add_child(_keycap("", k))
		else:
			grid.add_child(_keycap(k))
	return grid


## Tecla: painel arredondado claro com a letra (ou uma seta, se arrow != ZERO).
func _keycap(text: String, arrow: Vector2 = Vector2.ZERO, width: float = KEY_SIZE) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(width, KEY_SIZE)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func():
		var r := Rect2(Vector2.ZERO, c.size)
		var shadow := StyleBoxFlat.new()
		shadow.bg_color = Color(0.45, 0.38, 0.3)
		shadow.set_corner_radius_all(10)
		c.draw_style_box(shadow, r)
		var top := StyleBoxFlat.new()
		top.bg_color = KEY_COLOR
		top.set_corner_radius_all(10)
		top.border_color = OUTLINE_COLOR
		top.set_border_width_all(2)
		c.draw_style_box(top, Rect2(r.position, r.size - Vector2(0, 5)))
		var mid := Vector2(r.size.x / 2, (r.size.y - 5) / 2)
		if arrow != Vector2.ZERO:
			_draw_arrow(c, mid, arrow, 14.0, KEY_TEXT)
		else:
			var font := ThemeDB.fallback_font
			var fs := 28 if text.length() == 1 else 22
			var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			c.draw_string(font, Vector2(mid.x - w / 2, mid.y + font.get_ascent(fs) / 2 - 3),
				text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, KEY_TEXT))
	return c


## Joystick visto de cima: base cinza + manche vermelho.
## pressed = false: 4 setas em volta (empurrar). true: seta para baixo em cima do manche (apertar).
func _joystick_icon(pressed: bool) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(130, 130)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func():
		var mid := c.size / 2
		c.draw_circle(mid, 44, Color(0.3, 0.3, 0.33))
		c.draw_arc(mid, 44, 0, TAU, 48, OUTLINE_COLOR, 3.0, true)
		var knob := mid + (Vector2(0, 4) if pressed else Vector2.ZERO)
		var kr := 22.0 if pressed else 25.0
		c.draw_circle(knob, kr, Color(0.85, 0.2, 0.18))
		c.draw_arc(knob, kr, 0, TAU, 32, OUTLINE_COLOR, 3.0, true)
		c.draw_circle(knob + Vector2(-7, -7), 6, Color(1, 1, 1, 0.45))
		if pressed:
			_draw_arrow(c, mid + Vector2(0, -50), Vector2.DOWN, 13.0, TITLE_COLOR)
		else:
			for d in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
				_draw_arrow(c, mid + d * 56, d, 10.0, TITLE_COLOR))
	return c


## Triângulo apontando na direção dir, centrado em center.
func _draw_arrow(canvas: CanvasItem, center: Vector2, dir: Vector2, size: float, color: Color) -> void:
	var side := Vector2(-dir.y, dir.x)
	var pts := PackedVector2Array([
		center + dir * size,
		center - dir * size * 0.7 + side * size,
		center - dir * size * 0.7 - side * size,
	])
	canvas.draw_colored_polygon(pts, color)
	var outline := pts.duplicate()
	outline.append(pts[0])
	canvas.draw_polyline(outline, OUTLINE_COLOR, 2.0, true)


## 3 estrelas: douradas as ganhas, cinza as que faltaram.
func _draw_stars() -> void:
	var r := 42.0
	for i in 3:
		var c := Vector2(_stars.size.x / 2 + (i - 1) * 110, _stars.size.y / 2)
		var pts := PackedVector2Array()
		for k in 10:
			var a := -PI / 2 + k * PI / 5
			var rr := r if k % 2 == 0 else r * 0.45
			pts.append(c + Vector2(cos(a), sin(a)) * rr)
		var earned := i < _stars_count
		var outline := pts.duplicate()
		outline.append(pts[0])
		_stars.draw_colored_polygon(pts, Color(1.0, 0.82, 0.15) if earned else Color(0.35, 0.3, 0.28))
		_stars.draw_polyline(outline, OUTLINE_COLOR, 4.0, true)


func _format_time(seconds: float) -> String:
	var s := ceili(seconds)
	return "%02d:%02d" % [floori(s / 60.0), s % 60]
