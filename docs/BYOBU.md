F9 - MENU
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-byobu-for-terminal-management-on-ubuntu-16-04

https://www.howtogeek.com/58487/how-to-easily-multitask-in-a-linux-terminal-with-byobu/

F6 - DEATACH - continue running
é só chamar byobu novamente

Você pode usar todas as teclas de atalho padrão da Tela sem uma segunda olhada. No entanto, o Byobu possui combinações de teclas mais fáceis que utilizam as teclas de função:

F2 : Crie uma nova janela
F3 : Mover para a janela anterior
F4 : Mover para a próxima janela
F5 : Atualizar perfil
F6 : desanexar desta sessão
F7 : Entre no modo de cópia / rolagem
F8 : renomear uma janela
F9 : Menu Configuração, também pode ser chamado por Ctrl + a, Ctrl + @
Como você pode ver, isso é muito mais fácil do que usar as seqüências Ctrl + a, Ctrl da tela. Se você preferir o conjunto de teclas de atalho da tela ou se elas interferem em outro programa (como o Midnight Commander), você pode alternar entre as teclas de função e as teclas de estilo da tela no menu ou pressionar a seguinte seqüência de teclas:

Ctrl + a, ctrl +!

Uma diferença ao usar o byobu é o modo de rolagem . Pressione a tecla F7 para entrar no modo de rolagem. O modo Scrollback permite navegar pela saída anterior usando comandos do tipo vi . Aqui está uma lista rápida de comandos de movimento:

h - Mova o cursor para a esquerda por um caractere

j - Mova o cursor para baixo em uma linha

k - Mova o cursor para cima uma linha

l - Mova o cursor para a direita por um caractere

0 - Mover para o início da linha atual

$ - Mover para o final da linha atual

G - Move para a linha especificada (o padrão é o final do buffer)

/ - Pesquisa para a frente

? - Pesquisa para trás

n - Move para a próxima partida, para frente ou para trás