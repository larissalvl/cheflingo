# Inventário dos sprites (19/11/2026)

Tudo o que existe em `sprites/`, conferido pelo nome **e** pela imagem.
Nenhum arquivo de arte foi renomeado, movido ou editado.

Estados: **cru** / **cozido**. Lettuce e bun não vão ao fogão (só existe um estado).

## 1. Classificação de todos os arquivos

| Arquivo | Tamanho | Categoria | O que o desenho mostra | Usado no jogo? |
|---|---|---|---|---|
| `fundo/fundo.PNG` | 1671×941 | outros (cenário) | a cozinha inteira (a ilha já tem as caixas de ovo e bacon desenhadas) | sim, fundo |
| `Players/raposa/raposaIdle.PNG`, `raposaAndar1.PNG`, `raposaAndar2.PNG` | 4096×4096 | outros (personagem) | chef J1 (raposa) parado / andando | sim |
| `Players/esquilo/esquiloParado.PNG`, `esquiloAndando1.PNG`, `esquiloAndando2.PNG` | 4096×4096 | outros (personagem) | chef J2 (esquilo) parado / andando | sim |
| `ingredientes/ovo/ovoIcone.PNG` | 1536×1024 | ingrediente cru | ovo inteiro | sim, egg cru |
| `ingredientes/ovo/ovoCozidoIcone.PNG` | 512×512 | ingrediente cozido | ovo frito | sim, egg cozido |
| `ingredientes/bacon/baconCruIcone.PNG` | 512×512 | ingrediente cru | 1 fatia de bacon cru | sim, bacon cru |
| `ingredientes/bacon/baconIcone.PNG` | 1536×1024 | ingrediente cozido | 2 fatias de bacon frito | sim, bacon cozido |
| `ingredientes/carne/carneIcone.PNG` | 512×512 | ingrediente cru | hambúrguer de carne cru (vermelho) | sim, beef patty cru |
| `ingredientes/carne/carneCozidaIcone.PNG` | 512×512 | ingrediente cozido | hambúrguer de carne grelhado | sim, beef patty cozido |
| `ingredientes/alface/alfaceIcone.PNG` | 512×512 | ingrediente (não cozinha) | folha de alface | sim, lettuce |
| `ingredientes/pao/paoHamburguer.png` | 512×512 | ingrediente (não cozinha) | pão de hambúrguer | sim, bun |
| `ingredientes/carne/caixaCarne.PNG` | 256×256 | caixa | caixa com carnes | sim, caixa de beef patty |
| `ingredientes/alface/caixaAlface.PNG` | 256×256 | caixa | caixa com alface | sim, caixa de lettuce |
| `ingredientes/pao/caixaPaoHamburguer.png` | 512×512 | caixa | caixa com pães | sim, caixa de bun (nova) |
| `moveis/fogao/fogaoApagado.PNG` | 1312×1199 | estação (fogão) | fogão apagado, sem frigideira | sim |
| `moveis/fogao/fogaoAceso.PNG` | 1312×1199 | estação (fogão) | fogão aceso, sem frigideira | sim |
| `utensilios/frigideira/frigideiraVazia.PNG` | 1536×1024 | frigideira | frigideira vazia | sim |
| `utensilios/frigideira/frigideiraOvo.PNG` | 1536×1024 | frigideira | frigideira com ovo **frito** | sim, egg cozido no fogão |
| `utensilios/frigideira/frigideiraBacon.PNG` | 1536×1024 | frigideira | frigideira com bacon (parece **frito**) | sim, bacon cozido no fogão |
| `utensilios/frigideira/frigideiraOvoBacon.PNG` | 1536×1024 | frigideira | ovo + bacon juntos | não (o fogão cozinha 1 item por vez) |
| `utensilios/frigideira/frigideiraCarneAssada.png` | 512×512 | frigideira | frigideira com carne **CRUA** ⚠ | sim, beef patty **cru** no fogão |
| `utensilios/frigideira/frigideiraCarneCrua.png` | 512×512 | frigideira | frigideira **VAZIA** ⚠ | não |
| `utensilios/prato/prato_vazio.png` | 512×512 | frigideira ⚠ | frigideira com carne **ASSADA** (não é prato!) | sim, beef patty **cozido** no fogão |
| `utensilios/prato/*.png` (demais) e `pratoOvoeBacon.PNG` | 512×512 / 1536×1024 | prato | ver seções 2 e 3 | ver seções 2 e 3 |

