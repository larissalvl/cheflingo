class_name IngredientBox
extends Station
## Caixa de ingrediente: chef de mão vazia aperta ação e recebe 1 item.

@export var ingredient: String = "EGG"
## Nome do arquivo de sprite que ainda falta. Se preenchido, aparece no rótulo
## (a caixa vira um placeholder: retângulo colorido + nome do sprite esperado).
@export var placeholder_sprite: String = ""


func get_label_text() -> String:
	if placeholder_sprite != "":
		return "%s\n%s" % [ingredient, placeholder_sprite]
	return ingredient


func interact(chef: Chef) -> bool:
	if chef.has_item():
		return false
	chef.hold(Item.create(ingredient))
	return true
