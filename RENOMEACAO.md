# Renomeação dos sprites (19/11/2026)

Cada arquivo foi aberto e renomeado pelo que **realmente aparece** nele (não pelo nome antigo).
Nenhum arquivo foi apagado. Antes do renomeio o projeto estava no commit `a888262` (é só voltar para ele se precisar).

## Convenção

- Tudo minúsculo, sem acento, sem espaço, extensão `.png`, palavras separadas por `_`.
- Nomes curtos dos ingredientes: `egg`, `bacon`, `beef`, `lettuce`, `bun`. Estados: `cru` / `cozido` (lettuce e bun não têm estado).
- Ingredientes: `ingrediente_<id>_<estado>.png` (ex.: `ingrediente_egg_cru.png`; `ingrediente_lettuce.png`).
- Caixas: `caixa_<id>.png`.
- Fogão e frigideira: `fogao_apagado.png`, `fogao_aceso.png`, `frigideira_vazia.png`, `frigideira_<id>_<estado>.png`.
- Pratos: `prato_vazio.png` e `prato_` + itens na ordem fixa **bun, beef, bacon, lettuce, egg**, com o estado colado no cozinhável por hífen. Ex.: `prato_bun_beef-cozido_egg-cozido.png`.
- Desenho repetido: número no fim (`_2`). O jogo usa o sem número.
- Fora da convenção (não pedida): personagens viraram `chef_<bicho>_<parado|andando_N>.png` e o fundo `fundo_cozinha.png`. As pastas não mudaram de nome (inclusive `Players/`), exceto 3 arquivos que mudaram de pasta (marcados com 📁).

## O jogo acha os sprites pelo nome

- **Pratos:** o jogo lê a pasta `sprites/utensilios/prato/` no início e entende cada `prato_*.png` pelo nome. Arquivo novo com nome certo entra no jogo sozinho.
- **Frigideiras:** o fogão procura `frigideira_<id>_<cru|cozido>.png`. Se não achar, usa a frigideira vazia com o ícone por cima.

## Tabela

