.data
board:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0

instruction:    	.ascii "Witaj w grze Tic Tac Toe!\nPrzestrzegaj nastepujacych regul:\n"
			.ascii "1. Ruch wykonujesz podajac pole, które chcesz zajac.\n2. Numer pola podajesz wedle nastepujacego ukladu:\n"
			.ascii "    1 | 2 | 3\n   ---+---+---\n    4 | 5 | 6\n   ---+---+---\n    7 | 8 | 9\n"
			.ascii "3. Gdy dane miejsce bedzie juz zajete zostaniesz poproszony o ponowny wybor.\n"
			.asciiz "Powodzenia!\n\n"
gamemodeMsg:		.asciiz "Wybierz tryb gry:\n1. Gra z komputerem.\n2. Gra z drugim graczem.\n> "
roundsMsg:		.asciiz "Ile rund chcesz zagrac? <1 - 5>\n> "
roundMsg:		.asciiz "Runda "
score1:			.asciiz "Wynik - "
score2:			.asciiz ":"
playerTurn:   		.asciiz "Twój ruch: "
player1Turn:		.asciiz "Ruch gracza 1: "
player2Turn:		.asciiz "Ruch gracza 2: "
computerTurn:		.asciiz "Ruch komputera: "
playerWinsMsg:		.asciiz "Wygrywasz!\n\n"
computerWinsMsg:	.asciiz "Wygrywa komputer!\n\n"
player1WinsMsg:  	.asciiz "Wygrywa gracz 1!\n\n"
player2WinsMsg:  	.asciiz "Wygrywa gracz 2!\n\n"
player1WinsMatch: 	.asciiz "Cala rozgrywke wygrywa gracz 1! Gratulacje!"
player2WinsMatch: 	.asciiz "Cala rozgrywke wygrywa gracz 2! Gratulacje!"
humanWinsMatch: 	.asciiz "Wygrywasz cala rozgrywke! Gratulacje!"
computerWinsMatch: 	.asciiz "Cala rozgrywke wygrywa komputer! Przykro mi!"
tieMatch: 		.asciiz "Zremisowaliscie w calej rozgrywce! Niezle!"
tieMsg: 		.asciiz "Remis!\n\n"
newLine: 		.asciiz "\n"
space: 			.asciiz "  "

x:	.asciiz " X "
o:	.asciiz " O "
line:	.asciiz "\n---+---+---\n"
lineUp: .asciiz "|"
blank: 	.asciiz "   "

.text
main:
	la $a0, instruction
	li $v0,4
	syscall
	
gameMode:
	la $a0, gamemodeMsg
	li $v0,4
	syscall
	
	la $v0,5
	syscall
	
	bgt $v0, 2, gameMode
	blez $v0, gameMode
	
	move $t0, $v0

rounds:
	la $a0, roundsMsg
	li $v0,4
	syscall
	
	la $v0,5
	syscall
	
	bgt $v0, 5, rounds
	blez $v0, rounds
	
	move $s4, $v0
	
	beq $t0, 1, mainLoopPvE
	j mainLoopPvP

mainLoopPvE:
	addi $s5, $s5, 1

	jal printLine

	la $a0, roundMsg
	li $v0,4
	syscall

	move $a0, $s5
	li $v0, 1
	syscall

	jal printLine

	jal gameplayPvE
	
	li $a0, 500
	li $v0, 32
	syscall

	jal printScore
	
	li $a0, 500
	li $v0, 32
	syscall

	bne $s5, $s4, mainLoopPvE

	j printResultPvE

mainLoopPvP:
	addi $s5, $s5, 1

	jal printLine

	la $a0, roundMsg
	li $v0,4
	syscall

	move $a0, $s5
	li $v0, 1
	syscall

	jal printLine

	jal gameplayPvP
	
	li $a0, 500
	li $v0, 32
	syscall

	jal printScore
	
	li $a0, 500
	li $v0, 32
	syscall

	bne $s5, $s4, mainLoopPvP

	j printResultPvP

