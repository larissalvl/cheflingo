class_name Stove
extends Station
## Fogão com frigideira (bloco cinza da bancada de cima). Cozinha 1 item por vez.
##
## VAZIO (sem frigideira, apagado)
##   -> chef com item cozinhável CRU interage: item vai para a frigideira, fogo acende
## COZINHANDO (4 s, barra de progresso; ignora interações)
##   -> item vira COZIDO, fogo apaga
## PRONTO (selo verde pulsando)
##   -> chef de mãos vazias interage: pega o item, a frigideira some, volta a VAZIO
##
## Item não cozinhável (lettuce), já cozido ou prato: pisca vermelho e o item fica na mão.
## Arte: fogaoApagado/fogaoAceso = fogão SEM frigideira; a frigideira é desenhada por cima.
## A frigideira mostra a comida quando existe sprite para o item + estado (PAN_SPRITES);
## senão fica a frigideira vazia com o sprite do ingrediente por cima.

enum CookState { VAZIO, COZINHANDO, PRONTO }

const COOK_SECONDS := 4.0
## Onde o item fica (relativo ao ItemSlot): em cima da frigideira.
const ITEM_OFFSET := Vector2(0, -30)
## Barra de progresso / selo de pronto, acima do fogão.
const BAR_RECT := Rect2(-34, -92, 68, 12)
const BAR_BG := Color(0.1, 0.05, 0.02, 0.85)
const BAR_FILL := Color(1.0, 0.6, 0.15)
const READY_COLOR := Color(0.25, 0.85, 0.3)

const PAN_EMPTY := "res://sprites/utensilios/frigideira/frigideiraVazia.PNG"
## Frigideira com a comida: id -> {"raw": cru, "cooked": cozido}. Sem entrada = vazia + ícone.
## ATENÇÃO: escolhidos pelo DESENHO, não pelo nome (os nomes estão trocados, ver
## SPRITES_INVENTARIO.md). Se a Larissa renomear os arquivos, ajuste aqui.
const PAN_SPRITES := {
	"BEEF PATTY": {
		"raw": "res://sprites/utensilios/frigideira/frigideiraCarneAssada.png",  # desenho: carne CRUA
		"cooked": "res://sprites/utensilios/prato/prato_vazio.png",  # desenho: carne ASSADA na frigideira
	},
	"EGG": {"cooked": "res://sprites/utensilios/frigideira/frigideiraOvo.PNG"},
	"BACON": {"cooked": "res://sprites/utensilios/frigideira/frigideiraBacon.PNG"},
}

var has_pan := false
var burner_on := false
var cook_state: CookState = CookState.VAZIO
var item: Item = null

## 0 a 1 enquanto cozinha.
var _progress := 0.0
## Relógio da animação do selo "pronto".
var _ready_time := 0.0
## Camada acima dos chefs onde a barra e o selo são desenhados (o chef na frente
## do fogão não esconde).
var _indicator: Node2D
## Largura e centro da frigideira na tela (medidos da frigideira vazia da cena),
## para todas as versões aparecerem do mesmo tamanho e no mesmo lugar.
var _pan_width := 0.0
var _pan_center := Vector2.ZERO

@onready var _stove_off: Sprite2D = $StoveOff
@onready var _stove_on: Sprite2D = $StoveOn
@onready var _pan: Sprite2D = $Pan


func _ready() -> void:
	super()
	_indicator = Node2D.new()
	_indicator.name = "Indicator"
	_indicator.z_index = 6
	add_child(_indicator)
	_indicator.draw.connect(_draw_indicator)
	for id in PAN_SPRITES:  # prepara os sprites das frigideiras já no início
		for state in PAN_SPRITES[id]:
			Ingredients.cropped(PAN_SPRITES[id][state])
	var full := _pan.texture.get_size() * _pan.scale
	var r := Ingredients.cropped_rect(PAN_EMPTY)
	_pan_width = r.size.x * full.x
	_pan_center = _pan.position + (r.get_center() - Vector2(0.5, 0.5)) * full
	_update_visual()


