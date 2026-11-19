class_name Ingredients
extends RefCounted
## Dados de TODOS os ingredientes do jogo, num lugar só.
## Para acrescentar um ingrediente novo, basta adicionar uma entrada em DATA:
## os pedidos, o menu, os itens e a dica de erro se ajustam sozinhos.
## (Os pratos montados ficam em plates.gd.)
##
## A chave (id) é a mesma string que as caixas usam no campo "ingredient".
## - en / pt: nome em inglês (aparece no jogo) e tradução (só na dica, DEPOIS de um erro)
## - cookable: precisa passar pelo fogão antes de ir para o prato
## - sprite / cooked_sprite: caminho do PNG cru / cozido. "" = ainda não existe;
##   aí o jogo desenha um placeholder da cor `color` / `cooked_color` com o nome
##   do arquivo esperado (`sprite_file` / `cooked_file`) escrito em cima.
## - box_sprite: desenho da caixa do ingrediente. "" = a caixa já faz parte do
##   fundo (egg e bacon, na ilha) ou ainda não existe.
## Quando a arte chegar: coloque o PNG em sprites/ e preencha o caminho aqui
## (e tire a linha do SPRITES_FALTANDO.md).

const DATA := {
	"EGG": {
		"en": "egg",
		"pt": "ovo",
		"cookable": true,
		"sprite": "res://sprites/ingredientes/ovo/ovoIcone.PNG",
		"sprite_file": "ovoIcone.PNG",
		"color": Color(0.97, 0.95, 0.9),
		"cooked_sprite": "res://sprites/ingredientes/ovo/ovoCozidoIcone.PNG",
		"cooked_file": "ovoCozidoIcone.PNG",
		"cooked_color": Color(1.0, 0.85, 0.3),
		"box_sprite": "",
	},
	"BACON": {
		"en": "bacon",
		"pt": "bacon",
		"cookable": true,
		"sprite": "res://sprites/ingredientes/bacon/baconCruIcone.PNG",
		"sprite_file": "baconCruIcone.PNG",
		"color": Color(0.95, 0.55, 0.55),
		"cooked_sprite": "res://sprites/ingredientes/bacon/baconIcone.PNG",
		"cooked_file": "baconIcone.PNG",
		"cooked_color": Color(0.7, 0.3, 0.2),
		"box_sprite": "",
	},
	"BEEF PATTY": {
		"en": "beef patty",
		"pt": "hambúrguer de carne",
		"cookable": true,
		"sprite": "res://sprites/ingredientes/carne/carneIcone.PNG",
		"sprite_file": "carneIcone.PNG",
		"color": Color(0.85, 0.4, 0.45),
		"cooked_sprite": "res://sprites/ingredientes/carne/carneCozidaIcone.PNG",
		"cooked_file": "carneCozidaIcone.PNG",
		"cooked_color": Color(0.45, 0.27, 0.15),
		"box_sprite": "res://sprites/ingredientes/carne/caixaCarne.PNG",
	},
	"LETTUCE": {
		"en": "lettuce",
		"pt": "alface",
		"cookable": false,
		"sprite": "res://sprites/ingredientes/alface/alfaceIcone.PNG",
		"sprite_file": "alfaceIcone.PNG",
		"color": Color(0.45, 0.8, 0.35),
		"box_sprite": "res://sprites/ingredientes/alface/caixaAlface.PNG",
	},
	"BUN": {
		"en": "bun",
		"pt": "pão",
		"cookable": false,
		"sprite": "res://sprites/ingredientes/pao/paoHamburguer.png",
		"sprite_file": "paoHamburguer.png",
		"color": Color(0.93, 0.68, 0.35),
		"box_sprite": "res://sprites/ingredientes/pao/caixaPaoHamburguer.png",
	},
}

const PLACEHOLDER_OUTLINE := Color(0.15, 0.08, 0.02)
const PLACEHOLDER_TEXT := Color(0.1, 0.05, 0.0)

## Lado máximo (em pixels) das texturas preparadas. Na tela nada passa de ~130 px,
## então diminuir deixa o jogo leve e a limpeza do fundo rápida.
const MAX_TEXTURE_SIDE := 256

## Texturas já preparadas (caminho -> Texture2D), calculadas uma vez só.
static var _crop_cache := {}
## Onde fica a parte desenhada dentro da imagem original (caminho -> Rect2 de 0 a 1).
static var _crop_rect_cache := {}


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


## Sprite do ingrediente (cru ou cozido) já recortado, ou null se ainda não houver.
static func icon(id: String, cooked := false) -> Texture2D:
	if not DATA.has(id):
		return null
	var key := "cooked_sprite" if cooked and is_cookable(id) else "sprite"
	return cropped(DATA[id][key])