gameplayPvP:
	addi $sp, $sp, -4	# push ra onto stack
	sw $ra, 0($sp)

	jal resetBoard

	jal printBoard
	jal xMove
	jal printBoard
	jal oMove
	jal printBoard
	jal xMove
	jal printBoard
	jal oMove
	jal printBoard
	jal xMove
	jal printBoard
	jal oMove
	jal printBoard
	jal xMove
	jal printBoard
	jal oMove
	jal printBoard
	jal xMove
	jal printBoard
	
	addiu $s6, $s6, 1	# remis, dodajemy obu graczom punkty
	addiu $s7, $s7, 1
	
	la $a0, tieMsg
	li $v0, 4
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
gameplayPvE:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal resetBoard

	jal printBoard
	jal humanMove
	jal printBoard
	jal PCFirstMove
	jal printBoard
	jal humanMove
	jal printBoard
	jal PCMove
	jal printBoard
	jal humanMove
	jal printBoard
	jal PCMove
	jal printBoard
	jal humanMove
	jal printBoard
	jal PCMove
	jal printBoard
	jal humanMove
	jal printBoard
	
	addiu $s6, $s6, 1	# remis, dodajemy obu graczom punkty
	addiu $s7, $s7, 1
	
	la $a0, tieMsg
	li $v0, 4
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

printBoard2:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $t1, board

	lw $a0, 0($t1)
	li $v0, 1
	syscall

	jal printSpace

	lw $a0, 4($t1)
	li $v0, 1
	syscall

	jal printSpace

	lw $a0, 8($t1)
	li $v0, 1
	syscall

	jal printLine

	lw $a0, 12($t1)
	li $v0, 1
	syscall

	jal printSpace
	
	lw $a0, 16($t1)
	li $v0, 1
	syscall

	jal printSpace

	lw $a0, 20($t1)
	li $v0, 1
	syscall

	jal printLine
	
	lw $a0, 24($t1)
	li $v0, 1
	syscall

	jal printSpace

	lw $a0, 28($t1)
	li $v0, 1
	syscall

	jal printSpace

	lw $a0, 32($t1)
	li $v0, 1
	syscall

	jal printLine
	jal printLine

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
printBoard:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t1, board

	lw $a0, 0($t1)
	jal printField
	jal printLineUp
	lw $a0, 4($t1)
	jal printField
	jal printLineUp
	lw $a0, 8($t1)
	jal printField
	
	jal printLinee

	lw $a0, 12($t1)
	jal printField
	jal printLineUp
	lw $a0, 16($t1)
	jal printField
	jal printLineUp
	lw $a0, 20($t1)
	jal printField
	
	jal printLinee
	
	lw $a0, 24($t1)
	jal printField
	jal printLineUp
	lw $a0, 28($t1)
	jal printField
	jal printLineUp
	lw $a0, 32($t1)
	jal printField

	jal printLine
	jal printLine
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
printField:
	beqz $a0, printBlank
	beq $a0, 1, printX
	j printO
	
printBlank:
	la $a0, blank
	li $v0,4
	syscall
	
	jr $ra
printX:
	la $a0, x
	li $v0,4
	syscall
	
	jr $ra
printO:
	la $a0, o
	li $v0,4
	syscall
	
	jr $ra
printLineUp:
	la $a0, lineUp
	li $v0,4
	syscall
	
	jr $ra
printLinee:
	la $a0, line
	li $v0,4
	syscall
	
	jr $ra
	
