# COZINHA MALUCA (Godot 4.7.2, GDScript)
Contexto: trabalho da faculdade (Integração com ESP32, Unifor) da Larissa (programação) e uma colega (arte). Público: crianças de 8 a 10 anos. Prazo: 16/11 a 27/11/2026 (data oficial de entrega ainda a confirmar).

Objetivo educativo: aprender vocabulário de inglês associando o desenho (sprite) ao nome do ingrediente. Sem matemática, sem frações. Aprende brincando, nada de quiz entediante.

## Regras (valem sobre qualquer regra antiga)
- 2 jogadores cooperativos na mesma cozinha (estilo Overcooked).
- UMA fase de 1 min 30 s (90 s), relógio no topo, centralizado, formato 01:30, vermelho nos últimos 15 s.
- 3 pedidos no total, um de cada vez: o próximo só aparece depois que o atual for entregue certo.
- Cada pedido é uma combinação de ingredientes (ex.: egg + bacon; beef patty + lettuce; beef patty + bacon + lettuce + egg). Dificuldade crescente: pedido 1 com 2 itens, pedido 2 com 3, pedido 3 com 3 ou 4. Cada ingrediente uma vez por pedido, sem quantidades. Os 3 pedidos são sorteados no início, sem repetir combinação.
- Sem paciência individual de cliente e sem nome de cliente. A pressão é só o relógio.
- Fluxo: pegar o ingrediente na caixa, cozinhar o que precisa no fogão com frigideira (egg, bacon, beef patty; lettuce é crua), montar no prato e entregar no balcão.
- Vitória: entregar os 3 pedidos certos antes de o relógio zerar. 1 a 3 estrelas pelo tempo restante.
- Game over: relógio chega a 0 sem os 3 pedidos entregues.
- Entrega errada: dica em português por alguns segundos, o pedido continua ativo e o jogador tenta de novo. A dica em português NUNCA aparece antes do erro.
- Telas: inicial, vitória, game over (botões "Jogar" e "Jogar de novo").

## Menu de pedidos (canto superior esquerdo)
Mostra só o pedido atual. Título "Pedido 1", "Pedido 2" ou "Pedido 3". Abaixo, uma linha por ingrediente com o sprite ao lado e o nome em inglês. Sem frase de pedido e sem nome de cliente. Ao entregar certo, aparece um ✔ rápido e troca para o próximo.

## Ingredientes
5 ingredientes (dados em scripts/ingredients.gd): egg, bacon, beef patty (cozinháveis: cru → cozido no fogão), lettuce e bun (pão de hambúrguer; não cozinham, um estado só). Cada um tem caixa: egg e bacon na ilha (desenhadas no fundo); beef patty, lettuce e bun na bancada da direita (sprites de caixa).

## Pratos por combinação
- O prato (estação PLATE, na mão do chef, na bancada e no balcão de entrega) mostra o sprite que corresponde EXATAMENTE ao conjunto de itens (id + cru/cozido). Sem tabela: scripts/plates.gd lê a pasta sprites/utensilios/prato/ e entende cada arquivo pelo NOME (convenção abaixo).
- Sem sprite para a combinação: prato vazio com os ícones dos itens em cima (sem erro).
- Sempre, ao lado do prato: lista dos itens com ícone + nome em inglês.
- O visual não muda a validação: entrega certa = ids batem com o pedido E os cozinháveis estão cozidos.
- O sorteio de pedidos só usa combinações cujo prato pronto (tudo cozido) tem sprite; as outras são listadas no console. Sprite novo com nome certo entra no sorteio sozinho.
- Fogão: a frigideira fica SEMPRE visível. Livre = frigideira vazia e fogo apagado; cozinhando = frigideira com o item cru e fogo aceso; pronto = item cozido, fogo apagado, selo verde. Usa frigideira_<id>_<estado>.png se existir; senão frigideira vazia + ícone do item. Debug 7: vazia → cru → cozido → vazia (alterna beef, egg, bacon).

## Arte e interface
- Estações sobre a arte do fundo (bancadas, entrega, caixas de egg/bacon) não mostram o retângulo colorido (show_rect = false / caixas). As caixas de egg e bacon ficam no meio da ilha e usam reach_size/reach_offset (alcance maior, para baixo) para o chef alcançar pela frente.
- Menu de pedidos: cozinháveis aparecem com o ícone COZIDO.
- Use os sprites existentes em sprites/. Sem sprite, use placeholder (retângulo colorido com o nome do arquivo esperado) e liste os sprites faltantes com tamanho e formato (PNG com fundo transparente).
- Interface (relógio, menu, botões, telas) só com nós de UI do Godot (Panel, Label, ColorRect, Button), sem depender de sprites.
- Não mexer nos arquivos de arte sem autorização: problemas de nome/duplicados são listados para a Larissa resolver.
- Sprites em sprites/: ingredientes/<item>/ (ícones cru/cozido e caixas), moveis/fogao/, utensilios/frigideira/, utensilios/prato/, Players/, fundo/. Docs: SPRITES_INVENTARIO.md, RENOMEACAO.md, SPRITES_NAO_USADOS.md, SPRITES_FALTANDO.md, PROMPT_CHATGPT_PRATOS.md.
- Convenção de nomes (renomeação de 19/11, autorizada pela Larissa): minúsculas, sem acento/espaço, .png, separador "_". Nomes curtos (file_id): egg, bacon, beef, lettuce, bun; estados cru/cozido.
  - ingrediente_<id>_<estado>.png (lettuce/bun sem estado), caixa_<id>.png, fogao_apagado.png, fogao_aceso.png, frigideira_vazia.png, frigideira_<id>_<estado>.png.
  - prato_vazio.png; prato_ + itens na ordem fixa bun, beef, bacon, lettuce, egg, cozinhável com "-cru"/"-cozido" (ex.: prato_bun_beef-cozido_egg-cozido.png). Sufixo _2 = desenho repetido (vale o sem número).
