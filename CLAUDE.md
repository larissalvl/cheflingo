# Cozinha Maluca — contexto do projeto

## Quem sou eu e como trabalhar comigo
- Quem fala com você é a Larissa (Ciência da Computação, Unifor, 2º semestre), iniciante em Godot. Ela faz o trabalho com uma colega, que cuida da arte.
- Ela precisa correr: seja direto, execute, não peça permissão para cada passo.
- Explique o porquê só se eu pedir. Ao usar um termo técnico novo, dê uma definição de uma linha.
- Entregue código COMPLETO e testável, nunca trechos soltos.
- Ao fim de cada etapa, escreva: (a) o que mudou, (b) como testar, (c) o que eu preciso fazer com as mãos (ligar fios, gravar ESP32, testar com joystick).
- Pare e me peça confirmação só quando depender de algo físico, de uma decisão de design com impacto, ou de algo fora do escopo/prazo.
- Se algo for ambicioso demais para o prazo ou fugir dos materiais, avise com franqueza e proponha uma versão menor.
- Se existir dúvida que muda o resultado, pergunte em vez de deduzir.

## O trabalho
Jogo educativo para crianças de 8 a 10 anos, feito na Godot 4.7.2 (GDScript), controlado por hardware de robótica.
- Prazo: 16/11/2026 a 27/11/2026 (12 dias). Data oficial de entrega ainda a confirmar.
- Educativo de forma sutil: a criança aprende brincando, sem quiz entediante.
- Materiais permitidos (SOMENTE estes): 2 ESP32, 2 módulos joystick HW-504, protoboard, fios jumper. Nenhum sensor, buzzer, display ou outro componente.

## O jogo: COZINHA MALUCA (estilo Overcooked, 2 jogadores cooperativos)
- Dois chefs na mesma cozinha atendem clientes malucos (ex.: um dragão que quer bolo) antes que a paciência deles acabe.
- Cada jogador tem seu ESP32 com um joystick: o joystick move o chef e o botão (SW) faz a ação (pegar, soltar, usar a estação).
- Estações: caixas de ingredientes, tigela, forno, balcão de entrega.
- Matemática escondida: as caixas entregam porções (1/4, 1/2, 1) e a receita pede uma fração ("três quartos de farinha"); os jogadores combinam porções para chegar na medida.
- Inglês escondido: pedidos e rótulos em inglês ("two eggs, please"); a tradução/dica em português só aparece DEPOIS do erro.
- MVP: 1 cozinha, 3 clientes, 5 receitas, pontuação e tela final.
- Ordem de corte se o prazo apertar: 1º polimento visual/sons, 2º o 3º cliente, 3º a 5ª receita.
- Fios touch capacitivos: fora do MVP, só se sobrar tempo.

## Arquitetura (decisões padrão)
- Um único autoload `InputManager` esconde se o comando vem do teclado ou do ESP32. O resto do jogo NUNCA sabe a diferença. Ele expõe, para cada jogador (1 e 2): vetor de movimento e botão de ação (pressionado / acabou de pressionar).
- Teclado sempre funciona como reserva: J1 = WASD + E; J2 = setas + Enter. Serve para desenvolver sem hardware e é o plano B na apresentação.
- Use formas simples (placeholders) até a arte chegar. Arte final: PNG com fundo transparente; peça à Larissa a lista de assets com tamanho e formato.
- Código organizado em pastas: scenes/, scripts/, assets/, firmware/ (código do ESP32), tools/ (scripts auxiliares).

## Hardware e comunicação (a Larissa pode mudar)
- Joystick em 3,3V. VRx/VRy em pinos ADC1 (GPIO 32 a 39; ADC2 não funciona junto com Wi-Fi). SW com INPUT_PULLUP.
- Calibrar o centro do joystick no boot e usar zona morta para evitar deriva.
- Cada ESP32 tem ID fixo (J1 ou J2) e envia o estado por UDP via Wi-Fi para o PC, 30 a 60 vezes por segundo.
- Formato do pacote (texto): `J1,x,y,sw` (ex.: `J1,0.52,-0.10,1`), x e y entre -1 e 1, sw=1 quando pressionado. Porta UDP: 4210.
- Plano B: Serial por USB + script Python em tools/ que repassa para UDP local, sem mudar o código da Godot.
- Avise ANTES de qualquer risco de hardware (Wi-Fi bloqueado, joystick com ruído, mau contato) e já traga o plano B.

## Cronograma (marque [x] ao concluir e atualize este arquivo ao fim de cada dia; avise se estivermos atrasadas)
- [x] D1 Seg 16/11 — Projeto Godot criado, InputManager (teclado), 2 chefs se movendo na tela. Física: ler 1 joystick no ESP32 pelo Serial. (Concluído: J1 lido no Serial pela Larissa; pinos VRx=34, VRy=35, SW=32.)
- [ ] D2 Ter 17/11 — Cozinha base: colisões, estações placeholder, pegar/soltar item. Física: firmware calibrado do J1 + envio UDP.
  - Software pronto e testado headless (28 checagens) + firmware `firmware/j1` compilando. Aguardando a Larissa confirmar no Godot e com o J1 real.
- [ ] D3 Qua 18/11 — Porções e frações: caixas, tigela que soma frações, receita 1 funcionando.
- [ ] D4 Qui 19/11 — Clientes, pedidos em inglês, paciência, entrega, pontuação, 3 receitas. Física: J2 + dois ESP32 controlando os dois chefs. MARCO: hardware integrado.
- [ ] D5 Sex 20/11 — 5 receitas, rodadas, dificuldade progressiva, feedback de erro com dica em português, tela inicial e final. Primeira leva de arte da colega.
- [ ] D6 Sáb 21/11 — Integrar arte, testar com os 2 joysticks reais, ajustar zona morta e latência.
- [ ] D7 Dom 22/11 — Folga / buffer.
- [ ] D8 Seg 23/11 — Balanceamento e correção de bugs. FEATURE FREEZE no fim do dia (MVP completo, nada novo depois).
- [ ] D9 Ter 24/11 — Arte final, sons e polimento (itens cortáveis). Testar o plano B (Serial → Python → UDP).
- [ ] D10 Qua 25/11 — Teste com pessoas (ideal: uma criança de 8-10 anos). Testar o Wi-Fi no local da apresentação.
- [ ] D11 Qui 26/11 — Correções finais, exportar a build, README e roteiro da apresentação, ensaio.
- [ ] D12 Sex 27/11 — Entrega. Só buffer de emergência.
