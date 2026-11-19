class_name Plates
extends RefCounted
## Sprites dos pratos montados: cada combinação EXATA de itens (id + cru/cozido)
## pode ter um desenho próprio. Sem desenho para a combinação, o prato mostra o
## prato vazio com os ícones dos itens em cima (ver dish.gd).
##
## NÃO há tabela para preencher: no início do jogo esta classe lê a pasta
## sprites/utensilios/prato/ e entende cada arquivo pelo NOME (convenção):
##   prato_vazio.png                         -> prato vazio
##   prato_<item>_<item>...png               -> combinação
##   - itens na ordem fixa: bun, beef, bacon, lettuce, egg
##   - cozinháveis (beef, bacon, egg) levam o estado: beef-cru / beef-cozido
##   - lettuce e bun não levam estado
##   - um número no fim (_2, _3) marca um desenho repetido; vale o sem número
##   Ex.: prato_bun_beef-cozido_lettuce_egg-cozido.png
## Basta colocar o PNG novo na pasta com o nome certo: ele passa a aparecer no
## jogo e, se for um prato de pedido (tudo cozido), entra no sorteio sozinho.
## Arquivos fora da convenção são ignorados (com aviso no console).

const DIR := "res://sprites/utensilios/prato/"
const EMPTY_SPRITE := DIR + "prato_vazio.png"
const EMPTY_FILE := "prato_vazio.png"
const PREFIX := "prato_"
## Ordem fixa dos itens no nome do arquivo (pelo file_id de Ingredients).
const NAME_ORDER := ["bun", "beef", "bacon", "lettuce", "egg"]

## Chave da combinação -> caminho do PNG (montado na primeira consulta).
static var _by_key := {}
static var _scanned := false


## Chave única de uma combinação, independente da ordem:
## {"EGG": true, "BUN": false} -> "BUN|EGG+cozido"
static func key_for(items: Dictionary) -> String:
	var ids := items.keys()
	ids.sort()
	var parts: Array[String] = []
	for id in ids:
		var part: String = id
		if Ingredients.is_cookable(id):
			part += "+cozido" if items[id] else "+cru"
		parts.append(part)
	return "|".join(parts)


## Nome de arquivo (na convenção) para uma combinação.
## {"BEEF PATTY": true, "BUN": false} -> "prato_bun_beef-cozido.png"
static func file_name_for(items: Dictionary) -> String:
	var parts: Array[String] = []
	for short_name in NAME_ORDER:
		var id := Ingredients.id_from_file(short_name)
		if not items.has(id):
			continue
		var part: String = short_name
		if Ingredients.is_cookable(id):
			part += "-cozido" if items[id] else "-cru"
		parts.append(part)
	return PREFIX + "_".join(parts) + ".png"


## Lê o nome de um arquivo de prato. Devolve {id: cozido?} ou null se o nome
## não seguir a convenção (ou for o prato vazio).
static func parse_file_name(file_name: String):
	var base := file_name.get_basename().to_lower()
	if not base.begins_with(PREFIX) or base == EMPTY_FILE.get_basename():
		return null
	var items := {}
	for token in base.substr(PREFIX.length()).split("_"):
		if token.is_valid_int():
			continue  # _2, _3: desenho repetido
		var bits := token.split("-")
		var id := Ingredients.id_from_file(bits[0])
		if id == "" or items.has(id) or bits.size() > 2:
			return null
		if Ingredients.is_cookable(id):
			if bits.size() != 2 or not (bits[1] in ["cru", "cozido"]):
				return null
			items[id] = bits[1] == "cozido"
		else:
			if bits.size() != 1:
				return null
			items[id] = false
	return items if not items.is_empty() else null


## Caminho do sprite para essa combinação exata, ou "" se não houver.
static func sprite_path(items: Dictionary) -> String:
	_scan()
	return _by_key.get(key_for(items), "")


## Sprite (já recortado) da combinação exata, ou null se não houver
## (ou se o arquivo ainda não foi importado pela Godot).
static func texture_for(items: Dictionary) -> Texture2D:
	var path := sprite_path(items)
	return Ingredients.cropped(path) if path != "" else null


## Prato vazio, ou null enquanto o sprite não existir.
static func empty_texture() -> Texture2D:
	return Ingredients.cropped(EMPTY_SPRITE)


## Um pedido (lista de ids) entregue certo = todos os cozinháveis cozidos.
## true se esse prato final tem sprite.
static func has_order_sprite(order_ids: Array) -> bool:
	var items := {}
	for id in order_ids:
		items[id] = Ingredients.is_cookable(id)
	return texture_for(items) != null


## Todas as combinações com sprite: [{"file": caminho, "items": {...}}, ...]
static func all_entries() -> Array:
	_scan()
	var result: Array = []
	for key in _by_key:
		var path: String = _by_key[key]
		result.append({"file": path, "items": parse_file_name(path.get_file())})
	return result


## Prepara todos os sprites de prato de uma vez (evita engasgo durante o jogo).
static func preload_all() -> void:
	_scan()
	empty_texture()
	for key in _by_key:
		Ingredients.cropped(_by_key[key])


# ---------------- interno ----------------

## Lê a pasta uma vez. Funciona no editor e no jogo exportado (lá os PNGs
## aparecem como .png.import / .png.remap).
static func _scan() -> void:
	if _scanned:
		return
	_scanned = true
	var names := {}
	for f in DirAccess.get_files_at(DIR):
		var name := f.trim_suffix(".remap").trim_suffix(".import")
		if name.get_extension().to_lower() == "png":
			names[name] = true
	var sorted := names.keys()
	sorted.sort()  # "prato_x.png" vem antes de "prato_x_2.png": vale o sem número
	for name in sorted:
		if name == EMPTY_FILE:
			continue
		var items = parse_file_name(name)
		if items == null:
			push_warning("[Plates] nome fora da convenção, ignorado: %s" % name)
			continue
		var key := key_for(items)
		if not _by_key.has(key):
			_by_key[key] = DIR + name