xMove:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, player1Turn
	li $v0, 4
	syscall

	li	$v0, 5
	syscall	
	move $a1, $v0

	jal xMove1

	beq $v0, -1, xMove

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
xMove1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	bgt $a1, 9, InvalidMove
	blez $a1, InvalidMove

	la $t0, board
	mul $t1, $a1, 4
	addi $t1, $t1,-4
	add $s0, $t1, $t0
	lw $t2, 0($s0)

	bnez $t2, InvalidMove
	li $t3, 1
	sw $t3, 0($s0)

	jal win
	beq $v0, 1, player1Win

	li $v0, 0

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
oMove:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, player2Turn
	li $v0, 4
	syscall

	li	$v0, 5
	syscall
	move $a1, $v0

	jal oMove1

	beq $v0, -1, oMove

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
oMove1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	bgt $a1, 9, InvalidMove
	blez $a1, InvalidMove

	la $t0, board
	mul $t1, $a1, 4
	addi $t1, $t1,-4
	add $s0, $t1, $t0
	lw $t2, 0($s0)

	bnez $t2, InvalidMove
	li $t3, 2
	sw $t3, 0($s0)

	jal win
	beq $v0, 1, player2Win

	li $v0, 0

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
humanMove:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, playerTurn
	li $v0, 4
	syscall

	li	$v0, 5
	syscall	
	move $a1, $v0

	jal humanMove1

	beq $v0, -1, humanMove

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
humanMove1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	bgt $a1, 9, InvalidMove
	blez $a1, InvalidMove

	la $t0, board
	mul $t1, $a1, 4
	addi $t1, $t1,-4
	add $s0, $t1, $t0
	lw $t2, 0($s0)

	bnez $t2, InvalidMove
	li $t3, 1
	sw $t3, 0($s0)

	jal win
	beq $v0, 1, playerWin

	li $v0, 0

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
PCFirstMove:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a0, 800
	li $v0, 32
	syscall

	la $a0, computerTurn
	li $v0, 4
	syscall
	
	li $a1,9
	li $v0, 42
	syscall
	
	addi $a0, $a0, 1
	move $a1, $a0

	li $v0, 1
	syscall
	
	jal printLine

	jal PCMove1

	beq $v0, -1, PCFirstMove

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

PCMove:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a0, 800
	li $v0, 32
	syscall

	la $a0, computerTurn
	li $v0, 4
	syscall
	
	jal getPCMove
	
	move $a0, $a1
	li $v0, 1
	syscall
	
	jal printLine

	jal PCMove1

	beq $v0, -1, PCMove

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
PCMove1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	bgt $a1, 9, InvalidMove
	blez $a1, InvalidMove

	la $t0, board
	mul $t1, $a1, 4
	addi $t1, $t1,-4
	add $s0, $t1, $t0
	lw $t2, 0($s0)

	li $t3, 2
	sw $t3, 0($s0)

	jal win
	beq $v0, 1, computerWin

	li $v0, 0

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
getPCMove:
	addi $sp, $sp,-4
	sw $ra, 0($sp)
	
#--------------------------------Najwiêkszy priorytet ma mo¿liwoœæ wygranej komputera, zatem najpierw sprawdzamy ca³e wiersze ------------------------------------------------------
	la $t2, board
	lw $t3, 0($t2)
	lw $t4, 4($t2)
	lw $t5, 8($t2)

	li $a1, 1
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 2
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 3
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

	lw $t3, 12($t2)
	lw $t4, 16($t2)
	lw $t5, 20($t2)

	li $a1, 4
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 6
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

	lw $t3, 24($t2)
	lw $t4, 28($t2)
	lw $t5, 32($t2)

	li $a1, 7
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 8
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0 
	
	li $a1, 9
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

#-------------------------------- teraz sprawdzamy kolumny ------------------------------------------------------

	lw $t3, 0($t2)
	lw $t4, 12($t2)
	lw $t5, 24($t2)

	li $a1, 1
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 4
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 7
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

	lw $t3, 4($t2)
	lw $t4, 16($t2)
	lw $t5, 28($t2)

	li $a1, 2
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 8
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

	lw $t3, 8($t2)
	lw $t4, 20($t2)
	lw $t5, 32($t2)

	li $a1, 3
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 6
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 9
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

