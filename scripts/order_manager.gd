extends Node
## OrderManager (autoload): sorteia os 3 pedidos da partida e confere as entregas.
## As combinações são geradas a partir de Ingredients.ids(), então um ingrediente
## novo entra nos sorteios sem mexer neste arquivo.

signal order_changed(index: int, items: Array)
signal order_delivered_ok
## uncooked = itens do pedido que chegaram crus (precisavam passar pelo fogão).
signal order_delivered_wrong(missing: Array, extra: Array, uncooked: Array)
signal all_orders_done

## Quantos itens cada pedido pode ter (dificuldade crescente).
## Pedido 1: 2 itens. Pedido 2: 3 itens. Pedido 3: 3 ou 4 itens.
const ORDER_SIZES := [[2], [3], [3, 4]]

## Os pedidos sorteados (cada um é uma lista de ids).
var orders: Array = []
## Pedido atual, de 1 a 3. 0 = nenhuma partida em andamento.
var current_index: int = 0
## Ids do pedido atual.
var current_items: Array = []


# ---------------- API pública ----------------

## Chamado pelo GameState.start_game(): sorteia e volta para o pedido 1.
func start_new_round() -> void:
	orders = _draw_orders()
	_go_to_order(1)
	print("[OrderManager] pedidos sorteados: %s" % [orders])


## Limpa tudo (sem partida).
func clear() -> void:
	orders = []
	current_index = 0
	current_items = []


func total_orders() -> int:
	return orders.size()


## Confere um prato (lista de ids, em qualquer ordem) com o pedido atual.
## `raw_ids` = ids do prato que são cozinháveis mas estão CRUS.
## Certo só se os ids batem E nenhum item do pedido está cru. Retorna true se certo.
func submit_dish(dish: Array, raw_ids: Array = []) -> bool:
	if not GameState.is_playing() or current_index == 0:
		return false

	# Compara contando: o que o pedido pede e o prato não tem = faltando;
	# o que sobra no prato = sobrando (inclui ingrediente repetido).
	var leftover := dish.duplicate()
	var missing: Array = []
	for id in current_items:
		if id in leftover:
			leftover.erase(id)
		else:
			missing.append(id)
	var extra := leftover
	# Crus que fazem parte do pedido (um cru que já "sobrou" aparece só como sobra).
	var uncooked: Array = []
	for id in raw_ids:
		if id in current_items and id not in extra and id not in uncooked:
			uncooked.append(id)

	if missing.is_empty() and extra.is_empty() and uncooked.is_empty():
		print("[OrderManager] pedido %d CERTO" % current_index)
		order_delivered_ok.emit()
		if current_index >= orders.size():
			all_orders_done.emit()
			GameState.win()
		else:
			_go_to_order(current_index + 1)
		return true

	print("[OrderManager] pedido %d ERRADO. faltou=%s sobrou=%s cru=%s" % [current_index, missing, extra, uncooked])
	order_delivered_wrong.emit(missing, extra, uncooked)
	return false


## Todas as combinações de `size` elementos de `items` (sem repetir, sem ordem).
static func combinations(items: Array, size: int) -> Array:
	if size == 0:
		return [[]]
	if items.size() < size:
		return []
	var first = items[0]
	var rest := items.slice(1)
	var result: Array = []
	for combo in combinations(rest, size - 1):
		result.append([first] + combo)
	result.append_array(combinations(rest, size))
	return result


# ---------------- interno ----------------

func _go_to_order(index: int) -> void:
	current_index = index
	current_items = orders[index - 1].duplicate()
	order_changed.emit(current_index, current_items.duplicate())


func _draw_orders() -> Array:
	var ids := Ingredients.ids()
	var used := {}
	var result: Array = []
	for sizes in ORDER_SIZES:
		var pool: Array = []
		for size in sizes:
			for combo in combinations(ids, size):
				if not used.has(_key(combo)):
					pool.append(combo)
		if pool.is_empty():
			push_error("[OrderManager] ingredientes insuficientes para sortear os pedidos.")
			break
		var pick: Array = pool.pick_random()
		used[_key(pick)] = true
		result.append(pick)
	return result


## Identidade de uma combinação, independente da ordem.
func _key(combo: Array) -> String:
	var sorted := combo.duplicate()
	sorted.sort()
	return "|".join(sorted)