| Nome antigo | Nome novo | O que a imagem mostra |
|---|---|---|
| `Players/raposa/raposaIdle.PNG` | `Players/raposa/chef_raposa_parado.png` | chef raposa (J1) parado |
| `Players/raposa/raposaAndar1.PNG` | `Players/raposa/chef_raposa_andando_1.png` | chef raposa (J1), quadro 1 da caminhada |
| `Players/raposa/raposaAndar2.PNG` | `Players/raposa/chef_raposa_andando_2.png` | chef raposa (J1), quadro 2 da caminhada |
| `Players/esquilo/esquiloParado.PNG` | `Players/esquilo/chef_esquilo_parado.png` | chef esquilo (J2) parado |
| `Players/esquilo/esquiloAndando1.PNG` | `Players/esquilo/chef_esquilo_andando_1.png` | chef esquilo (J2), quadro 1 da caminhada |
| `Players/esquilo/esquiloAndando2.PNG` | `Players/esquilo/chef_esquilo_andando_2.png` | chef esquilo (J2), quadro 2 da caminhada |
| `fundo/fundo.PNG` | `fundo/fundo_cozinha.png` | cenário da cozinha inteira |
| `ingredientes/ovo/ovoIcone.PNG` | `ingredientes/ovo/ingrediente_egg_cru.png` | ovo inteiro (cru) |
| `ingredientes/ovo/ovoCozidoIcone.PNG` | `ingredientes/ovo/ingrediente_egg_cozido.png` | ovo frito |
| `ingredientes/bacon/baconCruIcone.PNG` | `ingredientes/bacon/ingrediente_bacon_cru.png` | 1 fatia de bacon cru (vermelho) |
| `ingredientes/bacon/baconIcone.PNG` | `ingredientes/bacon/ingrediente_bacon_cozido.png` | 2 fatias de bacon frito (alaranjado) |
| `ingredientes/carne/carneIcone.PNG` | `ingredientes/carne/ingrediente_beef_cru.png` | hambúrguer de carne cru |
| `ingredientes/carne/carneCozidaIcone.PNG` | `ingredientes/carne/ingrediente_beef_cozido.png` | hambúrguer de carne grelhado |
| `ingredientes/alface/alfaceIcone.PNG` | `ingredientes/alface/ingrediente_lettuce.png` | folha de alface |
| `ingredientes/pao/paoHamburguer.png` | `ingredientes/pao/ingrediente_bun.png` | pão de hambúrguer |
| `ingredientes/carne/caixaCarne.PNG` | `ingredientes/carne/caixa_beef.png` | caixa com carnes |
| `ingredientes/alface/caixaAlface.PNG` | `ingredientes/alface/caixa_lettuce.png` | caixa com alface |
| `ingredientes/pao/caixaPaoHamburguer.png` | `ingredientes/pao/caixa_bun.png` | caixa com pães |
| `moveis/fogao/fogaoApagado.PNG` | `moveis/fogao/fogao_apagado.png` | fogão apagado, sem frigideira |
| `moveis/fogao/fogaoAceso.PNG` | `moveis/fogao/fogao_aceso.png` | fogão aceso, sem frigideira |
| `utensilios/frigideira/frigideiraVazia.PNG` | `utensilios/frigideira/frigideira_vazia.png` | frigideira vazia (estilo dos sprites antigos) |
| `utensilios/frigideira/frigideiraCarneCrua.png` | `utensilios/frigideira/frigideira_vazia_2.png` | frigideira VAZIA (estilo novo); o nome antigo prometia carne crua |
| `utensilios/frigideira/frigideiraCarneAssada.png` | `utensilios/frigideira/frigideira_beef_cru.png` | frigideira com carne CRUA; o nome antigo dizia assada |
| `utensilios/prato/prato_vazio.png` | `utensilios/frigideira/frigideira_beef_cozido.png` 📁 | frigideira com carne ASSADA; estava na pasta de pratos com nome de prato vazio |
| `utensilios/frigideira/frigideiraOvo.PNG` | `utensilios/frigideira/frigideira_egg_cozido.png` | frigideira com ovo frito |
| `utensilios/frigideira/frigideiraBacon.PNG` | `utensilios/frigideira/frigideira_bacon_cozido.png` | frigideira com bacon frito (alaranjado) |
| `utensilios/frigideira/frigideiraOvoBacon.PNG` | `utensilios/frigideira/frigideira_bacon-cozido_egg-cozido.png` | frigideira com bacon frito + ovo frito |
| `utensilios/prato/pratoVazio.PNG` | `utensilios/prato/prato_vazio.png` | prato vazio (estilo antigo, 1536×1024, sombra escura em volta) |
| `utensilios/prato/prato_ovo_cozido.png` | `utensilios/prato/prato_egg-cozido.png` | ovo frito no prato |
| `utensilios/prato/pratoOvo.PNG` | `utensilios/prato/prato_egg-cozido_2.png` | ovo frito no prato (estilo antigo); duplicado |
| `utensilios/prato/prato_bacon_cru.png` | `utensilios/prato/prato_bacon-cru.png` | 2 fatias de bacon vermelho (mesma cor do bacon cru) |
| `utensilios/prato/prato_carne_crua.png` | `utensilios/prato/prato_beef-cru.png` | carne crua no prato |
| `utensilios/prato/prato_hamburguer_cru.png` | `utensilios/prato/prato_beef-cru_2.png` | carne crua no prato; duplicado |
| `utensilios/prato/prato_carne_assada.png` | `utensilios/prato/prato_beef-cozido.png` | carne assada no prato |
| `utensilios/prato/prato_carne_crua_alface.png` | `utensilios/prato/prato_beef-cru_lettuce.png` | carne crua + alface |
| `utensilios/prato/prato_carne_crua_ovo_assado.png` | `utensilios/prato/prato_beef-cru_egg-cozido.png` | carne crua + ovo frito |
| `pratoOvoeBacon.PNG` | `utensilios/prato/prato_bacon-cozido_egg-cozido.png` 📁 | ovo frito + bacon frito (alaranjado); estava solto na raiz de sprites/ |
| `utensilios/prato/prato_pao_carne_crua.png` | `utensilios/prato/prato_bun_beef-cru.png` | pão + carne crua |
| `utensilios/prato/prato_pao_hamburguer_assado.png` | `utensilios/prato/prato_bun_beef-cozido.png` | pão + carne assada |
| `utensilios/prato/prato_pao_ovo.png` | `utensilios/prato/prato_bun_egg-cozido.png` | pão + ovo frito |
| `utensilios/prato/prato_hamburguer_alface.png` | `utensilios/prato/prato_bun_beef-cozido_lettuce.png` | pão + carne assada + alface |
| `utensilios/prato/prato_hamburguer_ovo_assados.png` | `utensilios/prato/prato_bun_beef-cozido_egg-cozido.png` | pão + carne assada + ovo frito |
| `utensilios/prato/hamburguer_carne_crua.png` | `utensilios/prato/prato_bun.png` | só o pão (sem carne); pedaço de outro desenho no canto |
| `utensilios/prato/hamburguer_bacon_alface.png` | `utensilios/prato/prato_bun_bacon-cru.png` | pão + bacon vermelho (sem alface) |
| `utensilios/prato/hamburguer_cru_alface_bacon.png` | `utensilios/prato/prato_bun_beef-cru_lettuce.png` | pão + carne crua + alface (sem bacon) |
| `utensilios/prato/hamburguer_cru_ovo_bacon.png` | `utensilios/prato/prato_bun_beef-cozido_bacon-cru.png` | pão + carne assada + bacon vermelho (sem ovo) |
| `utensilios/prato/hamburguer_completo_assado.png` | `utensilios/prato/prato_bun_beef-cozido_lettuce_egg-cozido.png` | pão + carne assada (camada fina) + alface + ovo frito (sem bacon) |
| `utensilios/prato/prato_hamburguer_completo_cru.png` | `utensilios/prato/prato_bun_bacon-cru_lettuce.png` | pão + bacon vermelho + alface (carne não aparece); pedaço de outro desenho embaixo |

Os `.import` (arquivos de configuração da Godot) foram movidos junto com cada imagem, para manter os mesmos UIDs das cenas.
Sobrou o `.import` órfão `sprites/pratoOvo.PNG.import` (a imagem dele já não existia antes): não apaguei; está em SPRITES_NAO_USADOS.md.

## Atualização (19/11, depois da confirmação da Larissa)

- O bacon dos pratos é frito: `prato_bacon-cru.png` → `prato_bacon-cozido.png`, `prato_bun_bacon-cru.png` → `prato_bun_bacon-cozido.png`, `prato_bun_beef-cozido_bacon-cru.png` → `prato_bun_beef-cozido_bacon-cozido.png`, `prato_bun_bacon-cru_lettuce.png` → `prato_bun_bacon-cozido_lettuce.png`.
- Apagados (não usados): `prato_egg-cozido_2.png`, `prato_beef-cru_2.png`, `frigideira_vazia_2.png`, `frigideira_bacon-cozido_egg-cozido.png` e `sprites/pratoOvo.PNG.import`.
