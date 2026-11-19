class_name Delivery
extends Station
## Balcão de entrega: recebe só o prato montado e manda para o OrderManager conferir.
## - Certo: o pedido avança (✔ / próximo / vitória) e o prato some.
## - Errado: a dica em português aparece e o prato volta vazio para a pilha
##   (o jogador monta de novo).
## Ingrediente solto ou prato vazio: pisca vermelho e fica na mão.

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
	dish.queue_free()
	if ok:
		delivered_count += 1
		flash_text("THANKS!")
	else:
		flash_text("OOPS!")
	return true
