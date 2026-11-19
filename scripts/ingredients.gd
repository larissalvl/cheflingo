class_name Ingredients
extends RefCounted
## Dados de TODOS os ingredientes do jogo, num lugar só.
## Para acrescentar um ingrediente novo, basta adicionar uma entrada em DATA:
## os pedidos, o menu, os itens e a dica de erro se ajustam sozinhos.
##
## A chave (id) é a mesma string que as caixas usam no campo "ingredient".
## - en / pt: nome em inglês (aparece no jogo) e tradução (só na dica, DEPOIS de um erro)
## - cookable: precisa passar pelo fogão antes de ir para o prato
## - sprite / cooked_sprite: caminho do PNG cru / cozido. "" = ainda não existe;
##   aí o jogo desenha um placeholder da cor `color` / `cooked_color` com o nome
##   do arquivo esperado (`sprite_file` / `cooked_file`) escrito em cima.
## Quando a arte chegar: coloque o PNG em sprites/ e preencha o caminho aqui
## (e tire a linha do SPRITES_FALTANDO.md).

const DATA := {
	"EGG": {
		"en": "egg",
		"pt": "ovo",
		"cookable": true,
		"sprite": "res://sprites/ovoIcone.PNG",
		"sprite_file": "ovoIcone.PNG",
		"color": Color(0.97, 0.95, 0.9),
		"cooked_sprite": "",
		"cooked_file": "ovoCozidoIcone.PNG",
		"cooked_color": Color(1.0, 0.85, 0.3),
	},
	"BACON": {
		"en": "bacon",
		"pt": "bacon",
		"cookable": true,
		"sprite": "res://sprites/baconIcone.PNG",
		"sprite_file": "baconIcone.PNG",
		"color": Color(0.95, 0.55, 0.55),
		"cooked_sprite": "",
		"cooked_file": "baconCozidoIcone.PNG",
		"cooked_color": Color(0.7, 0.3, 0.2),
	},
	"BEEF PATTY": {
		"en": "beef patty",
		"pt": "hambúrguer de carne",
		"cookable": true,
		"sprite": "",
		"sprite_file": "carneIcone.PNG",
		"color": Color(0.85, 0.4, 0.45),
		"cooked_sprite": "",
		"cooked_file": "carneCozidaIcone.PNG",
		"cooked_color": Color(0.45, 0.27, 0.15),
	},
	"LETTUCE": {
		"en": "lettuce",
		"pt": "alface",
		"cookable": false,
		"sprite": "",
		"sprite_file": "alfaceIcone.PNG",
		"color": Color(0.45, 0.8, 0.35),
	},
}

const PLACEHOLDER_OUTLINE := Color(0.15, 0.08, 0.02)
const PLACEHOLDER_TEXT := Color(0.1, 0.05, 0.0)

## Texturas já recortadas (caminho -> Texture2D), calculadas uma vez só.
static var _crop_cache := {}


## Lista de ids na ordem acima.
static func ids() -> Array:
	return DATA.keys()


static func english(id: String) -> String:
	return DATA[id]["en"] if DATA.has(id) else id.to_lower()


static func portuguese(id: String) -> String:
	return DATA[id]["pt"] if DATA.has(id) else id.to_lower()


static func is_cookable(id: String) -> bool:
	return DATA.has(id) and DATA[id].get("cookable", false)


## Cor do placeholder (cru ou cozido).
static func color(id: String, cooked := false) -> Color:
	if not DATA.has(id):
		return Color.GRAY
	if cooked and is_cookable(id):
		return DATA[id]["cooked_color"]
	return DATA[id]["color"]


## Nome do arquivo que a arte deve ter (aparece escrito no placeholder).
static func expected_file(id: String, cooked := false) -> String:
	if not DATA.has(id):
		return "?"
	if cooked and is_cookable(id):
		return DATA[id]["cooked_file"]
	return DATA[id]["sprite_file"]


## Textura original (cru ou cozido), ou null se ainda não houver sprite.
static func texture(id: String, cooked := false) -> Texture2D:
	if not DATA.has(id):
		return null
	var key := "cooked_sprite" if cooked and is_cookable(id) else "sprite"
	return _load(DATA[id][key])


## Igual a texture(), mas recortada só na parte desenhada (sem a borda transparente).
static func icon(id: String, cooked := false) -> Texture2D:
	if not DATA.has(id):
		return null
	var key := "cooked_sprite" if cooked and is_cookable(id) else "sprite"
	return cropped(DATA[id][key])


## Carrega um PNG e recorta a borda transparente. null se o caminho for "" ou não existir.
static func cropped(path: String) -> Texture2D:
	if _crop_cache.has(path):
		return _crop_cache[path]
	var tex := _load(path)
	var result: Texture2D = tex
	if tex != null:
		var region := _opaque_rect(tex)
		if region.has_area():
			var atlas := AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = region
			result = atlas
	_crop_cache[path] = result
	return result


## Desenha o ingrediente dentro de `rect` em qualquer CanvasItem:
## o sprite (mantendo a proporção) ou o placeholder com o nome do arquivo esperado.
static func draw_icon(canvas: CanvasItem, id: String, cooked: bool, rect: Rect2) -> void:
	var tex := icon(id, cooked)
	if tex != null:
		draw_texture_fit(canvas, tex, rect)
	else:
		draw_placeholder(canvas, rect, color(id, cooked), expected_file(id, cooked))


## Desenha uma textura dentro de `rect`, centralizada e sem distorcer.
static func draw_texture_fit(canvas: CanvasItem, tex: Texture2D, rect: Rect2) -> void:
	var tex_size := tex.get_size()
	var k := minf(rect.size.x / tex_size.x, rect.size.y / tex_size.y)
	var draw_size := tex_size * k
	canvas.draw_texture_rect(tex, Rect2(rect.get_center() - draw_size / 2, draw_size), false)


## Placeholder: retângulo colorido com o nome do arquivo que falta escrito dentro.
static func draw_placeholder(canvas: CanvasItem, rect: Rect2, fill: Color, file_name: String) -> void:
	canvas.draw_rect(rect, fill)
	canvas.draw_rect(rect, PLACEHOLDER_OUTLINE, false, 2.0)
	var font := ThemeDB.fallback_font
	# Quebra o nome em duas linhas na última letra maiúscula
	# ("ovoCozidoIcone.PNG" -> "ovoCozido" / "Icone.PNG") e diminui a fonte até caber.
	var base := file_name.get_basename()
	var cut := -1
	for i in range(base.length() - 1, 0, -1):
		if base[i] != base[i].to_lower():
			cut = i
			break
	var lines: Array = [base, "." + file_name.get_extension()]
	if cut > 0:
		lines = [base.substr(0, cut), base.substr(cut) + "." + file_name.get_extension()]
	var size := 14
	while size > 6:
		var widest := 0.0
		for line in lines:
			widest = maxf(widest, font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x)
		if widest <= rect.size.x - 4:
			break
		size -= 1
	var line_h := font.get_height(size)
	var y := rect.get_center().y - line_h * lines.size() / 2.0 + font.get_ascent(size)
	for line in lines:
		var w := font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		canvas.draw_string(font, Vector2(rect.get_center().x - w / 2, y), line,
			HORIZONTAL_ALIGNMENT_LEFT, -1, size, PLACEHOLDER_TEXT)
		y += line_h


# ---------------- interno ----------------

static func _load(path: String) -> Texture2D:
	if path == "" or not ResourceLoader.exists(path):
		return null
	return load(path)


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
