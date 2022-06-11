#Adam Miko³ajczyk 266865
#Asembler - zadanie 1 - Prosty kalkulator

				#na samym pocz¹tku deklarujemy nasze wszystkie dane - w naszym przypadku s¹ to wiadomoœci, które bêdziemy wyœwietlaæ u¿ytkownikowi, aby wiedzia³ co siê dzieje
				#delarujemy je w .ascii i .asciiz czyli "stringu"
.data
start: .ascii "Wybierz co chcesz zrobic:\n"
       .ascii "Dodawanie: 0\n"
       .ascii "Odejmowanie: 1\n"
       .ascii "Dzielenie: 2\n"
       .ascii "Mnozenie: 3\n"
       .ascii "Wyjdz: 4\n\n"
       .asciiz "Wybor: "
       
first_argument: .asciiz "Podaj pierwsza wartosc: "

second_argument: .asciiz "Podaj druga wartosc: "

continue_string: .ascii "\n\nCzy chcesz wykonac kolejna operacje?\n"
                 .ascii "Tak: 1\n"
                 .asciiz "Nie: 0\n"

error_string: .asciiz "Podano nieprawidlowa wartosc!\n\n"

result_string: .asciiz "Wynik dzialania: "

goodbye_string: .asciiz "Zamykanie. Do zobaczenia!"
       
newLine: .asciiz "\n"

addition_string: .asciiz "Wykonywanie dodawania!\n"
subtraction_string: .asciiz "Wykonywanie odejmowania!\n"
division_string: .asciiz "Wykonywanie dzielenia!\n"
multiplication_string: .asciiz "Wykonywanie mnozenia!\n"

.text
main:				#nasz pocz¹tkowy nag³ówek, który zbiera dane od u¿ykownika - jakie dzia³anie ma wykonaæ i na jakich wartoœciach operowaæ
	li $v0,4		#ustawiamy syscall na drukowanie stringa
	la $a0,start		#³adujemy do rejestru $a0 wiadmoœæ startow¹ zapisan¹ wczeœniej w .data
	syscall			#wykonujemy polecenie zgodne z tym co znajdue siê w $v0, czyli w naszym przypadku jest to 4, zatem drukujemy stringa
	
	li $v0,5		#ustawiamy teraz syscall aby odczyta³ kolejnego inta wpisanego przez u¿ytkownika
	syscall
	move $t0,$v0		#wpisana wartoœæ zapisana jest w rejestrze $v0, nie mo¿e ona tam byæ, bo rejestr ten jest wymagany do dalszego dzia³ania programu, zatem przypisujemy t¹ wartoœæ do rejestru tymczasowego $t0
	bltz $t0,error		#je¿eli wpisana wartoœæ jest równa 0 to skaczemy do error, gdzie wyrzucany jest b³¹d
	bgt $t0,4,error		#je¿eli wpisana wartoœæ jest wiêksza od 4 to równie¿ wyrzucamy error
	beq $t0,4,end		#a je¿eli równa siê ona 4 to zgodnie z podan¹ instrukcj¹ skaczemy do end, gdzie koñczymy program
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	li $v0,4		#je¿eli dotarliœmy tutaj to znaczy, ¿e u¿ytkownik wpisa³ poprawn¹ wartoœæ i chce wykonaæ okreœlone dzia³anie
	la $a0,first_argument	#drukujemy informacjê aby u¿ytkownik poda³ pierwszy argument
	syscall
	
	li $v0,5		#ustawiamy syscall na odczyt kolejnej wartoœci podanej przez u¿ykownika
	syscall
	move $t1,$v0		#zapisujemy podan¹ wartoœæ w rejestrze tymczasowym $t1

	li $v0,4		#teraz musimy pobraæ drugi argument, czyli robimy to samo co dla pierwszego argumentu
	la $a0,second_argument
	syscall
	
	li $v0,5
	syscall
	move $t2,$v0
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	beq $t0,0,addition	#tutaj dajemy znaæ programowi jak¹ operacjê ma wykonaæ, u¿ytkownik ju¿ to zadeklarowa³, wiêc musimy jedynie sprawdziæ której opcji równa siê wartoœæ w $t0
	beq $t0,1,subtraction	#je¿eli $t0 = 0 to wykonujemy dodawanie, $t0 = 1 - odejmowanie, $t0 = 2 - dzielenie, $t0 = 3 - mno¿enie
	beq $t0,2,division
	beq $t0,3,multiplication
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	
addition:			#nag³ówek dodawania
	jal print_choice_addition
	addu $t3,$t1,$t2	#u¿ywamy gotowej instrukcji (bez overflowu) do dodania dwóch wartoœci zapisanych w rejestrach $t1, $t2 i zapisania wyniku w rejestrze $t3
	j print_result		#przeskakujemy do nag³ówku, który wyœwietla wynik
	
