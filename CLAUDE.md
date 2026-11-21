# COZINHA MALUCA (Godot 4.7.2, GDScript)

- **Entrega: sex 27/11/2026** (data oficial ainda a confirmar).
- **Feature freeze: seg 23/11 (D8), fim do dia.** MVP completo; depois disso, nada novo, só correção.
- **Ordem de corte do MVP** (se faltar tempo): 1º polimento/sons, 2º o 3º cliente, 3º a 5ª receita.

## O que falta (em ordem de prioridade)
- [x] Telas: inicial ("Jogar"), vitória com estrelas e game over ("Jogar de novo" e "Menu"), navegáveis por teclado e joystick/SW, com foco visível. "Jogar de novo" recarrega a cozinha do zero.
- [x] **Joysticks pelo cabo USB, 1 ESP32 com os 2 joysticks:**
  - [x] firmware `firmware/joysticks/joysticks.ino` (compila) e ponte `tools/serial_to_udp.py` + `tools/iniciar_joysticks.bat` (testada com ESP32 simulado: J1, J2, botão, reconexão)
  - [x] montar o J2 no mesmo ESP32, gravar o firmware novo e testar os dois chefs juntos pelo cabo
- [ ] Teste com os 2 joysticks reais: zona morta, latência, chef andando sozinho quando o joystick está tocado no boot (agora dá para recalibrar segurando o botão 2 s).
- [ ] Antes da entrega:
  - [ ] remover as teclas de debug (7, 8, 9, F1–F3) em `scripts/kitchen.gd`
  - [ ] balancear o tempo (90 s para 3 pedidos)
  - [ ] exportar a build
  - [ ] atualizar o README
  - [ ] roteiro da apresentação
- [ ] Teste com pessoas (ideal: criança de 8 a 10 anos) e teste no PC/local da apresentação (Python + `pip install pyserial`, driver USB do ESP32, cabo de dados, porta USB livre).

## Contexto
Trabalho da faculdade (Integração com ESP32, Unifor) da Larissa (programação) e uma colega (arte). Público: crianças de 8 a 10 anos. Objetivo educativo: aprender vocabulário de inglês associando o desenho ao nome do ingrediente. Sem matemática, sem quiz entediante.

## Regras do jogo
- 2 jogadores cooperativos na mesma cozinha (estilo Overcooked).
- UMA fase de 90 s; relógio no topo, centralizado, formato 01:30, vermelho nos últimos 15 s.
- 3 pedidos, um de cada vez (o próximo só aparece depois do atual entregue certo). Pedido 1 com 2 itens, pedido 2 com 3, pedido 3 com 3 ou 4. Cada ingrediente uma vez, sem quantidades. Sorteados no início, sem repetir combinação.
- Sem paciência de cliente e sem nome de cliente: a pressão é só o relógio.
- Fluxo: pegar na caixa → cozinhar no fogão (egg, bacon, beef patty) → montar no prato → entregar no balcão. Lettuce e bun não cozinham.
- Vitória: 3 pedidos certos antes do relógio zerar; 1 a 3 estrelas pelo tempo restante (3 com 45 s ou mais, 2 com 20 s ou mais). Game over: relógio chega a 0.
- Entrega errada: dica em português por alguns segundos, o pedido continua. A dica NUNCA aparece antes do erro.
- Menu de pedidos (canto superior esquerdo): só o pedido atual, "Pedido N", uma linha por ingrediente com ícone (cozinháveis aparecem cozidos) e nome em inglês; ✔ rápido ao entregar certo.
- Telas (`scenes/ui/screens.tscn`): início → jogo → vitória/game over → "Jogar de novo" (`GameState.restart_game()`, recarrega a cena) ou "Menu" (`GameState.go_to_menu()`).

## Ingredientes, pratos e fogão
- 5 ingredientes em `scripts/ingredients.gd`: egg, bacon, beef patty (cru → cozido), lettuce, bun. Caixas de egg e bacon fazem parte do fundo (na ilha, com alcance `reach_size`/`reach_offset` para baixo); beef patty, lettuce e bun têm sprite de caixa na bancada da direita.
- Pratos: `scripts/plates.gd` lê `sprites/utensilios/prato/` e entende cada arquivo pelo nome. As 107 combinações têm sprite. Ao lado do prato fica a lista dos itens (ícone + nome em inglês). O visual não muda a validação (ids iguais ao pedido E cozinháveis cozidos). O sorteio só usa pedidos com sprite.
- 2 fogões (`Stove` em x=465 e `Stove2` em x=538, lado a lado na bancada de cima; a CounterTop4 foi para o x=1357, no lugar do quadrado do fundo), instâncias da mesma `stove.tscn`, cada um com estado próprio. Achar fogões pelo grupo `Stove.GROUP` ("stoves"), nunca por caminho fixo.
- Fogão: frigideira sempre visível; vazia → com item cru (fogo aceso, 4 s, barra) → com item cozido (fogo apagado, selo verde) → vazia ao pegar. Usa `frigideira_<id>_<estado>.png` se existir; senão, frigideira vazia + ícone.

