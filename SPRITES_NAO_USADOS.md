# Sprites que o jogo não usa (19/11/2026)

Atualizado em 19/11 depois da limpeza.

Como os pratos e as frigideiras são achados **pelo nome**, "usado" aqui quer dizer: alguma cena ou script carrega o arquivo, ou o nome segue a convenção e o jogo o encontra sozinho.

## 1. Arquivos sem uso

**Nenhum.** Os 5 da lista anterior foram apagados em 19/11 a pedido da Larissa: `prato_egg-cozido_2.png`, `prato_beef-cru_2.png`, `frigideira_vazia_2.png`, `frigideira_bacon-cozido_egg-cozido.png` (com os `.import`) e o `.import` órfão `sprites/pratoOvo.PNG.import`. Eles ainda estão no git, no commit `a888262`, com os nomes antigos.

O "fogaoApagado dentro de scripts/" não existe. São só arquivos de cache da Godot em `.godot/imported/`: ela gera sozinha, eles não vão para o git e não são arte.

## 2. Usados, mas com o desenho diferente do que o nome antigo prometia (pedir correção)

Estes já foram renomeados pelo que mostram, e o jogo usa assim. Se a ideia era outra, peça à colega para refazer o desenho.

| Nome antigo | O que o nome prometia | O que o desenho mostra (nome novo) |
|---|---|---|
| `prato/prato_vazio.png` | prato vazio | frigideira com carne **assada** (`frigideira_beef_cozido.png`) |
| `frigideira/frigideiraCarneAssada.png` | frigideira com carne assada | carne **crua** (`frigideira_beef_cru.png`) |
| `frigideira/frigideiraCarneCrua.png` | frigideira com carne crua | frigideira **vazia** (`frigideira_vazia_2.png`) |
| `prato/hamburguer_carne_crua.png` | pão + carne crua | **só o pão** (`prato_bun.png`) + um pedaço de outro desenho cortado no canto de cima |
| `prato/hamburguer_bacon_alface.png` | bacon + alface | pão + bacon, **sem alface** (`prato_bun_bacon-cozido.png`) |
| `prato/hamburguer_cru_alface_bacon.png` | carne crua + alface + bacon | pão + carne crua + alface, **sem bacon** (`prato_bun_beef-cru_lettuce.png`) |
| `prato/hamburguer_cru_ovo_bacon.png` | carne crua + ovo + bacon | pão + carne **assada** + bacon, **sem ovo** (`prato_bun_beef-cozido_bacon-cozido.png`) |
| `prato/hamburguer_completo_assado.png` | "completo" (todos os itens) | pão + carne assada + alface + ovo, **sem bacon** (`prato_bun_beef-cozido_lettuce_egg-cozido.png`) |
| `prato/prato_hamburguer_completo_cru.png` | "completo" cru | pão + bacon + alface, **a carne não aparece** (`prato_bun_bacon-cozido_lettuce.png`) + um pedaço de outro desenho cortado embaixo |

### Bacon dos pratos
A Larissa confirmou que o bacon dos pratos é **frito**. Os 4 pratos com bacon foram renomeados de `bacon-cru` para `bacon-cozido`: `prato_bacon-cozido.png`, `prato_bun_bacon-cozido.png`, `prato_bun_beef-cozido_bacon-cozido.png` e `prato_bun_bacon-cozido_lettuce.png`.

## 3. Outros problemas de arte (para pedir correção)

- **Xadrez de transparência pintado na imagem** (o jogo apaga na memória, mas o certo é exportar de novo com fundo transparente): `ingrediente_bun.png`, `caixa_bun.png`, `frigideira_beef_cru.png`, `frigideira_beef_cozido.png`, `prato_bun.png`, `prato_bun_bacon-cozido.png`, `prato_bun_beef-cru_lettuce.png`, `prato_bun_beef-cozido_bacon-cozido.png`, `prato_bun_beef-cozido_lettuce_egg-cozido.png`, `prato_bun_bacon-cozido_lettuce.png`, `prato_bacon-cozido.png`, `prato_egg-cozido.png`, `prato_bun_beef-cru.png`, `prato_bun_beef-cozido.png`, `prato_bun_egg-cozido.png`, `prato_bun_beef-cozido_lettuce.png`, `prato_bun_beef-cozido_egg-cozido.png`.
- **`prato_vazio.png`** é do lote antigo: 1536×1024, com uma sombra escura em volta, estilo um pouco diferente dos pratos novos (512×512). No jogo fica aceitável, mas um prato vazio no estilo novo combinaria melhor.
- **Estilos misturados nas frigideiras:** `frigideira_vazia`, `_egg_cozido` e `_bacon_cozido` são do lote antigo (1536×1024); as de beef são do lote novo (512×512).
