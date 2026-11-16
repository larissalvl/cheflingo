class_name Delivery
extends Station
## Balcão de entrega (placeholder): recebe o item e ele some.
## Clientes e pontuação entram no D4.

var delivered_count := 0


func interact(chef: Chef) -> bool:
	if not chef.has_item():
		return false
	var it := chef.take_item()
	it.queue_free()
	delivered_count += 1
	flash_text("THANKS!")
	return true
