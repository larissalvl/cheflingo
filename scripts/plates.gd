class_name Plates
extends RefCounted
## Sprites dos pratos montados: cada combinação EXATA de itens (id + cru/cozido)
## tem um desenho próprio. Sem desenho para a combinação, o prato mostra o prato
## vazio com os ícones dos itens em cima (ver dish.gd).
##
## Para acrescentar um prato novo: coloque o PNG em sprites/utensilios/prato/
## e adicione uma linha em TABLE com o caminho e os itens.
## Em "items", true = cozido, false = cru. Para lettuce e bun (não vão ao fogão)
## use sempre false.
##
## Só entram aqui os arquivos cujo nome e desenho batem com certeza.
## Os duvidosos estão listados no SPRITES_INVENTARIO.md (não são usados).

const DIR := "res://sprites/utensilios/prato/"

## Prato vazio de verdade. AINDA NÃO EXISTE: o arquivo prato_vazio.png atual é uma
## frigideira com carne. Enquanto isso, o jogo desenha um placeholder.
const EMPTY_SPRITE := ""
const EMPTY_FILE := "prato_vazio.png"

const TABLE := [
	# 1 item
	{"file": DIR + "prato_ovo_cozido.png", "items": {"EGG": true}},
	{"file": DIR + "prato_bacon_cru.png", "items": {"BACON": false}},
	{"file": DIR + "prato_carne_crua.png", "items": {"BEEF PATTY": false}},
	{"file": DIR + "prato_carne_assada.png", "items": {"BEEF PATTY": true}},
	# 2 itens
	{"file": DIR + "prato_carne_crua_alface.png", "items": {"BEEF PATTY": false, "LETTUCE": false}},
	{"file": DIR + "prato_carne_crua_ovo_assado.png", "items": {"BEEF PATTY": false, "EGG": true}},
	{"file": "res://sprites/pratoOvoeBacon.PNG", "items": {"EGG": true, "BACON": true}},
	{"file": DIR + "prato_pao_carne_crua.png", "items": {"BUN": false, "BEEF PATTY": false}},
	{"file": DIR + "prato_pao_hamburguer_assado.png", "items": {"BUN": false, "BEEF PATTY": true}},
	{"file": DIR + "prato_pao_ovo.png", "items": {"BUN": false, "EGG": true}},
	# 3 itens
	{"file": DIR + "prato_hamburguer_alface.png", "items": {"BUN": false, "BEEF PATTY": true, "LETTUCE": false}},
	{"file": DIR + "prato_hamburguer_ovo_assados.png", "items": {"BUN": false, "BEEF PATTY": true, "EGG": true}},
]

## Chave da combinação -> caminho do PNG (montado na primeira consulta).
static var _by_key := {}


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


## Caminho do sprite para essa combinação exata, ou "" se não houver.
static func sprite_path(items: Dictionary) -> String:
	if _by_key.is_empty():
		for entry in TABLE:
			_by_key[key_for(entry["items"])] = entry["file"]
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


## Prepara todos os sprites de prato de uma vez (evita engasgo durante o jogo).
static func preload_all() -> void:
	empty_texture()
	for entry in TABLE:
		Ingredients.cropped(entry["file"])
