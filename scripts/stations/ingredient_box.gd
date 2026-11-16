class_name IngredientBox
extends Station
## Caixa de ingrediente: chef de mão vazia aperta ação e recebe 1 item.

@export var ingredient: String = "FLOUR"


func get_label_text() -> String:
	return ingredient


func interact(chef: Chef) -> bool:
	if chef.has_item():
		return false
	chef.hold(Item.create(ingredient))
	return true