subtraction:			#nag³ówek odejmowania
	jal print_choice_subtraction
	subu $t3,$t1,$t2	#u¿ywamy gotowej instrukcji do odjêcia dwóch wartoœci zapisanych w rejestrach $t1, $t2 i zapisania wyniku w rejestrze $t3
	j print_result
	
division:			#nag³ówek dzielenia
	jal print_choice_division
	beqz $t2,error		#je¿eli drugi podany argument, czyli nasz dzielnik jest równy 0 to wyrzucamy b³¹d
	
	mtc1 $t1,$f0		#aby otrzymaæ wynik z liczbami po przecinku musimy zamieniæ nasze argumenty z int'a we float'a, by to zrobiæ nale¿y przepisaæ wartoœæ przy u¿yciu rejestrów CPU do rejestru przechowuj¹cego floaty
	cvt.s.w $f0,$f0		#teraz konwertujemy zapisan¹ wartoœæ w float'a i otrzymujemy w ten sposób wartoœæ naszego pierwszego argumentu w typie float w rejestrze $f0
	mtc1 $t2,$f1		#robimy to samo z drugim argumentem
	cvt.s.w $f1,$f1
	div.s $f2,$f0,$f1	#teraz wykonujemy dzielenie liczb pojedynczej precyzji (czyli floatów)
	j print_result_float	#drukujemy wynik
	
multiplication:			#nag³ówek mno¿enia
	jal print_choice_multiplication
	mul  $t3,$t1,$t2	#u¿ywamy gotowej instrukcji
	j print_result
	
print_result:			#nag³ówek drukowania wyniku
	li $v0,4		
	la $a0,result_string	#drukujemy wczeœniej przygotowan¹ wiadomoœæ "Wynik dzialania: "
	syscall
	
	li $v0,1		#ustawiamy syscall na druk inta
	move $a0,$t3		#nadpisujemy rejestr s³u¿¹cy do druku wartoœci¹ zawart¹ w rejestrze $t3, czyli naszym wynikiem
	syscall			#i drukujemy nasz wynik
	
	j continue		#przeskakujemy do coninue
	
print_result_float:		#nag³ówek drukowania wyniku
	li $v0,4		
	la $a0,result_string	#drukujemy wczeœniej przygotowan¹ wiadomoœæ "Wynik dzialania: "
	syscall
	
	li $v0,2		#ustawiamy syscall na druk floata
	mov.s $f12,$f2  	#nadpisujemy rejestr s³u¿¹cy do druku wartoœci¹ float zawart¹ w rejestrze $f2, czyli naszym wynikiem
	syscall			#i drukujemy nasz wynik
	
	j continue		#przeskakujemy do coninue
	
print_choice_addition:		#drukowanie informacji, któr¹ operacjê aktualnie wykonuje program
	li $v0,4		
	la $a0,addition_string
	syscall
	jr $ra
print_choice_subtraction:
	li $v0,4		
	la $a0,subtraction_string
	syscall
	jr $ra
print_choice_division:
	li $v0,4		
	la $a0,division_string
	syscall
	jr $ra
print_choice_multiplication:
	li $v0,4		
	la $a0,multiplication_string
	syscall
	jr $ra
	
continue:			#kod tutaj zawarty s³u¿y do zapytania siê czy u¿ytkownik chce kontynowaæ, czy te¿ nie
	li $v0,4
	la $a0,continue_string	#drukujemy wiadomoœæ
	syscall
	
	li $v0,5		#ustawiamy syscall na wczytywanie inta i pobieramy wartoœæ od u¿ytkownika
	syscall			
	move $t0,$v0		#zapisujemy pobran¹ wartoœæ w rejestrze $t0
	
	jal line		#drukujemy 'enter'
	
	beq $t0,1,main		#je¿eli wartoœæ równa siê 1 to wracamy do nag³ówku main
	beqz $t0, end		#je¿eli równa siê 0 to skaczemy do end, czyli koñczymy program 
	j error			#je¿eli wartoœæ nie równa siê 0 lub 1 to wyœwietlamy b³¹d
	
line: 				#tutaj tworzymy nasz¹ now¹ linijkê - 'enter'
	li $v0,4
	la $a0,newLine		#³adujemy i drukujemy
	syscall
	jr $ra			#i wracamy do miejsca z którego nag³ówek ten zosta³ wywo³any komend¹ "jal"

error:				#drukujemy tutaj wiadomoœæ o b³êdzie, po czym przeskakujemy do maina
	jal line
	li $v0,4
	la $a0,error_string
	syscall
	j main
	
end:				#w tym nag³ówku drukujemy po¿egnanie i zamykamy program
	li $v0,4
	la $a0,goodbye_string   #drukujemy po¿egnanie
	syscall
	
	li $v0,10	        #³adujemy 10 do rejestru, a ona w SPIM syscalls zamyka program
	syscall
