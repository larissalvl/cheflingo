# Sprites faltando (19/11/2026)

**Nenhum.** As 107 combinações de prato possíveis têm sprite (itens bun, beef, bacon, lettuce, egg; beef, bacon e egg crus ou cozidos; de 1 a 5 itens), além do `prato_vazio.png`.

- **PRIORIDADE A (pratos de pedido): completa.** Os 25 pedidos possíveis têm sprite e todos entram no sorteio.
- **PRIORIDADE B (montagens erradas ou intermediárias): completa.** O fallback (prato vazio + ícones) quase não aparece mais; continua no código, por segurança.
- Todos os 89 pratos novos foram conferidos um por um em 19/11: itens e estados batem com o nome, 512×512, fundo transparente de verdade, sem xadrez.

## Ajuste estético opcional

Nestes 18 pratos o **bacon cru quase não aparece**: fica escondido debaixo da alface e, sobre a carne crua, tem quase a mesma cor. Não é erro (a lista ao lado do prato mostra "bacon"), mas, se der tempo, vale pedir para deixar uma ponta do bacon visível:

- `prato_bacon-cru_lettuce.png`
- `prato_bacon-cru_lettuce_egg-cozido.png`
- `prato_bacon-cru_lettuce_egg-cru.png`
- `prato_beef-cozido_bacon-cru_lettuce.png`
- `prato_beef-cozido_bacon-cru_lettuce_egg-cozido.png`
- `prato_beef-cozido_bacon-cru_lettuce_egg-cru.png`
- `prato_beef-cru_bacon-cru_lettuce.png`
- `prato_beef-cru_bacon-cru_lettuce_egg-cozido.png`
- `prato_beef-cru_bacon-cru_lettuce_egg-cru.png`
- `prato_bun_bacon-cru_lettuce.png`
- `prato_bun_bacon-cru_lettuce_egg-cozido.png`
- `prato_bun_bacon-cru_lettuce_egg-cru.png`
- `prato_bun_beef-cozido_bacon-cru_lettuce.png`
- `prato_bun_beef-cozido_bacon-cru_lettuce_egg-cozido.png`
- `prato_bun_beef-cozido_bacon-cru_lettuce_egg-cru.png`
- `prato_bun_beef-cru_bacon-cru_lettuce.png`
- `prato_bun_beef-cru_bacon-cru_lettuce_egg-cozido.png`
- `prato_bun_beef-cru_bacon-cru_lettuce_egg-cru.png`

## Opcional: fogão

| Arquivo esperado | Pasta | O que é |
|---|---|---|
| `frigideira_egg_cru.png` | `utensilios/frigideira/` | frigideira com ovo **cru** (hoje: frigideira vazia + ícone do ovo) |
| `frigideira_bacon_cru.png` | `utensilios/frigideira/` | frigideira com bacon **cru** (hoje: frigideira vazia + ícone do bacon) |

Entram sozinhas pelo nome.

## Todos os pratos (107)

