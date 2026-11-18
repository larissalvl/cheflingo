class_name Ingredients
extends RefCounted
## Dados de TODOS os ingredientes do jogo, num lugar só.
## Para acrescentar um ingrediente novo, basta adicionar uma entrada em DATA:
## os pedidos, o menu e a dica de erro se ajustam sozinhos.
##
## A chave (id) é a mesma string que as caixas usam no campo "ingredient".
## - en: nome em inglês (aparece no menu de pedidos)
## - pt: tradução (só aparece na dica, DEPOIS de um erro)
## - sprite: caminho do PNG em sprites/. Deixe "" enquanto não houver arte;
##   aí o jogo mostra um retângulo da cor `color` no lugar.

const DATA := {
	"EGG": {
		"en": "egg",
		"pt": "ovo",
		"sprite": "res://sprites/ovoIcone.PNG",
		"color": Color(1.0, 0.82, 0.3),
	},
	"BACON": {
		"en": "bacon",
		"pt": "bacon",
		"sprite": "res://sprites/baconIcone.PNG",
		"color": Color(0.85, 0.35, 0.3),
	},
	"BEEF PATTY": {
		"en": "beef patty",
		"pt": "hambúrguer de carne",
		"sprite": "",  # falta a arte: sprites/carneIcone.PNG
		"color": Color(0.5, 0.3, 0.18),
	},
	"LETTUCE": {
		"en": "lettuce",
		"pt": "alface",
		"sprite": "",  # falta a arte: sprites/alfaceIcone.PNG
		"color": Color(0.45, 0.8, 0.35),
	},
}


## Ícones já recortados (id -> AtlasTexture), calculados uma vez só.
static var _icon_cache := {}


## Lista de ids na ordem acima.
static func ids() -> Array:
	return DATA.keys()


static func english(id: String) -> String:
	return DATA[id]["en"] if DATA.has(id) else id.to_lower()


static func portuguese(id: String) -> String:
	return DATA[id]["pt"] if DATA.has(id) else id.to_lower()


static func color(id: String) -> Color:
	return DATA[id]["color"] if DATA.has(id) else Color.GRAY


## Textura do ingrediente, ou null se ainda não houver sprite (use o placeholder).
static func texture(id: String) -> Texture2D:
	if not DATA.has(id):
		return null
	var path: String = DATA[id]["sprite"]
	if path == "" or not ResourceLoader.exists(path):
		return null
	return load(path)


## Igual a texture(), mas recortada só na parte desenhada (sem a borda transparente),
## para o ingrediente aparecer grande no menu e na mão do chef. null = sem sprite.
static func icon(id: String) -> Texture2D:
	if _icon_cache.has(id):
		return _icon_cache[id]
	var tex := texture(id)
	var result: Texture2D = tex
	if tex != null:
		var region := _opaque_rect(tex)
		if region.has_area():
			var atlas := AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = region
			result = atlas
	_icon_cache[id] = result
	return result


## Retângulo onde a imagem é realmente opaca (alfa > 0.5), lendo 1 a cada 4 pixels.
static func _opaque_rect(tex: Texture2D) -> Rect2:
	var img := tex.get_image()
	if img == null:
		return Rect2()
	if img.is_compressed():
		img.decompress()
	const STEP := 4
	var min_p := Vector2i(img.get_width(), img.get_height())
	var max_p := Vector2i(-1, -1)
	for y in range(0, img.get_height(), STEP):
		for x in range(0, img.get_width(), STEP):
			if img.get_pixel(x, y).a > 0.5:
				min_p = Vector2i(mini(min_p.x, x), mini(min_p.y, y))
				max_p = Vector2i(maxi(max_p.x, x), maxi(max_p.y, y))
	if max_p.x < 0:
		return Rect2()
	return Rect2(min_p, max_p - min_p + Vector2i(STEP, STEP))
