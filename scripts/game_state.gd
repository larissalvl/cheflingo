extends Node
## GameState (autoload): estado da partida e relógio da fase.
## Quem quiser saber se o jogo está rolando chama is_playing() ou ouve os sinais.
## O relógio só corre em JOGANDO; ao chegar a 0 emite time_up e chama lose().

signal state_changed(new_state: State)
signal time_changed(seconds_left: int)  # emitido quando muda o segundo mostrado
signal time_up

enum State { MENU, JOGANDO, VITORIA, GAME_OVER }

const ROUND_SECONDS := 90.0
## Estrelas pelo tempo restante na vitória: 3 com 45 s ou mais, 2 com 20 s ou mais, senão 1.
const THREE_STARS_SECONDS := 45.0
const TWO_STARS_SECONDS := 20.0

var state: State = State.MENU
## Tempo restante em segundos (com fração).
var time_left: float = ROUND_SECONDS
## Tempo restante no momento da vitória (para as estrelas, depois).
var final_time_left: float = 0.0
## Estrelas ganhas (1 a 3). 0 = ainda não venceu.
var stars: int = 0


func _process(delta: float) -> void:
	if state != State.JOGANDO:
		return
	var before := get_seconds_left()
	time_left = maxf(time_left - delta, 0.0)
	if get_seconds_left() != before:
		time_changed.emit(get_seconds_left())
	if time_left <= 0.0:
		time_up.emit()
		lose()


# ---------------- API pública ----------------

## Zera tudo, sorteia os pedidos e começa a partida.
func start_game() -> void:
	time_left = ROUND_SECONDS
	final_time_left = 0.0
	stars = 0
	OrderManager.start_new_round()
	_set_state(State.JOGANDO)
	time_changed.emit(get_seconds_left())


## Vitória: guarda o tempo restante e as estrelas. Só vale durante a partida.
func win() -> void:
	if state != State.JOGANDO:
		return
	final_time_left = time_left
	if final_time_left >= THREE_STARS_SECONDS:
		stars = 3
	elif final_time_left >= TWO_STARS_SECONDS:
		stars = 2
	else:
		stars = 1
	print("[GameState] vitória com %.1f s restantes -> %d estrela(s)" % [final_time_left, stars])
	_set_state(State.VITORIA)


## Derrota. Só vale durante a partida.
func lose() -> void:
	if state != State.JOGANDO:
		return
	_set_state(State.GAME_OVER)


## Volta ao menu com o relógio cheio.
func reset() -> void:
	time_left = ROUND_SECONDS
	final_time_left = 0.0
	stars = 0
	OrderManager.clear()
	_set_state(State.MENU)
	time_changed.emit(get_seconds_left())


func is_playing() -> bool:
	return state == State.JOGANDO


## Segundos inteiros para mostrar na tela (89.2 s aparece como 01:30 até virar 89).
func get_seconds_left() -> int:
	return ceili(time_left)


# ---------------- interno ----------------

func _set_state(new_state: State) -> void:
	state = new_state
	print("[GameState] estado: %s" % State.keys()[new_state])
	state_changed.emit(new_state)
