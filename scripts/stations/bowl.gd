class_name Bowl
extends Station
## Tigela: aceita itens e mostra quantos tem dentro.
## (No D3 vira a tigela que soma frações.)

var contents: Array[String] = []


func get_label_text() -> String:
	return "%s\nx%d" % [title, contents.size()]


func interact(chef: Chef) -> bool:
	if not chef.has_item():
		return false
	var it := chef.take_item()
	contents.append(it.ingredient)
	it.queue_free()
	update_label()
	return true
