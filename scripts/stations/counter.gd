class_name Counter
extends Station
## Bancada: guarda no máximo 1 item.
## Chef com item + bancada vazia = solta o item. Chef sem item + bancada com item = pega.

var item: Item = null


func interact(chef: Chef) -> bool:
	if chef.has_item() and item == null:
		place(chef.take_item())
		return true
	if not chef.has_item() and item != null:
		var it := item
		item = null
		chef.hold(it)
		return true
	return false


## Coloca um item em cima da bancada.
func place(it: Item) -> void:
	item = it
	if it.get_parent() != null:
		it.reparent(_slot, false)
	else:
		_slot.add_child(it)
	it.position = Vector2.ZERO
