# Sprites faltando

Só o que realmente falta (19/11/2026). O inventário completo e a tabela de pratos estão em `SPRITES_INVENTARIO.md`.

**Formato de todos:** PNG com fundo **transparente de verdade** (sem o xadrez cinza/branco pintado na imagem), pouca borda vazia em volta.
**Tamanho:** 512×512, igual aos sprites novos.
**Nome:** tudo minúsculo, sem acento e sem espaço.

Enquanto um sprite não existe, o jogo não trava: mostra um placeholder (retângulo colorido com o nome do arquivo esperado) ou, no caso dos pratos, o prato vazio com os ícones dos itens em cima.

**Quando um sprite chegar:** coloque em `sprites/` e me avise (ou adicione a linha em `scripts/plates.gd` / `scripts/ingredients.gd`). Depois apague a linha daqui.

## 1. Prioridade alta

| Arquivo esperado | Pasta | O que é |
|---|---|---|
| `prato_vazio.png` | `utensilios/prato/` | prato vazio (sem nada em cima). O arquivo com esse nome hoje é uma frigideira com carne: renomeie aquele antes (ver inventário, seção 5). |

## 2. Pratos de pedido (tudo cozido): liberam mais variedade no sorteio

Hoje só 5 das 25 combinações de pedido têm sprite, e as outras ficam fora do sorteio.
Cada linha abaixo que chegar entra no sorteio sozinha (depois de adicionada em `plates.gd`).
Sugestão de ordem: primeiro os de 4 itens com pão (para o pedido 3 ficar mais difícil), depois os de 3 com pão.

| Itens | Arquivo esperado | Conteúdo |
|---|---|---|
| 4 | `prato_pao_carne_cozido_bacon_cozido_alface.png` | bun + beef patty + bacon + lettuce |
| 4 | `prato_pao_carne_cozido_ovo_cozido_alface.png` | bun + beef patty + egg + lettuce (talvez seja o `hamburguer_completo_assado.png`, ver dúvida 5 do inventário) |
| 4 | `prato_pao_carne_cozido_bacon_cozido_ovo_cozido.png` | bun + beef patty + bacon + egg |
| 4 | `prato_pao_bacon_cozido_ovo_cozido_alface.png` | bun + bacon + egg + lettuce |
| 4 | `prato_carne_cozido_bacon_cozido_ovo_cozido_alface.png` | beef patty + bacon + egg + lettuce |
| 3 | `prato_pao_carne_cozido_bacon_cozido.png` | bun + beef patty + bacon |
| 3 | `prato_pao_bacon_cozido_ovo_cozido.png` | bun + bacon + egg |
| 3 | `prato_pao_bacon_cozido_alface.png` | bun + bacon + lettuce |
| 3 | `prato_pao_ovo_cozido_alface.png` | bun + egg + lettuce |
| 3 | `prato_carne_cozido_bacon_cozido_ovo_cozido.png` | beef patty + bacon + egg |
| 3 | `prato_carne_cozido_bacon_cozido_alface.png` | beef patty + bacon + lettuce |
| 3 | `prato_carne_cozido_ovo_cozido_alface.png` | beef patty + egg + lettuce |
| 3 | `prato_bacon_cozido_ovo_cozido_alface.png` | bacon + egg + lettuce |
| 2 | `prato_pao_bacon_cozido.png` | bun + bacon |
| 2 | `prato_pao_alface.png` | bun + lettuce |
| 2 | `prato_carne_cozido_bacon_cozido.png` | beef patty + bacon |
| 2 | `prato_carne_cozido_ovo_cozido.png` | beef patty + egg |
| 2 | `prato_carne_cozido_alface.png` | beef patty + lettuce |
| 2 | `prato_bacon_cozido_alface.png` | bacon + lettuce |
| 2 | `prato_ovo_cozido_alface.png` | egg + lettuce |

Os pratos intermediários (com itens crus, ou com menos itens enquanto a criança monta) **não são obrigatórios**: aparecem como prato vazio + ícones. A lista completa das 107 combinações está no inventário (seção 4b), se a colega quiser desenhar mais.

## 3. Opcional (fogão)

| Arquivo esperado | Pasta | O que é |
|---|---|---|
| `frigideira_ovo_cru.png` | `utensilios/frigideira/` | frigideira com ovo **cru** (enquanto cozinha). Hoje: frigideira vazia + ícone do ovo. |
| `frigideira_bacon_cru.png` | `utensilios/frigideira/` | frigideira com bacon **cru**. Hoje: frigideira vazia + ícone do bacon. |

## 4. Exportar de novo (com fundo transparente)

Não faltam, mas vieram com o xadrez pintado. O jogo já limpa na memória; refazer deixa mais seguro.
Lista completa no inventário, seção 5, item 3.