func _process(delta: float) -> void:
	match cook_state:
		CookState.COZINHANDO:
			if GameState.is_playing():  # o tempo de cozimento pausa fora da partida
				_progress = minf(_progress + delta / COOK_SECONDS, 1.0)
				if _progress >= 1.0:
					_finish_cooking()
			_indicator.queue_redraw()
		CookState.PRONTO:
			_ready_time += delta
			_indicator.queue_redraw()


func interact(chef: Chef) -> bool:
	match cook_state:
		CookState.VAZIO:
			if not chef.has_item():
				return false
			var held := chef.held_item
			if held is Dish or held.is_cooked() or not Ingredients.is_cookable(held.ingredient):
				reject(chef)
				return false
			_start_cooking(chef.take_item())
			return true
		CookState.PRONTO:
			if chef.has_item():
				return false
			var cooked := item
			item = null
			cooked.show_icon = true
			chef.hold(cooked)
			cook_state = CookState.VAZIO
			set_pan(false)
			set_burner(false)
			_indicator.queue_redraw()
			return true
	return false  # COZINHANDO: ignora


## Põe (true) ou tira (false) a frigideira do fogão.
func set_pan(on: bool) -> void:
	has_pan = on
	_update_visual()


## Acende (true) ou apaga (false) o fogo.
func set_burner(on: bool) -> void:
	burner_on = on
	_update_visual()


# ---------------- interno ----------------

func _start_cooking(it: Item) -> void:
	item = it
	if it.get_parent() != null:
		it.reparent(_slot, false)
	else:
		_slot.add_child(it)
	it.position = ITEM_OFFSET
	_progress = 0.0
	cook_state = CookState.COZINHANDO
	set_pan(true)
	set_burner(true)


func _finish_cooking() -> void:
	item.set_cooked(true)
	set_burner(false)
	cook_state = CookState.PRONTO
	_ready_time = 0.0


func _update_visual() -> void:
	_stove_off.visible = not burner_on
	_stove_on.visible = burner_on
	_pan.visible = has_pan
	if not has_pan:
		return
	# Escolhe a frigideira: com a comida (se houver sprite) ou vazia + ícone do item.
	var path := PAN_EMPTY
	if item != null:
		var state := "cooked" if item.is_cooked() else "raw"
		var food_pan: String = PAN_SPRITES.get(item.ingredient, {}).get(state, "")
		if food_pan != "" and Ingredients.cropped(food_pan) != null:
			path = food_pan
		item.show_icon = path == PAN_EMPTY
	var tex := Ingredients.cropped(path)
	if tex == null or _pan_width <= 0.0:
		return  # mantém a textura original da cena
	_pan.texture = tex
	_pan.scale = Vector2.ONE * (_pan_width / tex.get_width())
	_pan.position = _pan_center


func _draw_indicator() -> void:
	var ci := _indicator
	match cook_state:
		CookState.COZINHANDO:
			ci.draw_rect(BAR_RECT.grow(2), BAR_BG)
			ci.draw_rect(Rect2(BAR_RECT.position, Vector2(BAR_RECT.size.x * _progress, BAR_RECT.size.y)), BAR_FILL)
		CookState.PRONTO:
			# Selo verde com ✔, pulsando.
			var c := BAR_RECT.get_center() + Vector2(0, -4)
			var r := 15.0 * (1.0 + 0.12 * sin(_ready_time * 8.0))
			ci.draw_circle(c, r + 2.5, Color(0.02, 0.2, 0.02))
			ci.draw_circle(c, r, READY_COLOR)
			var pts := PackedVector2Array([
				c + Vector2(-0.5, 0.0) * r,
				c + Vector2(-0.15, 0.38) * r,
				c + Vector2(0.5, -0.38) * r,
			])
			ci.draw_polyline(pts, Color.WHITE, r * 0.28, true)