## 2. Pratos usados no jogo (arquivo → itens)

Nome e desenho batem. É a tabela de `scripts/plates.gd`.

| Arquivo | Itens (id + estado) |
|---|---|
| `utensilios/prato/prato_ovo_cozido.png` | EGG cozido |
| `utensilios/prato/prato_bacon_cru.png` | BACON cru |
| `utensilios/prato/prato_carne_crua.png` | BEEF PATTY cru |
| `utensilios/prato/prato_carne_assada.png` | BEEF PATTY cozido |
| `utensilios/prato/prato_carne_crua_alface.png` | BEEF PATTY cru + LETTUCE |
| `utensilios/prato/prato_carne_crua_ovo_assado.png` | BEEF PATTY cru + EGG cozido |
| `pratoOvoeBacon.PNG` (raiz de sprites/) | EGG cozido + BACON cozido |
| `utensilios/prato/prato_pao_carne_crua.png` | BUN + BEEF PATTY cru |
| `utensilios/prato/prato_pao_hamburguer_assado.png` | BUN + BEEF PATTY cozido |
| `utensilios/prato/prato_pao_ovo.png` | BUN + EGG cozido (o nome não diz o estado; o desenho é ovo frito) |
| `utensilios/prato/prato_hamburguer_alface.png` | BUN + BEEF PATTY cozido + LETTUCE (pelo desenho, ver dúvida 6) |
| `utensilios/prato/prato_hamburguer_ovo_assados.png` | BUN + BEEF PATTY cozido + EGG cozido (pelo desenho, ver dúvida 6) |

## 3. Pratos NÃO usados (duplicados ou duvidosos)

| Arquivo | Nome diz | Desenho mostra | Motivo |
|---|---|---|---|
| `prato_hamburguer_cru.png` | hambúrguer cru | carne crua sozinha | duplicado de `prato_carne_crua.png` |
| `pratoOvo.PNG` | ovo | ovo frito (estilo antigo, 1536×1024) | duplicado de `prato_ovo_cozido.png` |
| `hamburguer_carne_crua.png` | pão + carne crua? | só o pão (+ pedaço de outro desenho cortado no canto) | nome ≠ desenho |
| `hamburguer_bacon_alface.png` | bacon + alface | pão + bacon, **sem alface** | nome ≠ desenho |
| `hamburguer_cru_alface_bacon.png` | carne crua + alface + bacon | pão + carne crua + alface, **sem bacon** | nome ≠ desenho |
| `hamburguer_cru_ovo_bacon.png` | carne crua + ovo + bacon | pão + carne (parece **assada**) + bacon, **sem ovo** | nome ≠ desenho |
| `hamburguer_completo_assado.png` | completo, assado | pão + carne assada + alface + ovo, **sem bacon** | "completo" sem bacon |
| `prato_hamburguer_completo_cru.png` | completo, cru | pão + alface + bacon (a carne não aparece) + pedaço cortado embaixo | nome ≠ desenho |

## 4. Combinações possíveis

Ingredientes: egg, bacon, beef patty (cada um cru ou cozido), lettuce e bun (um estado só).
Cada um entra no máximo 1 vez por prato, então são **107 combinações** possíveis (sem contar o prato vazio).
**12 têm sprite.** As outras 95 aparecem como "prato vazio + ícones dos itens em cima", sem erro.

### 4a. Pratos de pedido (o que a criança entrega certo: tudo cozido)

Pedido 1 = 2 itens, pedido 2 = 3 itens, pedido 3 = 3 ou 4 itens: 25 combinações possíveis.
**Só 5 têm sprite**; as outras 20 estão FORA do sorteio (o jogo avisa no console).
Hoje, portanto: o pedido 1 sorteia entre 3 combinações; os pedidos 2 e 3 são sempre
"bun + beef patty + egg" e "bun + beef patty + lettuce" (em ordem aleatória).

