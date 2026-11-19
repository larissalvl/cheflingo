# Prompt para o ChatGPT: pratos que faltam (PRIORIDADE A)

> **Concluído em 19/11:** os 16 pratos abaixo foram gerados e já estão no jogo. Os 73 da PRIORIDADE B também já existem. O texto fica aqui de modelo, caso precise refazer algum.

Como usar:
1. Abra uma conversa nova no ChatGPT (com geração de imagem).
2. Anexe 2 ou 3 pratos atuais como referência de estilo. Sugestão: `sprites/utensilios/prato/prato_bun_beef-cozido_lettuce.png`, `prato_bun_beef-cozido_egg-cozido.png` e `prato_bacon-cozido_egg-cozido.png` (este último mostra o bacon frito).
3. Cole o texto abaixo. Peça **uma imagem por vez** ("agora a 2", "agora a 3"...), para não misturar.
4. Salve cada imagem com o nome exato da lista, em `sprites/utensilios/prato/`.
5. Confira cada imagem antes de salvar: fundo realmente transparente (sem xadrez desenhado), itens certos, nada a mais. O ChatGPT costuma "pintar" o xadrez de transparência; se acontecer, peça de novo ou use um removedor de fundo.

Tamanho: 512×512, igual aos pratos atuais com comida. (O `prato_vazio.png` atual é de um lote antigo, 1536×1024; não use ele como referência de tamanho.)

---

## Texto para colar

I am making a pixel art cooking game for kids. I need new food plate sprites that match EXACTLY the style of the plate images I attached.

**Style (copy the attached images):**
- Pixel art, 3/4 top-down view (slightly from above, the plate looks like a wide oval).
- Cream/beige round plate with a thin green double line near the rim and a dark brown/black pixel outline around the plate.
- Soft light highlights, warm colors, crisp pixels, no blur, no anti-aliasing glow.
- Food centered on the plate, stacked like a burger when there is a bun. Stacking order from bottom to top: bun, beef patty, bacon, lettuce, egg.
- Only the items listed for each image. No extra food, no sauce, no top bun, no cutlery, no table, no text, no shadow under the plate.

**Technical requirements (very important):**
- One plate per image.
- PNG, 512×512 pixels.
- REAL transparent background (alpha channel). Do NOT draw a gray/white checkerboard pattern: everything outside the plate must be fully transparent.
- The plate should take about the middle half of the canvas (around 260×180 pixels), centered, with empty transparent space around it, like the attached images.
- Same plate size and position in every image.

**How each item must look:**
- bun = bottom half of a golden toasted burger bun.
- beef patty (cooked) = dark brown grilled patty with grill marks.
- bacon (cooked) = 2 crispy wavy fried strips, same look as the bacon in the attached plates.
- lettuce = ruffled bright green leaf.
- egg (cooked) = fried egg, white with a round yellow yolk.

**Images to make (file name: items).** Make only image 1 now; I will ask for the next ones one by one.

1. **prato_beef-cozido_bacon-cozido_lettuce_egg-cozido.png**: GRILLED beef patty: dark brown with grill marks (cooked); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; ruffled bright green lettuce leaf; FRIED egg: white with a round yellow yolk (cooked).
2. **prato_bun_bacon-cozido_lettuce_egg-cozido.png**: bottom half of a golden toasted burger bun (round, light orange-brown, always at the very bottom of the stack); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; ruffled bright green lettuce leaf; FRIED egg: white with a round yellow yolk (cooked).
3. **prato_bun_beef-cozido_bacon-cozido_egg-cozido.png**: bottom half of a golden toasted burger bun (round, light orange-brown, always at the very bottom of the stack); GRILLED beef patty: dark brown with grill marks (cooked); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; FRIED egg: white with a round yellow yolk (cooked).
4. **prato_bun_beef-cozido_bacon-cozido_lettuce.png**: bottom half of a golden toasted burger bun (round, light orange-brown, always at the very bottom of the stack); GRILLED beef patty: dark brown with grill marks (cooked); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; ruffled bright green lettuce leaf.
5. **prato_bacon-cozido_lettuce_egg-cozido.png**: CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; ruffled bright green lettuce leaf; FRIED egg: white with a round yellow yolk (cooked).
6. **prato_beef-cozido_bacon-cozido_egg-cozido.png**: GRILLED beef patty: dark brown with grill marks (cooked); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; FRIED egg: white with a round yellow yolk (cooked).
7. **prato_beef-cozido_bacon-cozido_lettuce.png**: GRILLED beef patty: dark brown with grill marks (cooked); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; ruffled bright green lettuce leaf.
8. **prato_beef-cozido_lettuce_egg-cozido.png**: GRILLED beef patty: dark brown with grill marks (cooked); ruffled bright green lettuce leaf; FRIED egg: white with a round yellow yolk (cooked).
9. **prato_bun_bacon-cozido_egg-cozido.png**: bottom half of a golden toasted burger bun (round, light orange-brown, always at the very bottom of the stack); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; FRIED egg: white with a round yellow yolk (cooked).
10. **prato_bun_lettuce_egg-cozido.png**: bottom half of a golden toasted burger bun (round, light orange-brown, always at the very bottom of the stack); ruffled bright green lettuce leaf; FRIED egg: white with a round yellow yolk (cooked).
11. **prato_bacon-cozido_lettuce.png**: CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates; ruffled bright green lettuce leaf.
12. **prato_beef-cozido_bacon-cozido.png**: GRILLED beef patty: dark brown with grill marks (cooked); CRISPY FRIED bacon: 2 wavy strips (cooked), same look as the bacon in the attached plates.
13. **prato_beef-cozido_egg-cozido.png**: GRILLED beef patty: dark brown with grill marks (cooked); FRIED egg: white with a round yellow yolk (cooked).
14. **prato_beef-cozido_lettuce.png**: GRILLED beef patty: dark brown with grill marks (cooked); ruffled bright green lettuce leaf.
15. **prato_bun_lettuce.png**: bottom half of a golden toasted burger bun (round, light orange-brown, always at the very bottom of the stack); ruffled bright green lettuce leaf.
16. **prato_lettuce_egg-cozido.png**: ruffled bright green lettuce leaf; FRIED egg: white with a round yellow yolk (cooked).
