#Adam Miko³ajczyk 266865
#Asembler - zadanie 2 - Szyfr cezara

.data
start_msg: .ascii "Wybierz, ktora operacje chcesz wykonac:\n"
	   .ascii "- Szyfrowanie: 0\n"
           .ascii "- Odszyfrowanie: 1\n"
           .ascii "- Wyjdz: 2\n"
           .asciiz "> "
       
shift_msg: .asciiz "Podaj przesuniecie:\n>"

encryptionText_msg: .asciiz "Podaj tekst do zaszyfrowania:\n> "

decryptionText_msg: .asciiz "Podaj szyfrogram:\n> "

encryptedText_msg: .asciiz "\nTwój szyfrogram: "

decryptedText_msg: .asciiz "\nTwój odszyfrowany tekst: "

exit_msg: .asciiz "\nZamykanie. Zegnaj!"

error_msg: .asciiz "Podano nieprawidlowa wartosc!\n\n"

shiftError_msg: .asciiz "Przesuniecie nie moze wynosic 0! Sprobuj ponownie.\n\n"

continue_msg: .ascii "\n\nCzy chcesz kontynuowac?\n"
              .ascii "Tak: 1\n"
              .asciiz "Nie: 0\n> "

space: .space 20

newLine: .asciiz "\n"


.text
main:                           
	li $v0, 4
	la $a0, start_msg		    # wyswietlamy menu wyboru
	syscall

	li $v0, 5			    # pobieramy od uzytkownika inta - numer operacji
	syscall

	move $s0, $v0             	    # zapisujemy numer operacji w $s0

	beq $s0, 2, exit		    # input = 2 -> EXIT
	bltz $s0, valueError                # 0 < input <2 -> ERROR
	bgt $s0, 2, valueError

shift:
	li $v0, 4
	la $a0, shift_msg
	syscall

	li $v0, 5			    # pobieramy od uzytkownika przesuniecie i zapisujemy je w $t1
	syscall
	
	move $t1, $v0
	
	jal modShift			    # obliczamy modu³: $t1 % 26

	beqz $t1, shiftError		    # jesli wynik modulu to 0 to wyswietlamy blad
	
	beqz $s0,encryptionText		    # skaczemy do operacji ktora wybral uzytkownik
	j decryptionText
	
encryptionText:
	la $a0,encryptionText_msg
	li $v0,4
	syscall
	
	la $a0,space
	la $a1,17  			    # ile znakow maksymalnie (n+1)
	li $v0,8
	syscall
	
	la $t0,($a0) 			    # przechowujemy tekst w $t0
	
	li $v0, 4
	la $a0, encryptedText_msg
	syscall
	
 encrypt:
	lb $t3, 0($t0)  	 	    # odczytujemy pierwsza litere w bajtach
	beq $t3,10,continue	 	    # gdy dotrzemy do \n to znak ze nalezy konczyc odczyt stringa 
	beqz $t3,continue  		    # tak samo gdy kolejny charakter bedzie nullem
	beq $t3,32,printSpaceCharEncrypt    # gdy nasz odczytywany znak jest spacja to zamiast kodowac go po prostu drukujemy spacje

	li $t5,26   			    # wykonujemy nastepujace operacje aby uzyskac dana litere po przesunieciu
	sub $t3,$t3,65
	add $t3, $t3, $t1		    # (((X - 65) + shift) % 26) + 65
	div $t3,$t5
	mfhi $t3
	addi $t3,$t3,65
 
	sub $t3,$t3,90
	div $t3,$t5			    # ((X - 90) % 26) + 90
					    # te operacje sa potrzebne by przesuniecie moglo byc ujemne
	mfhi $a0
	addi $a0,$a0,90

	jal printChar			    # drukujemy char i zapetlamy ta metode az wszystko zaszyfrujemy
	j encrypt
	
decryptionText:
	la $a0,decryptionText_msg   	    # robimy to samo co dla wersji z szyfrowaniem
	li $v0,4
	syscall
 
	la $a0,space
	la $a1,17
	li $v0,8
	syscall
 
	la $t0,($a0) 		
	li $v0, 4
	la $a0, decryptedText_msg
	syscall
 
decrypt:
	lb $t3, 0($t0)  		   # wykonujemy te same operacje co dla szyfrowania, tylko zamiast dodawac przesuniecie tutaj je odejmujemy
	beq $t3,10,continue  
	beqz $t3,continue
	beq $t3,32,printSpaceCharDecrypt  	

	li $t5,26   				
	sub $t3,$t3,65
	sub $t3, $t3, $t1
	div $t3,$t5
	mfhi $t3
	addi $t3,$t3,65
 
	sub $t3,$t3,90
	div $t3,$t5
	mfhi $a0
	addi $a0,$a0,90
 
	jal printChar
	j decrypt
	
printChar:
	li $v0,11 			# drukujemy char znajdujacy sie w $a0 po zaszyfrowaniu/odszyfrowaniu
	syscall
	add $t0,$t0,1			# przesuwamy sie do nastepnej litery
	jr $ra
	
printSpaceCharEncrypt:
	move $a0, $t3
	li $v0,11 			# drukujemy char znajdujacy sie w $a0 po zaszyfrowaniu/odszyfrowaniu
	syscall
	add $t0,$t0,1
	j encrypt
	
printSpaceCharDecrypt:
	move $a0, $t3
	li $v0,11 			# drukujemy char znajdujacy sie w $a0 po zaszyfrowaniu/odszyfrowaniu
	syscall
	add $t0,$t0,1
	j decrypt
	
modShift:
	li $t0, 26                    
	div $v0, $t0
	mfhi $t1
	jr $ra

exit:
	li $v0, 4
	la $a0, exit_msg        	#drukujemy po¿egnanie
	syscall
	
	li $v0,10	       		#³adujemy 10 do rejestru, a ona w SPIM syscalls zamyka program
	syscall
  
valueError:
	li $v0, 4
	la $a0, error_msg        	#drukujemy error
	syscall
	j main
	
valueErrorPopUp:
	li $v0, 4
	la $a0, error_msg       	 #drukujemy error z powiazaniem
	syscall
	jr $ra
	
shiftError:
	li $v0, 4
	la $a0, shiftError_msg   	 #drukujemy error z zerowym przesunieciem
	syscall
	j shift
	
continue:				 #kod tutaj zawarty s³u¿y do zapytania siê czy u¿ytkownik chce kontynowaæ, czy te¿ nie
	li $v0,4
	la $a0,continue_msg		 #drukujemy wiadomoœæ
	syscall
	
	li $v0,5			 #ustawiamy syscall na wczytywanie inta i pobieramy wartoœæ od u¿ytkownika
	syscall			
	move $t0,$v0			 #zapisujemy pobran¹ wartoœæ w rejestrze $t0
	
	jal line			 #drukujemy 'enter'
	
	beq $t0,1,main			 #je¿eli wartoœæ równa siê 1 to wracamy do nag³ówku main
	beqz $t0, exit			 #je¿eli równa siê 0 to skaczemy do exit, czyli koñczymy program 
	jal valueErrorPopUp
	j continue			 #je¿eli wartoœæ nie równa siê 0 lub 1 to wyœwietlamy b³¹d
	
line: 					 #tutaj tworzymy nasz¹ now¹ linijkê - 'enter'
	li $v0,4
	la $a0,newLine			 #³adujemy i drukujemy
	syscall
	jr $ra				 #i wracamy do miejsca z którego nag³ówek ten zosta³ wywo³any komend¹ "jal"
	