Regra de nome sugerida para os que faltam: `prato_` + itens na ordem pao, carne, bacon, ovo, alface,
com `_cru`/`_cozido` depois de cada item que vai ao fogão. Tudo minúsculo, sem acento.

| Itens | Combinação (tudo cozido) | Sprite |
|---|---|---|
| 2 | bun + beef patty (cozido) | `prato_pao_hamburguer_assado.png` |
| 2 | bun + bacon (cozido) | ❌ falta (sugestão: `prato_pao_bacon_cozido.png`) |
| 2 | bun + egg (cozido) | `prato_pao_ovo.png` |
| 2 | bun + lettuce | ❌ falta (sugestão: `prato_pao_alface.png`) |
| 2 | beef patty (cozido) + bacon (cozido) | ❌ falta (sugestão: `prato_carne_cozido_bacon_cozido.png`) |
| 2 | beef patty (cozido) + egg (cozido) | ❌ falta (sugestão: `prato_carne_cozido_ovo_cozido.png`) |
| 2 | beef patty (cozido) + lettuce | ❌ falta (sugestão: `prato_carne_cozido_alface.png`) |
| 2 | bacon (cozido) + egg (cozido) | `pratoOvoeBacon.PNG` |
| 2 | bacon (cozido) + lettuce | ❌ falta (sugestão: `prato_bacon_cozido_alface.png`) |
| 2 | egg (cozido) + lettuce | ❌ falta (sugestão: `prato_ovo_cozido_alface.png`) |
| 3 | bun + beef patty (cozido) + bacon (cozido) | ❌ falta (sugestão: `prato_pao_carne_cozido_bacon_cozido.png`) |
| 3 | bun + beef patty (cozido) + egg (cozido) | `prato_hamburguer_ovo_assados.png` |
| 3 | bun + beef patty (cozido) + lettuce | `prato_hamburguer_alface.png` |
| 3 | bun + bacon (cozido) + egg (cozido) | ❌ falta (sugestão: `prato_pao_bacon_cozido_ovo_cozido.png`) |
| 3 | bun + bacon (cozido) + lettuce | ❌ falta (sugestão: `prato_pao_bacon_cozido_alface.png`) |
| 3 | bun + egg (cozido) + lettuce | ❌ falta (sugestão: `prato_pao_ovo_cozido_alface.png`) |
| 3 | beef patty (cozido) + bacon (cozido) + egg (cozido) | ❌ falta (sugestão: `prato_carne_cozido_bacon_cozido_ovo_cozido.png`) |
| 3 | beef patty (cozido) + bacon (cozido) + lettuce | ❌ falta (sugestão: `prato_carne_cozido_bacon_cozido_alface.png`) |
| 3 | beef patty (cozido) + egg (cozido) + lettuce | ❌ falta (sugestão: `prato_carne_cozido_ovo_cozido_alface.png`) |
| 3 | bacon (cozido) + egg (cozido) + lettuce | ❌ falta (sugestão: `prato_bacon_cozido_ovo_cozido_alface.png`) |
| 4 | bun + beef patty (cozido) + bacon (cozido) + egg (cozido) | ❌ falta (sugestão: `prato_pao_carne_cozido_bacon_cozido_ovo_cozido.png`) |
| 4 | bun + beef patty (cozido) + bacon (cozido) + lettuce | ❌ falta (sugestão: `prato_pao_carne_cozido_bacon_cozido_alface.png`) |
| 4 | bun + beef patty (cozido) + egg (cozido) + lettuce | ❌ falta (sugestão: `prato_pao_carne_cozido_ovo_cozido_alface.png`) |
| 4 | bun + bacon (cozido) + egg (cozido) + lettuce | ❌ falta (sugestão: `prato_pao_bacon_cozido_ovo_cozido_alface.png`) |
| 4 | beef patty (cozido) + bacon (cozido) + egg (cozido) + lettuce | ❌ falta (sugestão: `prato_carne_cozido_bacon_cozido_ovo_cozido_alface.png`) |

### 4b. Todas as 107 combinações

