<h1 align="center">
    <img alt="Lig4 Logo" src="./imagens/logo_lig4.png" />
</h1>
<p align="center">Implementação do jogo Lig4 em Assembly RISC-V.</p>

* [Sobre o Projeto](#sobre-o-projeto)
* [Execução](#execução)
    * [Usando o FPGRARS](#usando-o-fpgrars)
    * [Usando o RARS](#usando-o-rars)
    * [Controles e Como Jogar](#controles-e-como-jogar)
* [Funcionalidades](#funcionalidades)


--- 

## Sobre o projeto

O projeto consiste em uma recriação do clássico jogo de tabuleiro Lig4 ([Connect4](https://en.wikipedia.org/wiki/Connect_Four)) utilizando como base a ISA RV32IMF do Assembly [RISC-V](https://riscv.org/). O jogo e sua versão alternativa foram desenvolvidos como parte dos laboratórios da discplina de Organização e Arquitetura de Computadores (OAC) ofertada pela [Universidade de Brasília](https://www.unb.br/) durante o semestre 2022/2.

---

## Execução

Para executar o jogo é recomendado utilizar a ferramenta [RARS](https://github.com/TheThirdOne/rars) ou o [FPGRARS](https://github.com/LeoRiether/FPGRARS). 

### Usando o FPGRARS

Baixe o executável da última versão ou utilize o FPGRARS contido no repositório, e execute o arquivo `Lig4.s` através do comando `./fpgrars Lig4.s` no terminal ou arrastando o `.s` no executável.

### Usando o RARS

Use o `Rars15_Custom2.jar` contido no repositório, abra o arquivo `Lig4.s`, na barra de menu superior clique em "Run" e depois selecione a opção "Assemble" para montar o programa (ou aperte F3).

Em seguida, na barra de menu superior clique em "Tools" e selecione as opções "Bitmap Display" e "Keyboard and Display MMIO Simulator", conecte ambas ao programa clicando em "Connect to Program".

Por fim, na opção "Run" clique em "Go" para executar o jogo (ou aperte F5). O jogo será renderizado na janela da ferramenta "Bitmap Display" e todos os inputs do teclado devem ser digitados na parte inferior da janela do "Keyboard and Display MMIO Simulator".


### Controles e Como Jogar

Nos menus use `w` ou `s` para movimentar entre as opções e `ENTER(↵)` para selecionar uma. 

No tabuleiro use `a` ou `d` para escolher uma coluna e `ENTER(↵)` para inserir a peça. Com `p` é possível terminar a partida e voltar para o menu inicial.

## Funcionalidades    

