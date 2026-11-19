# Sprites faltando (19/11/2026, depois dos 16 pratos novos)

Combinações de prato possíveis: itens bun, beef, bacon, lettuce, egg; beef, bacon e egg podem estar crus ou cozidos; de 1 a 5 itens, cada item no máximo 1 vez.
**Total: 107 combinações. Com sprite: 34. Faltam: 73** (0 de prioridade A + 73 de prioridade B).

**Formato:** PNG 512×512 com fundo **transparente de verdade** (sem o xadrez pintado), no estilo dos pratos atuais.
**Nome:** exatamente o da coluna "Arquivo esperado" (convenção em RENOMEACAO.md). Coloque em `sprites/utensilios/prato/`.
Não precisa mexer em código: o jogo lê a pasta e o prato novo aparece sozinho; se for de prioridade A, entra no sorteio de pedidos.
Prompt pronto para o ChatGPT: `PROMPT_CHATGPT_PRATOS.md`.

## PRIORIDADE A: pratos de pedido sem sprite (0)

**Completa.** Os 25 pratos de pedido possíveis têm sprite (conferidos um por um em 19/11), e todos entram no sorteio.

## PRIORIDADE B: outras combinações (opcional, 73)

Montagens "erradas" ou intermediárias (com item cru, ou com menos itens enquanto a criança monta). **Não são obrigatórias:** o jogo mostra o prato vazio com os ícones dos itens em cima.