| Itens | Combinação | Sprite |
|---|---|---|
| 1 | bacon (cozido) | — |
| 1 | bacon (cru) | `prato_bacon_cru.png` |
| 1 | beef patty (cozido) | `prato_carne_assada.png` |
| 1 | beef patty (cru) | `prato_carne_crua.png` |
| 1 | bun | — |
| 1 | egg (cozido) | `prato_ovo_cozido.png` |
| 1 | egg (cru) | — |
| 1 | lettuce | — |
| 2 | bacon (cozido) + egg (cozido) | `pratoOvoeBacon.PNG` |
| 2 | bacon (cozido) + egg (cru) | — |
| 2 | bacon (cozido) + lettuce | — |
| 2 | bacon (cru) + egg (cozido) | — |
| 2 | bacon (cru) + egg (cru) | — |
| 2 | bacon (cru) + lettuce | — |
| 2 | beef patty (cozido) + bacon (cozido) | — |
| 2 | beef patty (cozido) + bacon (cru) | — |
| 2 | beef patty (cozido) + egg (cozido) | — |
| 2 | beef patty (cozido) + egg (cru) | — |
| 2 | beef patty (cozido) + lettuce | — |
| 2 | beef patty (cru) + bacon (cozido) | — |
| 2 | beef patty (cru) + bacon (cru) | — |
| 2 | beef patty (cru) + egg (cozido) | `prato_carne_crua_ovo_assado.png` |
| 2 | beef patty (cru) + egg (cru) | — |
| 2 | beef patty (cru) + lettuce | `prato_carne_crua_alface.png` |
| 2 | bun + bacon (cozido) | — |
| 2 | bun + bacon (cru) | — |
| 2 | bun + beef patty (cozido) | `prato_pao_hamburguer_assado.png` |
| 2 | bun + beef patty (cru) | `prato_pao_carne_crua.png` |
| 2 | bun + egg (cozido) | `prato_pao_ovo.png` |
| 2 | bun + egg (cru) | — |
| 2 | bun + lettuce | — |
| 2 | egg (cozido) + lettuce | — |
| 2 | egg (cru) + lettuce | — |
| 3 | bacon (cozido) + egg (cozido) + lettuce | — |
| 3 | bacon (cozido) + egg (cru) + lettuce | — |
| 3 | bacon (cru) + egg (cozido) + lettuce | — |
| 3 | bacon (cru) + egg (cru) + lettuce | — |
| 3 | beef patty (cozido) + bacon (cozido) + egg (cozido) | — |
| 3 | beef patty (cozido) + bacon (cozido) + egg (cru) | — |
| 3 | beef patty (cozido) + bacon (cozido) + lettuce | — |
| 3 | beef patty (cozido) + bacon (cru) + egg (cozido) | — |
| 3 | beef patty (cozido) + bacon (cru) + egg (cru) | — |
| 3 | beef patty (cozido) + bacon (cru) + lettuce | — |
| 3 | beef patty (cozido) + egg (cozido) + lettuce | — |
| 3 | beef patty (cozido) + egg (cru) + lettuce | — |
| 3 | beef patty (cru) + bacon (cozido) + egg (cozido) | — |
| 3 | beef patty (cru) + bacon (cozido) + egg (cru) | — |
| 3 | beef patty (cru) + bacon (cozido) + lettuce | — |
| 3 | beef patty (cru) + bacon (cru) + egg (cozido) | — |
| 3 | beef patty (cru) + bacon (cru) + egg (cru) | — |
| 3 | beef patty (cru) + bacon (cru) + lettuce | — |
| 3 | beef patty (cru) + egg (cozido) + lettuce | — |
| 3 | beef patty (cru) + egg (cru) + lettuce | — |
| 3 | bun + bacon (cozido) + egg (cozido) | — |
| 3 | bun + bacon (cozido) + egg (cru) | — |
| 3 | bun + bacon (cozido) + lettuce | — |
| 3 | bun + bacon (cru) + egg (cozido) | — |
| 3 | bun + bacon (cru) + egg (cru) | — |
| 3 | bun + bacon (cru) + lettuce | — |
| 3 | bun + beef patty (cozido) + bacon (cozido) | — |
| 3 | bun + beef patty (cozido) + bacon (cru) | — |
| 3 | bun + beef patty (cozido) + egg (cozido) | `prato_hamburguer_ovo_assados.png` |
| 3 | bun + beef patty (cozido) + egg (cru) | — |
| 3 | bun + beef patty (cozido) + lettuce | `prato_hamburguer_alface.png` |
| 3 | bun + beef patty (cru) + bacon (cozido) | — |
| 3 | bun + beef patty (cru) + bacon (cru) | — |
| 3 | bun + beef patty (cru) + egg (cozido) | — |
| 3 | bun + beef patty (cru) + egg (cru) | — |
| 3 | bun + beef patty (cru) + lettuce | — |
| 3 | bun + egg (cozido) + lettuce | — |
| 3 | bun + egg (cru) + lettuce | — |
| 4 | beef patty (cozido) + bacon (cozido) + egg (cozido) + lettuce | — |
| 4 | beef patty (cozido) + bacon (cozido) + egg (cru) + lettuce | — |
| 4 | beef patty (cozido) + bacon (cru) + egg (cozido) + lettuce | — |
| 4 | beef patty (cozido) + bacon (cru) + egg (cru) + lettuce | — |
| 4 | beef patty (cru) + bacon (cozido) + egg (cozido) + lettuce | — |
| 4 | beef patty (cru) + bacon (cozido) + egg (cru) + lettuce | — |
| 4 | beef patty (cru) + bacon (cru) + egg (cozido) + lettuce | — |
| 4 | beef patty (cru) + bacon (cru) + egg (cru) + lettuce | — |
| 4 | bun + bacon (cozido) + egg (cozido) + lettuce | — |
| 4 | bun + bacon (cozido) + egg (cru) + lettuce | — |
| 4 | bun + bacon (cru) + egg (cozido) + lettuce | — |
| 4 | bun + bacon (cru) + egg (cru) + lettuce | — |
| 4 | bun + beef patty (cozido) + bacon (cozido) + egg (cozido) | — |
| 4 | bun + beef patty (cozido) + bacon (cozido) + egg (cru) | — |
| 4 | bun + beef patty (cozido) + bacon (cozido) + lettuce | — |
| 4 | bun + beef patty (cozido) + bacon (cru) + egg (cozido) | — |
| 4 | bun + beef patty (cozido) + bacon (cru) + egg (cru) | — |
| 4 | bun + beef patty (cozido) + bacon (cru) + lettuce | — |
| 4 | bun + beef patty (cozido) + egg (cozido) + lettuce | — |
| 4 | bun + beef patty (cozido) + egg (cru) + lettuce | — |
| 4 | bun + beef patty (cru) + bacon (cozido) + egg (cozido) | — |
| 4 | bun + beef patty (cru) + bacon (cozido) + egg (cru) | — |
| 4 | bun + beef patty (cru) + bacon (cozido) + lettuce | — |
| 4 | bun + beef patty (cru) + bacon (cru) + egg (cozido) | — |
| 4 | bun + beef patty (cru) + bacon (cru) + egg (cru) | — |
| 4 | bun + beef patty (cru) + bacon (cru) + lettuce | — |
| 4 | bun + beef patty (cru) + egg (cozido) + lettuce | — |
| 4 | bun + beef patty (cru) + egg (cru) + lettuce | — |
| 5 | bun + beef patty (cozido) + bacon (cozido) + egg (cozido) + lettuce | — |
| 5 | bun + beef patty (cozido) + bacon (cozido) + egg (cru) + lettuce | — |
| 5 | bun + beef patty (cozido) + bacon (cru) + egg (cozido) + lettuce | — |
| 5 | bun + beef patty (cozido) + bacon (cru) + egg (cru) + lettuce | — |
| 5 | bun + beef patty (cru) + bacon (cozido) + egg (cozido) + lettuce | — |
| 5 | bun + beef patty (cru) + bacon (cozido) + egg (cru) + lettuce | — |
| 5 | bun + beef patty (cru) + bacon (cru) + egg (cozido) + lettuce | — |
| 5 | bun + beef patty (cru) + bacon (cru) + egg (cru) + lettuce | — |

