# Sprites faltando

Enquanto um sprite não existe, o jogo mostra um placeholder: um retângulo colorido com o nome do arquivo esperado escrito em cima.

**Formato de todos:** PNG com fundo transparente, deixando pouca borda vazia em volta do desenho (o jogo recorta a borda sozinho, mas o arquivo fica mais leve). Use a extensão `.PNG`, igual aos arquivos que já existem.

**Quando um sprite chegar:**
1. Coloque o arquivo em `sprites/`.
2. Preencha o caminho em `scripts/ingredients.gd` (campo `sprite` ou `cooked_sprite`). Para as caixas, me avise.
3. Apague a linha correspondente aqui.

## Ingredientes

| Arquivo esperado | O que é | Tamanho sugerido |
|---|---|---|
| `carneIcone.PNG` | beef patty **cru** (hambúrguer de carne cru) | 512×512 |
| `carneCozidaIcone.PNG` | beef patty **cozido** | 512×512 |
| `ovoCozidoIcone.PNG` | egg **cozido** (ovo frito) | 512×512 |
| `baconCozidoIcone.PNG` | bacon **cozido** | 512×512 |
| `alfaceIcone.PNG` | lettuce (alface; não vai ao fogão, só tem a versão crua) | 512×512 |

## Estações

| Arquivo esperado | O que é | Tamanho sugerido |
|---|---|---|
| `caixaCarne.PNG` | caixa de beef patty (bancada da direita) | 256×256 |
| `caixaAlface.PNG` | caixa de lettuce (bancada da direita) | 256×256 |

## Já existem (não precisa desenhar)

- **Cru:** `ovoIcone.PNG` (egg) e `baconIcone.PNG` (bacon).
- **Fogão e frigideira:** `fogaoApagado.PNG`, `fogaoAceso.PNG` e `frigideiraVazia.PNG`.
- **Prato:** `pratoVazio.PNG`.
- **Existem, mas o jogo ainda não usa:** `frigideiraOvo`, `frigideiraBacon`, `frigideiraOvoBacon`, `pratoOvo`, `pratoOvoeBacon`, `pedidoOvo`, `pedidoBacon`, `pedidoOvoBacon` e `bancada`.

Observação: `baconIcone.PNG` parece bacon já frito. Ele está sendo usado como **cru**. Se a colega desenhar um bacon cru (mais rosado), ele entra no lugar, e o `baconIcone` atual pode virar o cozido.
