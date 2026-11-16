extends Node
## InputManager (autoload): única porta de entrada dos comandos dos jogadores.
## O resto do jogo só chama get_move(), is_action_held() e is_action_just_pressed()
## e nunca sabe se o comando veio do teclado ou do ESP32.
##
## Regra: se o ESP32 do jogador mandou pacote nos últimos 500 ms, ele controla
## aquele chef. Se não, vale o teclado (que é sempre a reserva).

signal source_changed(player: int, source: String)  # "ESP32" ou "teclado"

const UDP_PORT := 4210
const REMOTE_TIMEOUT_MS := 500

## Teclas de cada jogador.
const KEYS := {
	1: {"up": [KEY_W], "down": [KEY_S], "left": [KEY_A], "right": [KEY_D], "action": [KEY_E]},
	2: {"up": [KEY_UP], "down": [KEY_DOWN], "left": [KEY_LEFT], "right": [KEY_RIGHT], "action": [KEY_ENTER, KEY_KP_ENTER]},
}

## Identificador do pacote -> número do jogador.
const PLAYER_IDS := {"J1": 1, "J2": 2}

var _udp := PacketPeerUDP.new()
var _udp_ok := false

## Estado vindo do hardware.
var _remote := {
	1: {"move": Vector2.ZERO, "sw": false, "last_ms": -100000},
	2: {"move": Vector2.ZERO, "sw": false, "last_ms": -100000},
}

## Botão de ação no frame atual e no anterior (para "acabou de pressionar").
var _held := {1: false, 2: false}
var _held_prev := {1: false, 2: false}
var _source := {1: "teclado", 2: "teclado"}


func _ready() -> void:
	process_priority = -100
	process_physics_priority = -100  # atualiza antes dos chefs
	_register_keyboard_actions()
	var err := _udp.bind(UDP_PORT)
	_udp_ok = err == OK
	if _udp_ok:
		print("[InputManager] escutando UDP na porta %d" % UDP_PORT)
	else:
		push_warning("[InputManager] não abriu a porta UDP %d (erro %d). Só teclado." % [UDP_PORT, err])


func _exit_tree() -> void:
	_udp.close()


func _physics_process(_delta: float) -> void:
	_read_udp()
	for p in [1, 2]:
		var src := "ESP32" if is_remote_active(p) else "teclado"
		if src != _source[p]:
			_source[p] = src
			print("[InputManager] J%d agora controlado por: %s" % [p, src])
			source_changed.emit(p, src)
		_held_prev[p] = _held[p]
		if is_remote_active(p):
			_held[p] = _remote[p]["sw"]
		else:
			_held[p] = Input.is_action_pressed(_action_name(p, "action"))


# ---------------- API pública ----------------

## Vetor de movimento do jogador (comprimento de 0 a 1).
func get_move(player: int) -> Vector2:
	if is_remote_active(player):
		return _remote[player]["move"].limit_length(1.0)
	return Input.get_vector(
		_action_name(player, "left"), _action_name(player, "right"),
		_action_name(player, "up"), _action_name(player, "down"))


## Botão de ação está apertado agora?
func is_action_held(player: int) -> bool:
	return _held[player]


## Botão de ação foi apertado neste frame? (dispara uma vez por clique)
func is_action_just_pressed(player: int) -> bool:
	return _held[player] and not _held_prev[player]


## O ESP32 desse jogador mandou pacote recentemente?
func is_remote_active(player: int) -> bool:
	return Time.get_ticks_msec() - _remote[player]["last_ms"] <= REMOTE_TIMEOUT_MS


## "ESP32" ou "teclado" — só para diagnóstico na tela.
func get_source(player: int) -> String:
	return _source[player]


func is_udp_listening() -> bool:
	return _udp_ok


## Atualiza o estado do hardware. Usado pela leitura UDP (e por testes).
func set_remote_state(player: int, x: float, y: float, sw: bool) -> void:
	if not _remote.has(player):
		return
	_remote[player]["move"] = Vector2(clampf(x, -1.0, 1.0), clampf(y, -1.0, 1.0))
	_remote[player]["sw"] = sw
	_remote[player]["last_ms"] = Time.get_ticks_msec()


## Interpreta um pacote "J1,x,y,sw". Retorna true se era válido.
func parse_packet(text: String) -> bool:
	var parts := text.strip_edges().split(",")
	if parts.size() != 4 or not PLAYER_IDS.has(parts[0]):
		return false
	if not (parts[1].is_valid_float() and parts[2].is_valid_float() and parts[3].is_valid_int()):
		return false
	set_remote_state(PLAYER_IDS[parts[0]], parts[1].to_float(), parts[2].to_float(), parts[3].to_int() == 1)
	return true


# ---------------- interno ----------------

func _read_udp() -> void:
	if not _udp_ok:
		return
	while _udp.get_available_packet_count() > 0:
		var text := _udp.get_packet().get_string_from_ascii()
		parse_packet(text)


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
