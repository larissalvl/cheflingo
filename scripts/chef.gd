extends CharacterBody2D
## Chef controlado por um jogador. Placeholder desenhado em código até a arte chegar.

@export var player_id: int = 1
@export var color: Color = Color(0.9, 0.3, 0.3)
@export var speed: float = 320.0

const RADIUS := 24.0


func _physics_process(_delta: float) -> void:
	velocity = InputManager.get_move(player_id) * speed
	move_and_slide()

	# Por enquanto a "parede" é a borda da tela (colisões reais no Dia 2).
	var screen := get_viewport_rect().size
	position = position.clamp(Vector2(RADIUS, RADIUS), screen - Vector2(RADIUS, RADIUS))

	if InputManager.is_action_just_pressed(player_id):
		_action_feedback()


## Pulinho visual para confirmar que o botão de ação funcionou.
func _action_feedback() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.07)
	tween.tween_property(self, "scale", Vector2.ONE, 0.10)


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, color)                              # corpo
	draw_rect(Rect2(-14, -RADIUS - 16, 28, 18), Color.WHITE)              # chapéu
	draw_circle(Vector2(0, -RADIUS - 18), 10, Color.WHITE)                # topo do chapéu
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-12, 7), "J%d" % player_id,
		HORIZONTAL_ALIGNMENT_CENTER, 24, 18, Color.WHITE)
