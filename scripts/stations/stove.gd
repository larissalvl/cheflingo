class_name Stove
extends Counter
## Fogão (bloco cinza da bancada de cima). Por enquanto guarda 1 item, igual a uma bancada.
## Visuais separados: com/sem frigideira e aceso/apagado.
## set_pan() e set_burner() serão usados pela mecânica de cozinhar.
##
## Arte: fogaoApagado/fogaoAceso são o fogão SEM frigideira;
## a frigideira (frigideiraVazia) é um sprite separado, desenhado por cima.

var has_pan := false
var burner_on := false

@onready var _stove_off: Sprite2D = $StoveOff
@onready var _stove_on: Sprite2D = $StoveOn
@onready var _pan: Sprite2D = $Pan


func _ready() -> void:
	super()
	_update_visual()


## Põe (true) ou tira (false) a frigideira do fogão.
func set_pan(on: bool) -> void:
	has_pan = on
	_update_visual()


## Acende (true) ou apaga (false) o fogo.
func set_burner(on: bool) -> void:
	burner_on = on
	_update_visual()


func _update_visual() -> void:
	_stove_off.visible = not burner_on
	_stove_on.visible = burner_on
	_pan.visible = has_pan