| Itens | Arquivo | Conteúdo | Pode sair como pedido? |
|---|---|---|---|
| 1 | `prato_bacon-cozido.png` | bacon (cozido) | não |
| 1 | `prato_bacon-cru.png` | bacon (cru) | não |
| 1 | `prato_beef-cozido.png` | beef patty (cozido) | não |
| 1 | `prato_beef-cru.png` | beef patty (cru) | não |
| 1 | `prato_bun.png` | bun | não |
| 1 | `prato_egg-cozido.png` | egg (cozido) | não |
| 1 | `prato_egg-cru.png` | egg (cru) | não |
| 1 | `prato_lettuce.png` | lettuce | não |
| 2 | `prato_bacon-cozido_egg-cozido.png` | bacon (cozido) + egg (cozido) | sim |
| 2 | `prato_bacon-cozido_egg-cru.png` | bacon (cozido) + egg (cru) | não |
| 2 | `prato_bacon-cozido_lettuce.png` | bacon (cozido) + lettuce | sim |
| 2 | `prato_bacon-cru_egg-cozido.png` | bacon (cru) + egg (cozido) | não |
| 2 | `prato_bacon-cru_egg-cru.png` | bacon (cru) + egg (cru) | não |
| 2 | `prato_bacon-cru_lettuce.png` | bacon (cru) + lettuce | não |
| 2 | `prato_beef-cozido_bacon-cozido.png` | beef patty (cozido) + bacon (cozido) | sim |
| 2 | `prato_beef-cozido_bacon-cru.png` | beef patty (cozido) + bacon (cru) | não |
| 2 | `prato_beef-cozido_egg-cozido.png` | beef patty (cozido) + egg (cozido) | sim |
| 2 | `prato_beef-cozido_egg-cru.png` | beef patty (cozido) + egg (cru) | não |
| 2 | `prato_beef-cozido_lettuce.png` | beef patty (cozido) + lettuce | sim |
| 2 | `prato_beef-cru_bacon-cozido.png` | beef patty (cru) + bacon (cozido) | não |
| 2 | `prato_beef-cru_bacon-cru.png` | beef patty (cru) + bacon (cru) | não |
| 2 | `prato_beef-cru_egg-cozido.png` | beef patty (cru) + egg (cozido) | não |
| 2 | `prato_beef-cru_egg-cru.png` | beef patty (cru) + egg (cru) | não |
| 2 | `prato_beef-cru_lettuce.png` | beef patty (cru) + lettuce | não |
| 2 | `prato_bun_bacon-cozido.png` | bun + bacon (cozido) | sim |
| 2 | `prato_bun_bacon-cru.png` | bun + bacon (cru) | não |
| 2 | `prato_bun_beef-cozido.png` | bun + beef patty (cozido) | sim |
| 2 | `prato_bun_beef-cru.png` | bun + beef patty (cru) | não |
| 2 | `prato_bun_egg-cozido.png` | bun + egg (cozido) | sim |
| 2 | `prato_bun_egg-cru.png` | bun + egg (cru) | não |
| 2 | `prato_bun_lettuce.png` | bun + lettuce | sim |
| 2 | `prato_lettuce_egg-cozido.png` | lettuce + egg (cozido) | sim |
| 2 | `prato_lettuce_egg-cru.png` | lettuce + egg (cru) | não |
| 3 | `prato_bacon-cozido_lettuce_egg-cozido.png` | bacon (cozido) + lettuce + egg (cozido) | sim |
| 3 | `prato_bacon-cozido_lettuce_egg-cru.png` | bacon (cozido) + lettuce + egg (cru) | não |
| 3 | `prato_bacon-cru_lettuce_egg-cozido.png` | bacon (cru) + lettuce + egg (cozido) | não |
| 3 | `prato_bacon-cru_lettuce_egg-cru.png` | bacon (cru) + lettuce + egg (cru) | não |
| 3 | `prato_beef-cozido_bacon-cozido_egg-cozido.png` | beef patty (cozido) + bacon (cozido) + egg (cozido) | sim |
| 3 | `prato_beef-cozido_bacon-cozido_egg-cru.png` | beef patty (cozido) + bacon (cozido) + egg (cru) | não |
| 3 | `prato_beef-cozido_bacon-cozido_lettuce.png` | beef patty (cozido) + bacon (cozido) + lettuce | sim |
| 3 | `prato_beef-cozido_bacon-cru_egg-cozido.png` | beef patty (cozido) + bacon (cru) + egg (cozido) | não |
| 3 | `prato_beef-cozido_bacon-cru_egg-cru.png` | beef patty (cozido) + bacon (cru) + egg (cru) | não |
| 3 | `prato_beef-cozido_bacon-cru_lettuce.png` | beef patty (cozido) + bacon (cru) + lettuce | não |
| 3 | `prato_beef-cozido_lettuce_egg-cozido.png` | beef patty (cozido) + lettuce + egg (cozido) | sim |
| 3 | `prato_beef-cozido_lettuce_egg-cru.png` | beef patty (cozido) + lettuce + egg (cru) | não |
| 3 | `prato_beef-cru_bacon-cozido_egg-cozido.png` | beef patty (cru) + bacon (cozido) + egg (cozido) | não |
| 3 | `prato_beef-cru_bacon-cozido_egg-cru.png` | beef patty (cru) + bacon (cozido) + egg (cru) | não |
| 3 | `prato_beef-cru_bacon-cozido_lettuce.png` | beef patty (cru) + bacon (cozido) + lettuce | não |
| 3 | `prato_beef-cru_bacon-cru_egg-cozido.png` | beef patty (cru) + bacon (cru) + egg (cozido) | não |
| 3 | `prato_beef-cru_bacon-cru_egg-cru.png` | beef patty (cru) + bacon (cru) + egg (cru) | não |
| 3 | `prato_beef-cru_bacon-cru_lettuce.png` | beef patty (cru) + bacon (cru) + lettuce | não |
| 3 | `prato_beef-cru_lettuce_egg-cozido.png` | beef patty (cru) + lettuce + egg (cozido) | não |
| 3 | `prato_beef-cru_lettuce_egg-cru.png` | beef patty (cru) + lettuce + egg (cru) | não |
| 3 | `prato_bun_bacon-cozido_egg-cozido.png` | bun + bacon (cozido) + egg (cozido) | sim |
| 3 | `prato_bun_bacon-cozido_egg-cru.png` | bun + bacon (cozido) + egg (cru) | não |
| 3 | `prato_bun_bacon-cozido_lettuce.png` | bun + bacon (cozido) + lettuce | sim |
| 3 | `prato_bun_bacon-cru_egg-cozido.png` | bun + bacon (cru) + egg (cozido) | não |
| 3 | `prato_bun_bacon-cru_egg-cru.png` | bun + bacon (cru) + egg (cru) | não |
| 3 | `prato_bun_bacon-cru_lettuce.png` | bun + bacon (cru) + lettuce | não |
| 3 | `prato_bun_beef-cozido_bacon-cozido.png` | bun + beef patty (cozido) + bacon (cozido) | sim |
| 3 | `prato_bun_beef-cozido_bacon-cru.png` | bun + beef patty (cozido) + bacon (cru) | não |
| 3 | `prato_bun_beef-cozido_egg-cozido.png` | bun + beef patty (cozido) + egg (cozido) | sim |
| 3 | `prato_bun_beef-cozido_egg-cru.png` | bun + beef patty (cozido) + egg (cru) | não |
| 3 | `prato_bun_beef-cozido_lettuce.png` | bun + beef patty (cozido) + lettuce | sim |
| 3 | `prato_bun_beef-cru_bacon-cozido.png` | bun + beef patty (cru) + bacon (cozido) | não |
| 3 | `prato_bun_beef-cru_bacon-cru.png` | bun + beef patty (cru) + bacon (cru) | não |
| 3 | `prato_bun_beef-cru_egg-cozido.png` | bun + beef patty (cru) + egg (cozido) | não |
| 3 | `prato_bun_beef-cru_egg-cru.png` | bun + beef patty (cru) + egg (cru) | não |
| 3 | `prato_bun_beef-cru_lettuce.png` | bun + beef patty (cru) + lettuce | não |
| 3 | `prato_bun_lettuce_egg-cozido.png` | bun + lettuce + egg (cozido) | sim |
| 3 | `prato_bun_lettuce_egg-cru.png` | bun + lettuce + egg (cru) | não |
| 4 | `prato_beef-cozido_bacon-cozido_lettuce_egg-cozido.png` | beef patty (cozido) + bacon (cozido) + lettuce + egg (cozido) | sim |
| 4 | `prato_beef-cozido_bacon-cozido_lettuce_egg-cru.png` | beef patty (cozido) + bacon (cozido) + lettuce + egg (cru) | não |
| 4 | `prato_beef-cozido_bacon-cru_lettuce_egg-cozido.png` | beef patty (cozido) + bacon (cru) + lettuce + egg (cozido) | não |
| 4 | `prato_beef-cozido_bacon-cru_lettuce_egg-cru.png` | beef patty (cozido) + bacon (cru) + lettuce + egg (cru) | não |
| 4 | `prato_beef-cru_bacon-cozido_lettuce_egg-cozido.png` | beef patty (cru) + bacon (cozido) + lettuce + egg (cozido) | não |
| 4 | `prato_beef-cru_bacon-cozido_lettuce_egg-cru.png` | beef patty (cru) + bacon (cozido) + lettuce + egg (cru) | não |
| 4 | `prato_beef-cru_bacon-cru_lettuce_egg-cozido.png` | beef patty (cru) + bacon (cru) + lettuce + egg (cozido) | não |
| 4 | `prato_beef-cru_bacon-cru_lettuce_egg-cru.png` | beef patty (cru) + bacon (cru) + lettuce + egg (cru) | não |
| 4 | `prato_bun_bacon-cozido_lettuce_egg-cozido.png` | bun + bacon (cozido) + lettuce + egg (cozido) | sim |
| 4 | `prato_bun_bacon-cozido_lettuce_egg-cru.png` | bun + bacon (cozido) + lettuce + egg (cru) | não |
| 4 | `prato_bun_bacon-cru_lettuce_egg-cozido.png` | bun + bacon (cru) + lettuce + egg (cozido) | não |
| 4 | `prato_bun_bacon-cru_lettuce_egg-cru.png` | bun + bacon (cru) + lettuce + egg (cru) | não |
| 4 | `prato_bun_beef-cozido_bacon-cozido_egg-cozido.png` | bun + beef patty (cozido) + bacon (cozido) + egg (cozido) | sim |
| 4 | `prato_bun_beef-cozido_bacon-cozido_egg-cru.png` | bun + beef patty (cozido) + bacon (cozido) + egg (cru) | não |
| 4 | `prato_bun_beef-cozido_bacon-cozido_lettuce.png` | bun + beef patty (cozido) + bacon (cozido) + lettuce | sim |
| 4 | `prato_bun_beef-cozido_bacon-cru_egg-cozido.png` | bun + beef patty (cozido) + bacon (cru) + egg (cozido) | não |
| 4 | `prato_bun_beef-cozido_bacon-cru_egg-cru.png` | bun + beef patty (cozido) + bacon (cru) + egg (cru) | não |
| 4 | `prato_bun_beef-cozido_bacon-cru_lettuce.png` | bun + beef patty (cozido) + bacon (cru) + lettuce | não |
| 4 | `prato_bun_beef-cozido_lettuce_egg-cozido.png` | bun + beef patty (cozido) + lettuce + egg (cozido) | sim |
| 4 | `prato_bun_beef-cozido_lettuce_egg-cru.png` | bun + beef patty (cozido) + lettuce + egg (cru) | não |
| 4 | `prato_bun_beef-cru_bacon-cozido_egg-cozido.png` | bun + beef patty (cru) + bacon (cozido) + egg (cozido) | não |
| 4 | `prato_bun_beef-cru_bacon-cozido_egg-cru.png` | bun + beef patty (cru) + bacon (cozido) + egg (cru) | não |
| 4 | `prato_bun_beef-cru_bacon-cozido_lettuce.png` | bun + beef patty (cru) + bacon (cozido) + lettuce | não |
| 4 | `prato_bun_beef-cru_bacon-cru_egg-cozido.png` | bun + beef patty (cru) + bacon (cru) + egg (cozido) | não |
| 4 | `prato_bun_beef-cru_bacon-cru_egg-cru.png` | bun + beef patty (cru) + bacon (cru) + egg (cru) | não |
| 4 | `prato_bun_beef-cru_bacon-cru_lettuce.png` | bun + beef patty (cru) + bacon (cru) + lettuce | não |
| 4 | `prato_bun_beef-cru_lettuce_egg-cozido.png` | bun + beef patty (cru) + lettuce + egg (cozido) | não |
| 4 | `prato_bun_beef-cru_lettuce_egg-cru.png` | bun + beef patty (cru) + lettuce + egg (cru) | não |
| 5 | `prato_bun_beef-cozido_bacon-cozido_lettuce_egg-cozido.png` | bun + beef patty (cozido) + bacon (cozido) + lettuce + egg (cozido) | não |
| 5 | `prato_bun_beef-cozido_bacon-cozido_lettuce_egg-cru.png` | bun + beef patty (cozido) + bacon (cozido) + lettuce + egg (cru) | não |
| 5 | `prato_bun_beef-cozido_bacon-cru_lettuce_egg-cozido.png` | bun + beef patty (cozido) + bacon (cru) + lettuce + egg (cozido) | não |
| 5 | `prato_bun_beef-cozido_bacon-cru_lettuce_egg-cru.png` | bun + beef patty (cozido) + bacon (cru) + lettuce + egg (cru) | não |
| 5 | `prato_bun_beef-cru_bacon-cozido_lettuce_egg-cozido.png` | bun + beef patty (cru) + bacon (cozido) + lettuce + egg (cozido) | não |
| 5 | `prato_bun_beef-cru_bacon-cozido_lettuce_egg-cru.png` | bun + beef patty (cru) + bacon (cozido) + lettuce + egg (cru) | não |
| 5 | `prato_bun_beef-cru_bacon-cru_lettuce_egg-cozido.png` | bun + beef patty (cru) + bacon (cru) + lettuce + egg (cozido) | não |
| 5 | `prato_bun_beef-cru_bacon-cru_lettuce_egg-cru.png` | bun + beef patty (cru) + bacon (cru) + lettuce + egg (cru) | não |