## Arte e interface
- Interface (relógio, menu, botões, telas) só com nós de UI do Godot, sem sprites.
- Sem sprite: placeholder (retângulo colorido com o nome do arquivo esperado).
- Arquivos de arte só são renomeados/apagados com autorização da Larissa.
- Convenção de nomes em `sprites/`: minúsculas, sem acento/espaço, `.png`, separador `_`. Nomes curtos: egg, bacon, beef, lettuce, bun; estados cru/cozido.
  - `ingrediente_<id>_<estado>.png` (lettuce/bun sem estado), `caixa_<id>.png`, `fogao_apagado.png`, `fogao_aceso.png`, `frigideira_vazia.png`, `frigideira_<id>_<estado>.png`.
  - `prato_vazio.png`; `prato_` + itens na ordem fixa bun, beef, bacon, lettuce, egg, cozinhável com `-cru`/`-cozido` (ex.: `prato_bun_beef-cozido_egg-cozido.png`).
- Alguns PNGs têm xadrez de transparência pintado: `Ingredients.cropped()` apaga na memória. Sempre carregar sprites de itens/pratos/caixas/frigideiras por ele.
- Estações sobre a arte do fundo (bancadas, entregas, caixas de egg/bacon) não mostram o retângulo colorido (`show_rect = false`).

## Hardware e integração
- Materiais permitidos (SOMENTE estes): 2 ESP32, 2 joysticks HW-504, protoboard e jumpers (+ o cabo USB). Sem power bank.
- **Decisão (19/11): comunicação pelo cabo USB, não por Wi-Fi.** O ESP32 precisa do cabo no PC para ter energia, então os dados vão pelo mesmo cabo. A disciplina não exige sem fio.
- **1 ESP32 com os 2 joysticks** (o segundo ESP32 fica de reserva). Joystick move o chef; botão SW faz a ação e aperta os botões das telas.
- Pinos (3V3 e GND no trilho da protoboard; SW com INPUT_PULLUP): J1 VRx=34, VRy=35, SW=32; J2 VRx=36 (VP), VRy=39 (VN), SW=33. Se a placa não tiver VP/VN: J2 em 25/26/27 (sem Wi-Fi, ADC2 funciona).
- Firmware `firmware/joysticks/joysticks.ino`: calibra os dois centros no boot, zona morta de 10%, imprime no Serial (115200) `J1,x,y,sw` e `J2,x,y,sw` a 50 Hz; linhas com `#` são diagnóstico. Segurar o botão de um joystick por 2 s e soltar recalibra aquele joystick. Calibração inválida (centro grudado em 0/4095 ou ruído > 400) → aquele joystick manda 0,0 e recalibra sozinho a cada 3 s. `DEBUG_RAW = true` no topo imprime `# RAW ...` (bruto 0–4095 + ruído) sem mudar as linhas J1/J2. Leituras com média de 8 amostras.
- PC: `tools/serial_to_udp.py` (pyserial) acha a porta do ESP32, repassa as linhas válidas por UDP para 127.0.0.1:4210 e reconecta se o cabo sair. `tools/iniciar_joysticks.bat` roda o script. O Serial Monitor da Arduino IDE precisa estar fechado (a porta só aceita um programa).
- Um único autoload `InputManager` (escuta UDP 4210) esconde se o comando vem do teclado ou do ESP32; o resto do jogo NUNCA sabe a diferença. Sem pacote por 0,5 s → volta para o teclado. Teclado sempre funciona como reserva: J1 = WASD + E; J2 = setas + Enter.
- Legado (não usado): `firmware/j1/` (1 joystick por Wi-Fi/UDP) e `firmware/joystick_serial/` (teste do D1). `tools/fake_joystick.py` simula um ESP32 por UDP para testar sem hardware.
- Lições: joystick tocado no boot → calibração errada e chef andando sozinho (recalibrar com o botão 2 s ou reiniciar o ESP32 com os joysticks soltos). Abrir a porta serial reinicia o ESP32 (ele recalibra). J2 oscilando de -1 a 1 (ou travado em 4095 = nan) era o trilho da protoboard cortado no meio: ligar 3V3/GND dos dois joysticks na mesma metade do trilho ou fazer ponte com jumper.
- Avisar ANTES de qualquer risco de hardware (cabo só de carga, driver USB, mau contato, ruído) e já trazer o plano B (teclado).

## Como trabalhar
- A Larissa é iniciante em Godot. Seja direto e execute. Termo técnico novo: definição de uma linha.
- Pergunte só se depender de algo físico, decisão de design com impacto ou algo fora do escopo.
- Código completo e testável, nunca trechos soltos.
- Ao final de cada etapa: o que mudou (arquivos), como testar e o que a Larissa precisa fazer com as mãos.
- Se algo ficar ambicioso demais para o prazo, avise e proponha uma versão menor.
- Marque [x] só o que estiver feito e testado (ou que a Larissa confirmar). Avise se estivermos atrasadas.
- Antes de commitar, revisar a lista completa de arquivos (sem cortar a saída do `git status`).
