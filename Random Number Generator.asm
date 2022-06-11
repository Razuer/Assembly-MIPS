#Adam Miko³ajczyk 266865
#Asembler - zadanie 3 - Generator liczb losowych

.data
length_msg: .asciiz "Ilu znakowy ma byc ciag?\n> "
count_msg: .asciiz "Ile ciagow wygenerowac?\n> "
newLine: .asciiz "\n"
error_msg: .asciiz "Wartosc nie moze byc niedodatnia!\n\n"

.text
main:
	li $v0, 4
	la $a0, length_msg
	syscall

	li $v0, 5			    # pobieramy od uzytkownika inta - dlugosc ciagu
	syscall

	move $t0, $v0  			    # zapisujemy w $t0 podana dlugosc ciagu, bedziemy to wykorzystywac w petli 1
	blez $t0, valueError                # 0 <= input -> ERROR
	
	li $v0, 4
	la $a0, count_msg
	syscall

	li $v0, 5			    # pobieramy od uzytkownika inta - ilosc ciagow
	syscall

	move $t1, $v0  			    # zapisujemy w $t1 podana ilosc ciagu, bedziemy to wykorzystywac w petli 2
	blez $t1, valueError                # 0 <= input -> ERROR
	
	jal printLine

generateLoop:
	li $v0, 42			    # ustawiamy syscall na "random int range"
	li $a1, 10			    # ustawiawmy górn¹ granicê losowanych liczb
	syscall				    # i losujemy jedn¹ liczbê z <0, 9>

	li $v0, 1			    # drukujemy tê cyfrê
	syscall

	addiu $t3, $t3, 1
	blt $t3, $t0, generateLoop	   # pêtla 1 if(int i=0, i<length($t0), i++) - drukujemy 'length' razy losowa cyfre

	jal printLine

	li $t3, 0
	addiu $t4, $t4, 1
	blt $t4, $t1, generateLoop	   # pêtla 2 if(int i=0, i<count($t1), i++) - drukujemy 'count' razy nasz ciag

	j exit				   # po wygenerowaniu zamykamy program

exit:
	li $v0, 10
	syscall

printLine:
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra

valueError:
	li $v0, 4
	la $a0, error_msg        	  #drukujemy error
	syscall
	j main