#-------------------------------- a na koniec skosy ------------------------------------------------------

	lw $t3, 0($t2)
	lw $t4, 16($t2)
	lw $t5, 32($t2)

	li $a1, 1
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 9
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0

	lw $t3, 8($t2)
	lw $t4, 16($t2)
	lw $t5, 24($t2)

	li $a1, 3
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove0
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove0
	
	li $a1, 7
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove0
	
#-------------------------------- Teraz szukamy mo¿liwej obrony, czyli najpierw sprawdzamy ca³e wiersze ------------------------------------------------------
	la $t2, board
	lw $t3, 0($t2)
	lw $t4, 4($t2)
	lw $t5, 8($t2)

	li $a1, 1
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 2
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove
	
	li $a1, 3
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

	lw $t3, 12($t2)
	lw $t4, 16($t2)
	lw $t5, 20($t2)

	li $a1, 4
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove
	
	li $a1, 6
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

	lw $t3, 24($t2)
	lw $t4, 28($t2)
	lw $t5, 32($t2)

	li $a1, 7
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 8
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove 
	
	li $a1, 9
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

#-------------------------------- teraz sprawdzamy kolumny ------------------------------------------------------

	lw $t3, 0($t2)
	lw $t4, 12($t2)
	lw $t5, 24($t2)

	li $a1, 1
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 4
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove
	
	li $a1, 7
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

	lw $t3, 4($t2)
	lw $t4, 16($t2)
	lw $t5, 28($t2)

	li $a1, 2
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove
	
	li $a1, 8
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

	lw $t3, 8($t2)
	lw $t4, 20($t2)
	lw $t5, 32($t2)

	li $a1, 3
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 6
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove
	
	li $a1, 9
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

#-------------------------------- a na koniec skosy ------------------------------------------------------

	lw $t3, 0($t2)
	lw $t4, 16($t2)
	lw $t5, 32($t2)

	li $a1, 1
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove 
	
	li $a1, 9
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

	lw $t3, 8($t2)
	lw $t4, 16($t2)
	lw $t5, 24($t2)

	li $a1, 3
	move $t7, $t3
	and $t6, $t4, $t5
	jal returnMove
	
	li $a1, 5
	move $t7, $t4
	and $t6, $t3, $t5
	jal returnMove
	
	li $a1, 7
	move $t7, $t5
	and $t6, $t4, $t3
	jal returnMove

#-------------------------------- jezeli ruch nie zostal wykonany to wybieramy pierwsze wolne pole, zgodnie z wartoscia pola do zajecia ------------------------------------------------------
	lw $t7, 32($t2)
	li $a1, 9
	jal returnMove1
	
	lw $t7, 8($t2)
	li $a1, 3
	jal returnMove1
	
	lw $t7, 24($t2)
	li $a1, 7
	jal returnMove1

	lw $t7, 0($t2)
	li $a1, 1
	jal returnMove1
	
	lw $t7, 16($t2)
	li $a1, 5
	jal returnMove1
	
	lw $t7, 4($t2)
	li $a1, 2
	jal returnMove1
	
	lw $t7, 12($t2)
	li $a1, 4
	jal returnMove1
	
	lw $t7, 20($t2)
	li $a1, 6
	jal returnMove1
	
	lw $t7, 28($t2)
	li $a1, 8
	jal returnMove1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
returnMove0:
	beq $t6, 2, returnMove1
	jr $ra
	
returnMove:
	bnez $t6, returnMove1
	jr $ra
	
returnMove1:
	beqz $t7, returnMove2
	jr $ra
	
returnMove2:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
InvalidMove:
	li $v0, -1

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

win:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal checkWin

	li $v0, 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

playerWin:
	jal printBoard

	la $a0, playerWinsMsg
	li $v0, 4
	syscall
	
	j playerWin1

