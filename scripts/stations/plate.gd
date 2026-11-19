class_name PlateStation
extends Station
## Estação do prato (montagem). Sempre tem um prato (Dish) em cima.
## - Chef com ingrediente: o ingrediente vai para o prato. Aceita qualquer um
##   (a criança pode errar e aprender), mas não o mesmo ingrediente duas vezes.
## - Chef de mãos vazias + prato com itens: leva o prato inteiro; um prato
##   vazio novo aparece na estação.
## - Chef com um prato vazio na mão: devolve o prato à pilha.

## Onde o prato fica (relativo ao ItemSlot).
const DISH_OFFSET := Vector2(0, -12)

var dish: Dish = null


func _ready() -> void:
	super()
	_new_dish()


func interact(chef: Chef) -> bool:
	if chef.has_item():
		var held := chef.held_item
		if held is Dish:
			if (held as Dish).is_empty():
				chef.take_item().queue_free()
				return true
			reject(chef)
			return false
		if dish.has_ingredient(held.ingredient):
			reject(chef)
			return false
		dish.add(chef.take_item())
		return true

	if dish.is_empty():
		return false
	var full := dish
	dish = null
	chef.hold(full)
	_new_dish()
	return true


func _new_dish() -> void:
	dish = Dish.create_empty()
	_slot.add_child(dish)
	dish.position = DISH_OFFSET