## Sprite da caixa do ingrediente já recortado, ou null.
static func box_icon(id: String) -> Texture2D:
	if not DATA.has(id):
		return null
	return cropped(DATA[id].get("box_sprite", ""))


## Prepara de uma vez os sprites de todos os ingredientes e caixas
## (assim não há engasgo na primeira vez que cada um aparece).
static func preload_all() -> void:
	for id in DATA:
		for key in ["sprite", "cooked_sprite", "box_sprite"]:
			cropped(DATA[id].get(key, ""))


## Carrega um PNG, apaga o "xadrez de transparência" que alguns desenhos trazem
## pintado em volta (sem mexer no arquivo) e recorta a borda vazia.
## Retorna null se o caminho for "" ou o arquivo não existir (ou não foi importado).
static func cropped(path: String) -> Texture2D:
	if _crop_cache.has(path):
		return _crop_cache[path]
	var tex := _load(path)
	var result: Texture2D = tex
	if tex != null:
		var img := tex.get_image()
		if img != null:
			img = img.duplicate()
			if img.is_compressed():
				img.decompress()
			img.convert(Image.FORMAT_RGBA8)
			var k := minf(1.0, MAX_TEXTURE_SIDE / float(maxi(img.get_width(), img.get_height())))
			if k < 1.0:
				img.resize(maxi(1, roundi(img.get_width() * k)), maxi(1, roundi(img.get_height() * k)),
					Image.INTERPOLATE_NEAREST)
			_remove_fake_checker(img)
			var used := img.get_used_rect()
			if used.has_area():
				var size := Vector2(img.get_width(), img.get_height())
				_crop_rect_cache[path] = Rect2(Vector2(used.position) / size, Vector2(used.size) / size)
				img = img.get_region(used)
			result = ImageTexture.create_from_image(img)
	_crop_cache[path] = result
	return result


## Parte desenhada da imagem original, em frações (0 a 1). Usado para alinhar
## sprites trocados no mesmo lugar (ex.: frigideiras do fogão).
static func cropped_rect(path: String) -> Rect2:
	cropped(path)
	return _crop_rect_cache.get(path, Rect2(0, 0, 1, 1))


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
	# Quebra o nome em duas linhas na última letra maiúscula ou "_"
	# ("ovoCozidoIcone.PNG" -> "ovoCozido" / "Icone.PNG") e diminui a fonte até caber.
	var base := file_name.get_basename()
	var cut := -1
	for i in range(base.length() - 1, 0, -1):
		if base[i] != base[i].to_lower() or base[i] == "_":
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
	return load(path) as Texture2D


## Alguns PNGs vieram com o xadrez cinza/branco de "transparência" pintado de
## verdade em volta do desenho. Aqui ele é apagado na memória (o arquivo não muda):
## a partir da borda, tudo que for transparente ou branco/cinza-claro e estiver
## ligado à borda vira transparente. O contorno escuro do desenho segura a
## "inundação" (flood fill), então o desenho em si não é afetado.
static func _remove_fake_checker(img: Image) -> void:
	var r := img.get_used_rect()
	if not r.has_area():
		return
	var w := img.get_width()
	var h := img.get_height()
	var data := img.get_data()
	var visited := PackedByteArray()
	visited.resize(w * h)
	var x0 := r.position.x
	var y0 := r.position.y
	var x1 := r.end.x - 1
	var y1 := r.end.y - 1
	var stack := PackedInt32Array()
	for x in range(x0, x1 + 1):
		stack.push_back(y0 * w + x)
		stack.push_back(y1 * w + x)
	for y in range(y0, y1 + 1):
		stack.push_back(y * w + x0)
		stack.push_back(y * w + x1)
	var changed := false
	while not stack.is_empty():
		var p: int = stack[stack.size() - 1]
		stack.resize(stack.size() - 1)
		if visited[p] != 0:
			continue
		visited[p] = 1
		var i := p * 4
		var a := data[i + 3]
		if a >= 128:
			var lo := mini(data[i], mini(data[i + 1], data[i + 2]))
			var hi := maxi(data[i], maxi(data[i + 1], data[i + 2]))
			if lo < 175 or hi - lo > 14:
				continue  # pixel do desenho: para aqui
		if a != 0:
			data[i + 3] = 0
			changed = true
		var x := p % w
		var y := p / w
		if x > x0:
			stack.push_back(p - 1)
		if x < x1:
			stack.push_back(p + 1)
		if y > y0:
			stack.push_back(p - w)
		if y < y1:
			stack.push_back(p + w)
	if changed:
		img.set_data(w, h, false, Image.FORMAT_RGBA8, data)
