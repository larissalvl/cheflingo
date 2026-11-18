extends CanvasLayer
## Relógio no topo da tela e aviso provisório de fim ("VITÓRIA" / "GAME OVER").
## Só ouve o GameState; não controla nada.

const WARNING_SECONDS := 15
const NORMAL_COLOR := Color(1.0, 0.97, 0.9)
const WARNING_COLOR := Color(1.0, 0.25, 0.2)

var _blink: Tween

@onready var _clock_panel: PanelContainer = $ClockPanel
@onready var _clock_label: Label = $ClockPanel/ClockLabel
@onready var _end_label: Label = $EndLabel


func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	GameState.time_changed.connect(_on_time_changed)
	_on_state_changed(GameState.state)
	_on_time_changed(GameState.get_seconds_left())


func _on_state_changed(new_state: GameState.State) -> void:
	_clock_panel.visible = new_state == GameState.State.JOGANDO
	match new_state:
		GameState.State.VITORIA:
			_end_label.text = "VITÓRIA"
			_end_label.visible = true
		GameState.State.GAME_OVER:
			_end_label.text = "GAME OVER"
			_end_label.visible = true
		_:
			_end_label.visible = false


func _on_time_changed(seconds_left: int) -> void:
	_clock_label.text = "%02d:%02d" % [floori(seconds_left / 60.0), seconds_left % 60]
	var warning := seconds_left <= WARNING_SECONDS
	_clock_label.add_theme_color_override("font_color", WARNING_COLOR if warning else NORMAL_COLOR)
	if warning and seconds_left > 0:
		_pulse()
	else:
		_stop_pulse()


## Piscada leve: o relógio fica meio transparente e volta, uma vez por segundo.
func _pulse() -> void:
	_stop_pulse()
	_blink = create_tween()
	_blink.tween_property(_clock_panel, "modulate:a", 0.7, 0.15)
	_blink.tween_property(_clock_panel, "modulate:a", 1.0, 0.35)


func _stop_pulse() -> void:
	if _blink != null:
		_blink.kill()
	_clock_panel.modulate.a = 1.0
