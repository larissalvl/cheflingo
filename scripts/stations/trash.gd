class_name Trash
extends Station
## Lixeira (a do desenho do fundo, embaixo da pia). Não desenha nada próprio.
## - Chef com prato (vazio ou com comida) ou ingrediente solto: o item cai na
##   lixeira e some. Não precisa repor: a estação de pratos já cria um prato
##   novo sempre que alguém leva o dela, e as caixas de ingrediente são infinitas.
## - Chef de mãos vazias: nada acontece.

## Quanto o item "cai" para dentro da lixeira e quanto tempo leva.
const DROP_DISTANCE := 40.0
const DROP_SECONDS := 0.25
## Onde o item aparece antes de cair (relativo ao ItemSlot): na boca da lixeira.
const DROP_OFFSET := Vector2(0, -60)


func interact(chef: Chef) -> bool:
	if not chef.has_item():
		return false
	_drop(chef.take_item())
	_on_item_descartado()
	return true


## Ponto de chamada do som de descarte (o áudio entra depois).
func _on_item_descartado() -> void:
	pass


## Feedback: o item aparece na boca da lixeira, desce e some.
func _drop(it: Item) -> void:
	it.reparent(_slot, false)
	it.position = DROP_OFFSET
	var tween := it.create_tween().set_parallel()
	tween.tween_property(it, "position:y", DROP_OFFSET.y + DROP_DISTANCE, DROP_SECONDS) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(it, "modulate:a", 0.0, DROP_SECONDS)
	tween.chain().tween_callback(it.queue_free)