| Itens | Arquivo esperado | Conteúdo (item + estado) |
|---|---|---|
| 1 | `prato_bacon-cru.png` | bacon (cru) |
| 1 | `prato_egg-cru.png` | egg (cru) |
| 1 | `prato_lettuce.png` | lettuce |
| 2 | `prato_bacon-cozido_egg-cru.png` | bacon (cozido) + egg (cru) |
| 2 | `prato_bacon-cru_egg-cozido.png` | bacon (cru) + egg (cozido) |
| 2 | `prato_bacon-cru_egg-cru.png` | bacon (cru) + egg (cru) |
| 2 | `prato_bacon-cru_lettuce.png` | bacon (cru) + lettuce |
| 2 | `prato_beef-cozido_bacon-cru.png` | beef patty (cozido) + bacon (cru) |
| 2 | `prato_beef-cozido_egg-cru.png` | beef patty (cozido) + egg (cru) |
| 2 | `prato_beef-cru_bacon-cozido.png` | beef patty (cru) + bacon (cozido) |
| 2 | `prato_beef-cru_bacon-cru.png` | beef patty (cru) + bacon (cru) |
| 2 | `prato_beef-cru_egg-cru.png` | beef patty (cru) + egg (cru) |
| 2 | `prato_bun_bacon-cru.png` | bun + bacon (cru) |
| 2 | `prato_bun_egg-cru.png` | bun + egg (cru) |
| 2 | `prato_lettuce_egg-cru.png` | lettuce + egg (cru) |
| 3 | `prato_bacon-cozido_lettuce_egg-cru.png` | bacon (cozido) + lettuce + egg (cru) |
| 3 | `prato_bacon-cru_lettuce_egg-cozido.png` | bacon (cru) + lettuce + egg (cozido) |
| 3 | `prato_bacon-cru_lettuce_egg-cru.png` | bacon (cru) + lettuce + egg (cru) |
| 3 | `prato_beef-cozido_bacon-cozido_egg-cru.png` | beef patty (cozido) + bacon (cozido) + egg (cru) |
| 3 | `prato_beef-cozido_bacon-cru_egg-cozido.png` | beef patty (cozido) + bacon (cru) + egg (cozido) |
| 3 | `prato_beef-cozido_bacon-cru_egg-cru.png` | beef patty (cozido) + bacon (cru) + egg (cru) |
| 3 | `prato_beef-cozido_bacon-cru_lettuce.png` | beef patty (cozido) + bacon (cru) + lettuce |
| 3 | `prato_beef-cozido_lettuce_egg-cru.png` | beef patty (cozido) + lettuce + egg (cru) |
| 3 | `prato_beef-cru_bacon-cozido_egg-cozido.png` | beef patty (cru) + bacon (cozido) + egg (cozido) |
| 3 | `prato_beef-cru_bacon-cozido_egg-cru.png` | beef patty (cru) + bacon (cozido) + egg (cru) |
| 3 | `prato_beef-cru_bacon-cozido_lettuce.png` | beef patty (cru) + bacon (cozido) + lettuce |
| 3 | `prato_beef-cru_bacon-cru_egg-cozido.png` | beef patty (cru) + bacon (cru) + egg (cozido) |
| 3 | `prato_beef-cru_bacon-cru_egg-cru.png` | beef patty (cru) + bacon (cru) + egg (cru) |
| 3 | `prato_beef-cru_bacon-cru_lettuce.png` | beef patty (cru) + bacon (cru) + lettuce |
| 3 | `prato_beef-cru_lettuce_egg-cozido.png` | beef patty (cru) + lettuce + egg (cozido) |
| 3 | `prato_beef-cru_lettuce_egg-cru.png` | beef patty (cru) + lettuce + egg (cru) |
| 3 | `prato_bun_bacon-cozido_egg-cru.png` | bun + bacon (cozido) + egg (cru) |
| 3 | `prato_bun_bacon-cru_egg-cozido.png` | bun + bacon (cru) + egg (cozido) |
| 3 | `prato_bun_bacon-cru_egg-cru.png` | bun + bacon (cru) + egg (cru) |
| 3 | `prato_bun_bacon-cru_lettuce.png` | bun + bacon (cru) + lettuce |
| 3 | `prato_bun_beef-cozido_bacon-cru.png` | bun + beef patty (cozido) + bacon (cru) |
| 3 | `prato_bun_beef-cozido_egg-cru.png` | bun + beef patty (cozido) + egg (cru) |
| 3 | `prato_bun_beef-cru_bacon-cozido.png` | bun + beef patty (cru) + bacon (cozido) |
| 3 | `prato_bun_beef-cru_bacon-cru.png` | bun + beef patty (cru) + bacon (cru) |
| 3 | `prato_bun_beef-cru_egg-cozido.png` | bun + beef patty (cru) + egg (cozido) |
| 3 | `prato_bun_beef-cru_egg-cru.png` | bun + beef patty (cru) + egg (cru) |
| 3 | `prato_bun_lettuce_egg-cru.png` | bun + lettuce + egg (cru) |
| 4 | `prato_beef-cozido_bacon-cozido_lettuce_egg-cru.png` | beef patty (cozido) + bacon (cozido) + lettuce + egg (cru) |
| 4 | `prato_beef-cozido_bacon-cru_lettuce_egg-cozido.png` | beef patty (cozido) + bacon (cru) + lettuce + egg (cozido) |
| 4 | `prato_beef-cozido_bacon-cru_lettuce_egg-cru.png` | beef patty (cozido) + bacon (cru) + lettuce + egg (cru) |
| 4 | `prato_beef-cru_bacon-cozido_lettuce_egg-cozido.png` | beef patty (cru) + bacon (cozido) + lettuce + egg (cozido) |
| 4 | `prato_beef-cru_bacon-cozido_lettuce_egg-cru.png` | beef patty (cru) + bacon (cozido) + lettuce + egg (cru) |
| 4 | `prato_beef-cru_bacon-cru_lettuce_egg-cozido.png` | beef patty (cru) + bacon (cru) + lettuce + egg (cozido) |
| 4 | `prato_beef-cru_bacon-cru_lettuce_egg-cru.png` | beef patty (cru) + bacon (cru) + lettuce + egg (cru) |
| 4 | `prato_bun_bacon-cozido_lettuce_egg-cru.png` | bun + bacon (cozido) + lettuce + egg (cru) |
| 4 | `prato_bun_bacon-cru_lettuce_egg-cozido.png` | bun + bacon (cru) + lettuce + egg (cozido) |
| 4 | `prato_bun_bacon-cru_lettuce_egg-cru.png` | bun + bacon (cru) + lettuce + egg (cru) |
| 4 | `prato_bun_beef-cozido_bacon-cozido_egg-cru.png` | bun + beef patty (cozido) + bacon (cozido) + egg (cru) |
| 4 | `prato_bun_beef-cozido_bacon-cru_egg-cozido.png` | bun + beef patty (cozido) + bacon (cru) + egg (cozido) |
| 4 | `prato_bun_beef-cozido_bacon-cru_egg-cru.png` | bun + beef patty (cozido) + bacon (cru) + egg (cru) |
| 4 | `prato_bun_beef-cozido_bacon-cru_lettuce.png` | bun + beef patty (cozido) + bacon (cru) + lettuce |
| 4 | `prato_bun_beef-cozido_lettuce_egg-cru.png` | bun + beef patty (cozido) + lettuce + egg (cru) |
| 4 | `prato_bun_beef-cru_bacon-cozido_egg-cozido.png` | bun + beef patty (cru) + bacon (cozido) + egg (cozido) |
| 4 | `prato_bun_beef-cru_bacon-cozido_egg-cru.png` | bun + beef patty (cru) + bacon (cozido) + egg (cru) |
| 4 | `prato_bun_beef-cru_bacon-cozido_lettuce.png` | bun + beef patty (cru) + bacon (cozido) + lettuce |
| 4 | `prato_bun_beef-cru_bacon-cru_egg-cozido.png` | bun + beef patty (cru) + bacon (cru) + egg (cozido) |
| 4 | `prato_bun_beef-cru_bacon-cru_egg-cru.png` | bun + beef patty (cru) + bacon (cru) + egg (cru) |
| 4 | `prato_bun_beef-cru_bacon-cru_lettuce.png` | bun + beef patty (cru) + bacon (cru) + lettuce |
| 4 | `prato_bun_beef-cru_lettuce_egg-cozido.png` | bun + beef patty (cru) + lettuce + egg (cozido) |
| 4 | `prato_bun_beef-cru_lettuce_egg-cru.png` | bun + beef patty (cru) + lettuce + egg (cru) |
| 5 | `prato_bun_beef-cozido_bacon-cozido_lettuce_egg-cozido.png` | bun + beef patty (cozido) + bacon (cozido) + lettuce + egg (cozido) |
| 5 | `prato_bun_beef-cozido_bacon-cozido_lettuce_egg-cru.png` | bun + beef patty (cozido) + bacon (cozido) + lettuce + egg (cru) |
| 5 | `prato_bun_beef-cozido_bacon-cru_lettuce_egg-cozido.png` | bun + beef patty (cozido) + bacon (cru) + lettuce + egg (cozido) |
| 5 | `prato_bun_beef-cozido_bacon-cru_lettuce_egg-cru.png` | bun + beef patty (cozido) + bacon (cru) + lettuce + egg (cru) |
| 5 | `prato_bun_beef-cru_bacon-cozido_lettuce_egg-cozido.png` | bun + beef patty (cru) + bacon (cozido) + lettuce + egg (cozido) |
| 5 | `prato_bun_beef-cru_bacon-cozido_lettuce_egg-cru.png` | bun + beef patty (cru) + bacon (cozido) + lettuce + egg (cru) |
| 5 | `prato_bun_beef-cru_bacon-cru_lettuce_egg-cozido.png` | bun + beef patty (cru) + bacon (cru) + lettuce + egg (cozido) |
| 5 | `prato_bun_beef-cru_bacon-cru_lettuce_egg-cru.png` | bun + beef patty (cru) + bacon (cru) + lettuce + egg (cru) |

