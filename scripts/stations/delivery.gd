class_name Delivery
extends Station
## Balcão de entrega: recebe só o prato montado e manda para o OrderManager conferir.
## - Certo: o pedido avança (✔ / próximo / vitória) e o prato some.
## - Errado: a dica em português aparece e o prato volta vazio para a pilha
##   (o jogador monta de novo).
## Ingrediente solto ou prato vazio: pisca vermelho e fica na mão.
## O prato entregue aparece no balcão (mesmo visual do prato montado) e some
## num instante.

## Quanto tempo o prato entregue fica visível no balcão antes de sumir.
const SHOW_SECONDS := 0.6
const FADE_SECONDS := 0.3
const DISH_OFFSET := Vector2(0, -12)

var delivered_count := 0


func interact(chef: Chef) -> bool:
	if not chef.has_item():
		return false
	var held := chef.held_item
	if not (held is Dish) or (held as Dish).is_empty():
		reject(chef)
		return false
	var dish := chef.take_item() as Dish
	var ok := OrderManager.submit_dish(dish.ids(), dish.raw_ids())
	_show_and_remove(dish)
	if ok:
		delivered_count += 1
		flash_text("THANKS!")
	else:
		flash_text("OOPS!")
	return true


## Põe o prato no balcão por um instante e depois apaga.
func _show_and_remove(dish: Dish) -> void:
	dish.reparent(_slot, false)
	dish.position = DISH_OFFSET
	var tween := dish.create_tween()
	tween.tween_interval(SHOW_SECONDS)
	tween.tween_property(dish, "modulate:a", 0.0, FADE_SECONDS)
	tween.tween_callback(dish.queue_free)