- Alguns PNGs vieram com o xadrez de transparência pintado; Ingredients.cropped() apaga esse xadrez na memória ao carregar (o arquivo não muda). Use sempre Ingredients.cropped() para carregar sprites de itens, pratos, caixas e frigideiras.
- Problemas atuais da arte (lista em SPRITES_NAO_USADOS.md): vários PNGs com xadrez pintado; prato_vazio.png é do lote antigo (1536×1024).

## Organização do código
Pastas: scenes/, scripts/, sprites/ (arte), firmware/ (código do ESP32), tools/ (scripts auxiliares).

## Hardware e integração (manter as decisões existentes)
- Materiais permitidos (SOMENTE estes): 2 ESP32, 2 joysticks HW-504, protoboard e jumpers. Nenhum sensor, buzzer, display ou outro componente.
- Cada jogador tem seu ESP32 com um joystick: o joystick move o chef e o botão (SW) faz a ação (pegar, soltar, usar a estação).
- Um único autoload `InputManager` esconde se o comando vem do teclado ou do ESP32; o resto do jogo NUNCA sabe a diferença. Expõe, para cada jogador (1 e 2): vetor de movimento e botão de ação (pressionado / acabou de pressionar).
- Teclado sempre funciona como reserva: J1 = WASD + E; J2 = setas + Enter.
- Joystick em 3,3V. VRx/VRy em pinos ADC1 (GPIO 32 a 39; ADC2 não funciona junto com Wi-Fi). SW com INPUT_PULLUP. Pinos atuais do J1: VRx=34, VRy=35, SW=32.
- Calibrar o centro do joystick no boot e usar zona morta para evitar deriva.
- Cada ESP32 tem ID fixo (J1 ou J2) e envia o estado por UDP via Wi-Fi para o PC, 30 a 60 vezes por segundo.
- Pacote (texto): `J1,x,y,sw` (ex.: `J1,0.52,-0.10,1`), x e y entre -1 e 1, sw=1 quando pressionado. Porta UDP: 4210.
- Plano B: Serial por USB + script Python em tools/ que repassa para UDP local, sem mudar o código da Godot.
- Lições do hardware: o Wi-Fi funcionou pelo hotspot do celular (rede 2,4 GHz). Se o joystick estiver tocado no boot, a calibração erra e o chef anda sozinho; solução atual: reiniciar o ESP32 com o joystick solto.
- Avisar ANTES de qualquer risco de hardware (Wi-Fi bloqueado, joystick com ruído, mau contato) e já trazer o plano B.

## Como trabalhar
- A Larissa é iniciante em Godot. Seja direto e execute. Ao usar um termo técnico novo, dê uma definição de uma linha; explique o porquê só se ela pedir.
- Pergunte só se depender de algo físico, decisão de design com impacto ou algo fora do escopo.
- Código completo e testável, nunca trechos soltos.
- Ao final de cada etapa: o que mudou (arquivos), como testar e o que a Larissa precisa fazer com as mãos (ligar fios, gravar ESP32, testar com joystick).
- Se algo ficar ambicioso demais para o prazo, avise e proponha uma versão menor.
- Marque no cronograma só o que a Larissa confirmar. Avise se estivermos atrasadas.

## Cronograma
Onde o cronograma citar clientes, paciência, frações ou receitas, valem as Regras acima.
- [x] D1 Seg 16/11 — Projeto Godot criado, InputManager (teclado), 2 chefs se movendo na tela. Física: ler 1 joystick no ESP32 pelo Serial. (Concluído: J1 lido no Serial pela Larissa; pinos VRx=34, VRy=35, SW=32.)
- [x] D2 Ter 17/11 — Cozinha base: colisões, estações placeholder, pegar/soltar item. Física: firmware calibrado do J1 + envio UDP. (Concluído: testado no Godot e com o J1 real via hotspot do celular; nenhum eixo invertido.)
- [ ] D3 Qua 18/11 — Ingredientes, cozimento e montagem.
- [ ] D4 Qui 19/11 — Clientes, pedidos em inglês, paciência, entrega, pontuação, 3 receitas. Física: J2 + dois ESP32 controlando os dois chefs. MARCO: hardware integrado.
- [ ] D5 Sex 20/11 — 5 receitas, rodadas, dificuldade progressiva, feedback de erro com dica em português, tela inicial e final. Primeira leva de arte da colega.
- [ ] D6 Sáb 21/11 — Integrar arte, testar com os 2 joysticks reais, ajustar zona morta e latência.
- [ ] D7 Dom 22/11 — Folga / buffer.
- [ ] D8 Seg 23/11 — Balanceamento e correção de bugs. FEATURE FREEZE no fim do dia (MVP completo, nada novo depois).
- [ ] D9 Ter 24/11 — Arte final, sons e polimento (itens cortáveis). Testar o plano B (Serial → Python → UDP).
- [ ] D10 Qua 25/11 — Teste com pessoas (ideal: uma criança de 8-10 anos). Testar o Wi-Fi no local da apresentação.
- [ ] D11 Qui 26/11 — Correções finais, exportar a build, README e roteiro da apresentação, ensaio.
- [ ] D12 Sex 27/11 — Entrega. Só buffer de emergência.
