# Inventário dos sprites (19/11/2026, depois da renomeação)

Nomes antigos → novos e o que cada imagem mostra: `RENOMEACAO.md`.
Sem uso e desenhos para corrigir: `SPRITES_NAO_USADOS.md`.
O que falta: `SPRITES_FALTANDO.md` (prompt para gerar: `PROMPT_CHATGPT_PRATOS.md`).

## Por categoria

| Categoria | Arquivos (em `sprites/`) |
|---|---|
| Personagens | `Players/raposa/chef_raposa_parado.png`, `chef_raposa_andando_1.png`, `chef_raposa_andando_2.png`; `Players/esquilo/chef_esquilo_parado.png`, `chef_esquilo_andando_1.png`, `chef_esquilo_andando_2.png` |
| Cenário | `fundo/fundo_cozinha.png` |
| Ingrediente cru | `ingredientes/ovo/ingrediente_egg_cru.png`, `ingredientes/bacon/ingrediente_bacon_cru.png`, `ingredientes/carne/ingrediente_beef_cru.png` |
| Ingrediente cozido | `ingredientes/ovo/ingrediente_egg_cozido.png`, `ingredientes/bacon/ingrediente_bacon_cozido.png`, `ingredientes/carne/ingrediente_beef_cozido.png` |
| Ingrediente (um estado só) | `ingredientes/alface/ingrediente_lettuce.png`, `ingredientes/pao/ingrediente_bun.png` |
| Caixas | `ingredientes/carne/caixa_beef.png`, `ingredientes/alface/caixa_lettuce.png`, `ingredientes/pao/caixa_bun.png` (as de egg e bacon fazem parte do fundo) |
| Fogão | `moveis/fogao/fogao_apagado.png`, `moveis/fogao/fogao_aceso.png` |
| Frigideira | `utensilios/frigideira/frigideira_vazia.png`, `frigideira_beef_cru.png`, `frigideira_beef_cozido.png`, `frigideira_egg_cozido.png`, `frigideira_bacon_cozido.png` |
| Pratos | `utensilios/prato/prato_vazio.png` + 18 combinações (tabela abaixo) |

## Pratos com sprite (18 combinações)

| Arquivo | Itens | Pode sair como pedido? |
|---|---|---|
| `prato_bacon-cozido.png` | bacon (cozido) | não |
| `prato_beef-cozido.png` | beef patty (cozido) | não |
| `prato_beef-cru.png` | beef patty (cru) | não |
| `prato_bun.png` | bun | não |
| `prato_egg-cozido.png` | egg (cozido) | não |
| `prato_bacon-cozido_egg-cozido.png` | bacon (cozido) + egg (cozido) | sim |
| `prato_beef-cru_egg-cozido.png` | beef patty (cru) + egg (cozido) | não |
| `prato_beef-cru_lettuce.png` | beef patty (cru) + lettuce | não |
| `prato_bun_bacon-cozido.png` | bun + bacon (cozido) | sim |
| `prato_bun_beef-cozido.png` | bun + beef patty (cozido) | sim |
| `prato_bun_beef-cru.png` | bun + beef patty (cru) | não |
| `prato_bun_egg-cozido.png` | bun + egg (cozido) | sim |
| `prato_bun_bacon-cozido_lettuce.png` | bun + bacon (cozido) + lettuce | sim |
| `prato_bun_beef-cozido_bacon-cozido.png` | bun + beef patty (cozido) + bacon (cozido) | sim |
| `prato_bun_beef-cozido_egg-cozido.png` | bun + beef patty (cozido) + egg (cozido) | sim |
| `prato_bun_beef-cozido_lettuce.png` | bun + beef patty (cozido) + lettuce | sim |
| `prato_bun_beef-cru_lettuce.png` | bun + beef patty (cru) + lettuce | não |
| `prato_bun_beef-cozido_lettuce_egg-cozido.png` | bun + beef patty (cozido) + lettuce + egg (cozido) | sim |

Hoje o sorteio tem: pedido 1 entre 4 combinações de 2 itens; pedidos 2 e 3 entre 4 de 3 itens (e o pedido 3 também pode cair na de 4 itens). São 9 pedidos com sprite de 25 possíveis.