player1Win:
	jal printBoard

	la $a0, player1WinsMsg
	li $v0, 4
	syscall
	
	j playerWin1

playerWin1:
	addi $s6, $s6, 1	# dodaj punkt graczowi 1

	addi $sp, $sp, 8
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
player2Win:
	jal printBoard

	la $a0, player2WinsMsg
	li $v0, 4
	syscall
	
	j playerWin2
	
computerWin:
	jal printBoard

	la $a0, computerWinsMsg
	li $v0, 4
	syscall
	
	j playerWin2

playerWin2:
	addi $s7, $s7, 1	# dodaj punkt graczowi 2

	addi $sp, $sp, 8
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# game over
	
checkWin:
#-------------------------------- najpierw sprawdzamy ca³e wiersze ------------------------------------------------------
	la $t2, board
	lw $t3, 0($t2)
	lw $t4, 4($t2)
	lw $t5, 8($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

	lw $t3, 12($t2)
	lw $t4, 16($t2)
	lw $t5, 20($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

	lw $t3, 24($t2)
	lw $t4, 28($t2)
	lw $t5, 32($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

#-------------------------------- teraz sprawdzamy kolumny ------------------------------------------------------

	lw $t3, 0($t2)
	lw $t4, 12($t2)
	lw $t5, 24($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

	lw $t3, 4($t2)
	lw $t4, 16($t2)
	lw $t5, 28($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

	lw $t3, 8($t2)
	lw $t4, 20($t2)
	lw $t5, 32($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

#-------------------------------- a na koniec skosy ------------------------------------------------------

	lw $t3, 0($t2)
	lw $t4, 16($t2)
	lw $t5, 32($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

	lw $t3, 8($t2)
	lw $t4, 16($t2)
	lw $t5, 24($t2)

	and $t6, $t3, $t4	# wykonujemy operacjê AND - a ^ b ^ c - jeœli s¹ takie same to wynik bêdzie ich wspóln¹ wartoœci¹ - 1 lub 2, a gdy ró¿ne zwróci siê nam wynik 0
	and $t6, $t6, $t5
	bnez $t6, winReturn

	jr $ra
	
winReturn:
	li $v0, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
resetBoard:
	addi $sp, $sp, -4
	sw $t3, 0($sp)

	la $t2, board
	li $t3, 0
	
	sw $t3, 0($t2)
	sw $t3, 4($t2)
	sw $t3, 8($t2)
	sw $t3, 12($t2)
	sw $t3, 16($t2)
	sw $t3, 20($t2)
	sw $t3, 24($t2)
	sw $t3, 28($t2)
	sw $t3, 32($t2)
	
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
printLine:
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra
	
printSpace:
	la $a0, space
	li $v0, 4
	syscall
	
	jr $ra
	
printScore:
	la $a0, score1
	li $v0, 4
	syscall
	
	move $a0, $s6
	li $v0, 1
	syscall
	
	la $a0, score2
	li $v0, 4
	syscall
	
	move $a0, $s7
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra

printResultPvP:
	bgt $s7, $s6,print2PlayerWins
	bgt $s6, $s7, print1PlayerWins
	
	j printTieMatch
	
printResultPvE:
	bgt $s7, $s6,printComputerWins
	bgt $s6, $s7, printHumanWins
	
	j printTieMatch
	
print1PlayerWins:
	la $a0, player1WinsMatch
	li $v0, 4
	syscall
	
	j exit
	
print2PlayerWins:
	la $a0, player2WinsMatch
	li $v0, 4
	syscall
	
	j exit
	
printHumanWins:
	la $a0, humanWinsMatch
	li $v0, 4
	syscall
	
	j exit

printComputerWins:
	la $a0, computerWinsMatch
	li $v0, 4
	syscall
	
	j exit
	
printTieMatch:
	la $a0, tieMatch
	li $v0, 4
	syscall
	
	j exit

exit:
	li $v0,10
	syscall