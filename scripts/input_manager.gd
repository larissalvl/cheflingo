extends Node
## InputManager (autoload): única porta de entrada dos comandos dos jogadores.
## O resto do jogo só chama get_move(), is_action_held() e is_action_just_pressed()
## e nunca sabe se o comando veio do teclado ou do ESP32.

## Teclas de cada jogador (teclado = sempre funciona, é o plano B).
const KEYS := {
	1: {"up": [KEY_W], "down": [KEY_S], "left": [KEY_A], "right": [KEY_D], "action": [KEY_E]},
	2: {"up": [KEY_UP], "down": [KEY_DOWN], "left": [KEY_LEFT], "right": [KEY_RIGHT], "action": [KEY_ENTER, KEY_KP_ENTER]},
}

## Se o ESP32 parar de mandar pacotes por esse tempo, o estado dele é zerado.
const REMOTE_TIMEOUT_MS := 500

## Estado vindo do hardware (preenchido por set_remote_state; o UDP entra no Dia 2).
var _remote := {
	1: {"move": Vector2.ZERO, "sw": false, "last_ms": -REMOTE_TIMEOUT_MS},
	2: {"move": Vector2.ZERO, "sw": false, "last_ms": -REMOTE_TIMEOUT_MS},
}

## Estado do botão de ação no frame atual e no anterior (para detectar "acabou de pressionar").
var _held := {1: false, 2: false}
var _held_prev := {1: false, 2: false}


func _ready() -> void:
	process_priority = -100  # roda antes dos chefs
	_register_keyboard_actions()


func _physics_process(_delta: float) -> void:
	var now := Time.get_ticks_msec()
	for p in [1, 2]:
		if now - _remote[p]["last_ms"] > REMOTE_TIMEOUT_MS:
			_remote[p]["move"] = Vector2.ZERO
			_remote[p]["sw"] = false
		_held_prev[p] = _held[p]
		_held[p] = Input.is_action_pressed(_action_name(p, "action")) or _remote[p]["sw"]


# ---------------- API pública ----------------

## Vetor de movimento do jogador (comprimento de 0 a 1).
func get_move(player: int) -> Vector2:
	var kb := Input.get_vector(
		_action_name(player, "left"), _action_name(player, "right"),
		_action_name(player, "up"), _action_name(player, "down"))
	if kb != Vector2.ZERO:
		return kb
	return _remote[player]["move"].limit_length(1.0)


## Botão de ação está apertado agora?
func is_action_held(player: int) -> bool:
	return _held[player]


## Botão de ação foi apertado neste frame? (dispara uma vez por clique)
func is_action_just_pressed(player: int) -> bool:
	return _held[player] and not _held_prev[player]


## Chamado pela leitura do hardware (UDP/Serial) com um pacote "J1,x,y,sw".
func set_remote_state(player: int, x: float, y: float, sw: bool) -> void:
	if not _remote.has(player):
		return
	_remote[player]["move"] = Vector2(clampf(x, -1.0, 1.0), clampf(y, -1.0, 1.0))
	_remote[player]["sw"] = sw
	_remote[player]["last_ms"] = Time.get_ticks_msec()


# ---------------- interno ----------------

func _action_name(player: int, what: String) -> String:
	return "p%d_%s" % [player, what]


func _register_keyboard_actions() -> void:
	for p in KEYS:
		for what in KEYS[p]:
			var action := _action_name(p, what)
			if not InputMap.has_action(action):
				InputMap.add_action(action)
			for key in KEYS[p][what]:
				var ev := InputEventKey.new()
				ev.physical_keycode = key
				InputMap.action_add_event(action, ev)