## Já existem (34)

| Itens | Arquivo | Conteúdo | Pode sair como pedido? |
|---|---|---|---|
| 1 | `prato_bacon-cozido.png` | bacon (cozido) | não |
| 1 | `prato_beef-cozido.png` | beef patty (cozido) | não |
| 1 | `prato_beef-cru.png` | beef patty (cru) | não |
| 1 | `prato_bun.png` | bun | não |
| 1 | `prato_egg-cozido.png` | egg (cozido) | não |
| 2 | `prato_bacon-cozido_egg-cozido.png` | bacon (cozido) + egg (cozido) | sim |
| 2 | `prato_bacon-cozido_lettuce.png` | bacon (cozido) + lettuce | sim |
| 2 | `prato_beef-cozido_bacon-cozido.png` | beef patty (cozido) + bacon (cozido) | sim |
| 2 | `prato_beef-cozido_egg-cozido.png` | beef patty (cozido) + egg (cozido) | sim |
| 2 | `prato_beef-cozido_lettuce.png` | beef patty (cozido) + lettuce | sim |
| 2 | `prato_beef-cru_egg-cozido.png` | beef patty (cru) + egg (cozido) | não |
| 2 | `prato_beef-cru_lettuce.png` | beef patty (cru) + lettuce | não |
| 2 | `prato_bun_bacon-cozido.png` | bun + bacon (cozido) | sim |
| 2 | `prato_bun_beef-cozido.png` | bun + beef patty (cozido) | sim |
| 2 | `prato_bun_beef-cru.png` | bun + beef patty (cru) | não |
| 2 | `prato_bun_egg-cozido.png` | bun + egg (cozido) | sim |
| 2 | `prato_bun_lettuce.png` | bun + lettuce | sim |
| 2 | `prato_lettuce_egg-cozido.png` | lettuce + egg (cozido) | sim |
| 3 | `prato_bacon-cozido_lettuce_egg-cozido.png` | bacon (cozido) + lettuce + egg (cozido) | sim |
| 3 | `prato_beef-cozido_bacon-cozido_egg-cozido.png` | beef patty (cozido) + bacon (cozido) + egg (cozido) | sim |
| 3 | `prato_beef-cozido_bacon-cozido_lettuce.png` | beef patty (cozido) + bacon (cozido) + lettuce | sim |
| 3 | `prato_beef-cozido_lettuce_egg-cozido.png` | beef patty (cozido) + lettuce + egg (cozido) | sim |
| 3 | `prato_bun_bacon-cozido_egg-cozido.png` | bun + bacon (cozido) + egg (cozido) | sim |
| 3 | `prato_bun_bacon-cozido_lettuce.png` | bun + bacon (cozido) + lettuce | sim |
| 3 | `prato_bun_beef-cozido_bacon-cozido.png` | bun + beef patty (cozido) + bacon (cozido) | sim |
| 3 | `prato_bun_beef-cozido_egg-cozido.png` | bun + beef patty (cozido) + egg (cozido) | sim |
| 3 | `prato_bun_beef-cozido_lettuce.png` | bun + beef patty (cozido) + lettuce | sim |
| 3 | `prato_bun_beef-cru_lettuce.png` | bun + beef patty (cru) + lettuce | não |
| 3 | `prato_bun_lettuce_egg-cozido.png` | bun + lettuce + egg (cozido) | sim |
| 4 | `prato_beef-cozido_bacon-cozido_lettuce_egg-cozido.png` | beef patty (cozido) + bacon (cozido) + lettuce + egg (cozido) | sim |
| 4 | `prato_bun_bacon-cozido_lettuce_egg-cozido.png` | bun + bacon (cozido) + lettuce + egg (cozido) | sim |
| 4 | `prato_bun_beef-cozido_bacon-cozido_egg-cozido.png` | bun + beef patty (cozido) + bacon (cozido) + egg (cozido) | sim |
| 4 | `prato_bun_beef-cozido_bacon-cozido_lettuce.png` | bun + beef patty (cozido) + bacon (cozido) + lettuce | sim |
| 4 | `prato_bun_beef-cozido_lettuce_egg-cozido.png` | bun + beef patty (cozido) + lettuce + egg (cozido) | sim |

## Opcional: fogão

| Arquivo esperado | Pasta | O que é |
|---|---|---|
| `frigideira_egg_cru.png` | `utensilios/frigideira/` | frigideira com ovo **cru** (hoje: frigideira vazia + ícone do ovo) |
| `frigideira_bacon_cru.png` | `utensilios/frigideira/` | frigideira com bacon **cru** (hoje: frigideira vazia + ícone do bacon) |

Também entram sozinhas pelo nome.
