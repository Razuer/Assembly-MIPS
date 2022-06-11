#Adam Miko³ajczyk 266865
#Asembler - zadanie 4 - Zapis i odczyt stosu

.data
count_msg: .asciiz "Ile ciagow chcesz podac?\n> "
getString_msg: .asciiz "Podaj ciag:\n"
getStrings_msg: .asciiz "Podaj ciagi:\n"
getNextText_msg: .asciiz "> "
wordsOnStack_msg: .asciiz "\nWyrazy, ktore znajdowaly sie na stosie:\n"
error_msg: .asciiz "Wartosc musi byc z przedzialu <1, 10>!\n\n"
buffer: .space 100
newLine: .asciiz "\n"

# $t0 - ile ci¹gów (do pêtli), $t1 - podany ci¹g, $t2 - odczytany char, $t3 - liczba bajtow na stosie
# $t4 - dlugosc danego slowa, $t5 - liczba zapisanych znakow danego slowa na stosie, $t6 - znak \n

		 # >>> Stack Pointer przesuwamy zawsze o JEDEN bajt, poniewa¿ tyle wa¿y char, a to na nich operujemy! <<<

.text
getNumberOfStrings:
	la $a0, count_msg
	jal printString

	li $v0, 5			    # pobieramy od uzytkownika inta - ilosc ciagow
	syscall

	move $t0, $v0  			    # zapisujemy w $t0 podana ilosc ciagu, bedziemy to wykorzystywac w petli
	blez $t0, valueError                # input <= 0 -> ERROR
	bgt $t0, 10, valueError		    # input > 10  -> ERROR
	
	li $t6, 10			    # ten rejestr przechowuje znak \n
	
	
	beq $t0, 1, oneStringMsg	    # wyswietlamy dana wiadomosc w zaleznosci od tego jaka ilosc chcemy ich wprowadzic
	
	la $a0, getStrings_msg
	jal printString
	
getInput:
	la $a0, getNextText_msg
	jal printString

	li $v0, 8
	la $a0, buffer
	la $a1, 40
        syscall
        
        la $t1, ($a0)		# zapisujemy w $t1 podany ci¹g
        
        beq $t3, 0, saveLoop	# jezeli liczba zapisanych bajtow wynosi 0 to nie dodajemy na stos znaku \n, ktory rozdzieli wyrazy miedzy dwoma ciagami
        
        addi $sp, $sp, -1	# przesun Stack Pointer dla naszych bajtów
	addi $t3, $t3, 1	# zwiêksz zajête bajty na stosie
	sb $t6, 0($sp)		# dodaj \n do stosu
	
saveLoop:
	lb $t2,0($t1)           # odczytaj znak
	
	beq $t2, 10, saveLastWordOnStack          	 # zapisz wyraz i zakoñcz odczytywanie jezeli odczytany znak to \n
	beq $t2, 32, saveWordOnStack	        	 # zapisz wyraz na stosie jesli to spacja
	
	addi $t1, $t1, 1	# przesuwamy sie do nastepnego znaku
	addi $t4, $t4, 1	# zwiekszamy dlugosc danego wyrazu
	j saveLoop		# i odczytujemy dalej a¿ odczytamy caly wyraz

saveWordOnStack:
	beqz $t4, skipChar	# dwie spacje - skip
	bne $t5, $t4, addChar	# dodajemy od konca char
	
	addi $sp, $sp, -1	# przesuwamy stack pointer 
	addi $t3, $t3, 1	# zwiekszamy ilosc zajetych bajtow na stosie
	sb $t6, 0($sp)		# dodajemy \n, aby rozdzielic wyrazy
		
	add $t1, $t1, $t4	# przesuwamy sie do nowego wyrazu
	addi $t1, $t1, 1
		
	move $t4, $zero		# zerujemy dlugosc wyrazu
	move $t5, $zero		# zerujemy ilosc zapisanych liter na stosie
			
	j saveLoop		# i czytamy kolejny wyraz

saveLastWordOnStack:
	beqz $t4, mainLoop		# w zasadzie to samo co wy¿ej, ale zamiast szukac kolejnego wyrazu konczymy odczytywanie ciagu
	bne $t5, $t4, addCharLastWord	# dopoki ilosc zapisanych znakow nie jest rowna dlugosci slowa kontynuujemy zapis char'ów
	
	move $t4, $zero
	move $t5, $zero
	
	j mainLoop	        # idŸ sprawdzic co robimy nastepnie	
	
addChar:
	addi $sp, $sp, -1	# przesun Stack Pointer
	addi $t3, $t3, 1	# zwieksz zajete bajty na stosie
	addi $t1, $t1, -1	# zmnijesz wskaznik na litere
	lb $t2, 0($t1)		# pobieramy znak
	sb $t2, 0($sp)		# zapisujemy na stosie
	addi $t5, $t5, 1	# zwiekszamy wskaznik ile znakow juz zapisalismy
		
	j saveWordOnStack
		
addCharLastWord:
	addi $sp, $sp, -1	# to co wyzej, ale po zapisaniu wyrazu konczymy ciag
	addi $t3, $t3, 1
	addi $t1, $t1, -1	
	lb $t2, 0($t1)		
	sb $t2, 0($sp)		
	addi $t5, $t5, 1	
	
	j saveLastWordOnStack

skipChar:
	addi $t1, $t1, 1
	j saveLoop

mainLoop:
	addiu $t0, $t0, -1
	bgtz $t0, getInput		# petla, ktora x razy pobiera od uzytkownika tekst i go zapisuje na stosie
	
	la $a0, wordsOnStack_msg
	jal printString
	
	li $v0, 11		  	# ustawiamy na drukowanie char'ów
	
printLoop:
	lb $a0, 0($sp)			# pobieramy pierwszy znak
	addi $sp, $sp, 1		# przesuwamy stack pointer o ten znak
	
	syscall				# drukujemy
		
	addi $t3, $t3, -1		# aktualizujemy ilosc zajetych bajtow
	
	bnez $t3, printLoop		# jezeli ilosc bajtow nie jest rowna 0 to drukujemy dalej
	
	j exit
	
printString:
	li $v0,4
	syscall
	jr $ra
	
print_newLine:
	la $a0, newLine
	li $v0,4
	syscall
	jr $ra
	
valueError:
	la $a0, error_msg        	  #drukujemy error
	jal printString
	j getNumberOfStrings

oneStringMsg:
	la $a0, getString_msg
	li $v0, 4
	syscall
	
	j getInput
	
exit:
	li $v0, 10
	syscall
