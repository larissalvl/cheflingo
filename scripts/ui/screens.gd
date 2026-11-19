extends CanvasLayer
## Telas do jogo: inicial (MENU), vitória e game over. Só nós de UI do Godot.
## Mostra a tela certa ouvindo GameState.state_changed.
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
	"ui_focus_next", "ui_focus_prev"]

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


func _show_menu() -> void:
	_clear()
	_add_label("Cozinha Maluca", 84, TITLE_COLOR)
	_add_label("Cozinhem juntos e aprendam os nomes em inglês!", 26, TEXT_COLOR)
	_add_spacer(16)
	_add_button("Jogar", _on_play)
	_add_spacer(8)
	_add_label("J1: W A S D + E      J2: setas + Enter      (ou joystick + botão)", 18, TEXT_COLOR)
	_open()


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
	for child in _box.get_children():
		_box.remove_child(child)
		if child != _stars:
			child.queue_free()


func _open() -> void:
	visible = true
	_ignore_until_ms = Time.get_ticks_msec() + INPUT_DELAY_MS
	_prev_dir = {1: 0, 2: 0}
	_set_focus.call_deferred(0)
	_stars.queue_redraw()


func _hide() -> void:
	visible = false
	_buttons.clear()


func _add_label(text: String, size: int, color: Color) -> void:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	l.add_theme_constant_override("outline_size", maxi(6, size / 7))
	_box.add_child(l)


func _add_spacer(height: int) -> void:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, height)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_box.add_child(c)


func _add_button(text: String, action: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = BUTTON_SIZE
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.focus_mode = Control.FOCUS_ALL
	b.add_theme_font_size_override("font_size", 36)
	b.add_theme_color_override("font_color", TEXT_COLOR)
	b.add_theme_color_override("font_focus_color", TEXT_COLOR)
	b.add_theme_color_override("font_hover_color", TEXT_COLOR)
	b.add_theme_color_override("font_pressed_color", TEXT_COLOR)
	b.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	b.add_theme_constant_override("outline_size", 6)
	b.add_theme_stylebox_override("normal", _button_style(BUTTON_COLOR, false))
	b.add_theme_stylebox_override("hover", _button_style(BUTTON_HOVER, false))
	b.add_theme_stylebox_override("pressed", _button_style(BUTTON_HOVER, true))
	# Foco bem visível: borda amarela grossa por cima do botão.
	b.add_theme_stylebox_override("focus", _focus_style())
	b.pressed.connect(action)
	var index := _buttons.size()
	b.focus_entered.connect(func(): _focus = index)  # clique do mouse também move o foco
	b.mouse_entered.connect(func(): _set_focus(index))
	_buttons.append(b)
	_box.add_child(b)


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