## 5. Nomes de arquivo problemáticos (NÃO renomeados, para a Larissa resolver)

Nenhum arquivo tem acento ou espaço. Problemas encontrados:

1. **Conteúdo trocado nas frigideiras de carne:** `frigideiraCarneAssada.png` mostra carne **crua**; `frigideiraCarneCrua.png` mostra a frigideira **vazia**; `prato_vazio.png` mostra a frigideira com carne **assada**. O jogo usa pelo desenho (ver `PAN_SPRITES` em `scripts/stations/stove.gd`). Sugestão: `frigideiraCarneAssada.png` → `frigideiraCarneCrua.png`; `prato_vazio.png` → `utensilios/frigideira/frigideiraCarneAssada.png`; apagar a frigideira vazia repetida. **Depois de renomear, me avise** para eu ajustar os caminhos (senão o fogão volta a mostrar a frigideira vazia + ícone, sem crash).
2. **Não existe prato vazio:** o `pratoVazio.PNG` antigo foi apagado e o `prato_vazio.png` novo é uma frigideira. O jogo desenha um placeholder.
3. **Xadrez de transparência pintado na imagem:** estes PNGs têm o xadrez branco desenhado de verdade em volta do desenho (não é transparência). O jogo apaga esse xadrez na memória ao carregar, mas o certo é exportar de novo com fundo transparente: `paoHamburguer.png`, `caixaPaoHamburguer.png`, `frigideiraCarneAssada.png`, `frigideiraCarneCrua.png`, `prato_vazio.png`, `prato_bacon_cru.png`, `prato_ovo_cozido.png`, `prato_pao_carne_crua.png`, `prato_pao_hamburguer_assado.png`, `prato_pao_ovo.png`, `prato_hamburguer_alface.png`, `prato_hamburguer_ovo_assados.png`, `prato_hamburguer_cru.png`, `prato_hamburguer_completo_cru.png` e os 5 `hamburguer_*.png`.
4. **Extensão com maiúscula inconsistente:** os antigos são `.PNG`, os novos `.png`.
5. **Estilos de nome misturados:** camelCase (`frigideiraCarneAssada`, `pratoOvo`) e snake_case (`prato_carne_crua`).
6. **Pasta com maiúscula:** `Players/` (as outras são minúsculas).
7. **Arquivo fora da pasta:** `sprites/pratoOvoeBacon.PNG` está na raiz de `sprites/` (o lugar seria `utensilios/prato/`). Se mover, me avise.
8. **"hamburguer" com dois sentidos:** em `prato_hamburguer_cru.png` é só a carne; em `prato_hamburguer_alface.png` e `prato_hamburguer_ovo_assados.png` é pão + carne.
9. `prato_hamburguer_ovo_assados.png`: "assados" no plural (os outros usam singular).

## 6. Dúvidas de interpretação

1. `hamburguer_carne_crua.png`: o nome sugere pão + carne crua, mas só aparece o pão. É o prato "só bun"? Ou faltou a carne?
2. `hamburguer_bacon_alface.png`: aparece pão + bacon, sem alface. É "bun + bacon"? O bacon é cru ou cozido?
3. `hamburguer_cru_alface_bacon.png`: aparece pão + carne crua + alface, sem bacon.
4. `hamburguer_cru_ovo_bacon.png`: aparece pão + carne (parece assada) + bacon, sem ovo.
5. `hamburguer_completo_assado.png` e `prato_hamburguer_completo_cru.png`: o que é "completo"? O primeiro não tem bacon; no segundo a carne não aparece. Se o primeiro for bun + beef patty + lettuce + egg (tudo cozido), ele já serve e libera um pedido 3 com 4 itens: é só confirmar.
6. `prato_hamburguer_alface.png` e `prato_hamburguer_ovo_assados.png`: usados pelo desenho (têm pão). Confirmar.
7. `prato_bacon_cru.png`: o bacon do desenho parece o bacon frito do `baconIcone`. É cru mesmo?
8. `frigideiraBacon.PNG`: considerado bacon **cozido** (parece frito). Confirmar.
