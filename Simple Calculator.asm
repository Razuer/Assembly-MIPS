#Adam Miko�ajczyk 266865
#Asembler - zadanie 1 - Prosty kalkulator

				#na samym pocz�tku deklarujemy nasze wszystkie dane - w naszym przypadku s� to wiadomo�ci, kt�re b�dziemy wy�wietla� u�ytkownikowi, aby wiedzia� co si� dzieje
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
main:				#nasz pocz�tkowy nag��wek, kt�ry zbiera dane od u�ykownika - jakie dzia�anie ma wykona� i na jakich warto�ciach operowa�
	li $v0,4		#ustawiamy syscall na drukowanie stringa
	la $a0,start		#�adujemy do rejestru $a0 wiadmo�� startow� zapisan� wcze�niej w .data
	syscall			#wykonujemy polecenie zgodne z tym co znajdue si� w $v0, czyli w naszym przypadku jest to 4, zatem drukujemy stringa
	
	li $v0,5		#ustawiamy teraz syscall aby odczyta� kolejnego inta wpisanego przez u�ytkownika
	syscall
	move $t0,$v0		#wpisana warto�� zapisana jest w rejestrze $v0, nie mo�e ona tam by�, bo rejestr ten jest wymagany do dalszego dzia�ania programu, zatem przypisujemy t� warto�� do rejestru tymczasowego $t0
	bltz $t0,error		#je�eli wpisana warto�� jest r�wna 0 to skaczemy do error, gdzie wyrzucany jest b��d
	bgt $t0,4,error		#je�eli wpisana warto�� jest wi�ksza od 4 to r�wnie� wyrzucamy error
	beq $t0,4,end		#a je�eli r�wna si� ona 4 to zgodnie z podan� instrukcj� skaczemy do end, gdzie ko�czymy program
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	li $v0,4		#je�eli dotarli�my tutaj to znaczy, �e u�ytkownik wpisa� poprawn� warto�� i chce wykona� okre�lone dzia�anie
	la $a0,first_argument	#drukujemy informacj� aby u�ytkownik poda� pierwszy argument
	syscall
	
	li $v0,5		#ustawiamy syscall na odczyt kolejnej warto�ci podanej przez u�ykownika
	syscall
	move $t1,$v0		#zapisujemy podan� warto�� w rejestrze tymczasowym $t1

	li $v0,4		#teraz musimy pobra� drugi argument, czyli robimy to samo co dla pierwszego argumentu
	la $a0,second_argument
	syscall
	
	li $v0,5
	syscall
	move $t2,$v0
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	beq $t0,0,addition	#tutaj dajemy zna� programowi jak� operacj� ma wykona�, u�ytkownik ju� to zadeklarowa�, wi�c musimy jedynie sprawdzi� kt�rej opcji r�wna si� warto�� w $t0
	beq $t0,1,subtraction	#je�eli $t0 = 0 to wykonujemy dodawanie, $t0 = 1 - odejmowanie, $t0 = 2 - dzielenie, $t0 = 3 - mno�enie
	beq $t0,2,division
	beq $t0,3,multiplication
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	
addition:			#nag��wek dodawania
	jal print_choice_addition
	addu $t3,$t1,$t2	#u�ywamy gotowej instrukcji (bez overflowu) do dodania dw�ch warto�ci zapisanych w rejestrach $t1, $t2 i zapisania wyniku w rejestrze $t3
	j print_result		#przeskakujemy do nag��wku, kt�ry wy�wietla wynik
	
subtraction:			#nag��wek odejmowania
	jal print_choice_subtraction
	subu $t3,$t1,$t2	#u�ywamy gotowej instrukcji do odj�cia dw�ch warto�ci zapisanych w rejestrach $t1, $t2 i zapisania wyniku w rejestrze $t3
	j print_result
	
division:			#nag��wek dzielenia
	jal print_choice_division
	beqz $t2,error		#je�eli drugi podany argument, czyli nasz dzielnik jest r�wny 0 to wyrzucamy b��d
	
	mtc1 $t1,$f0		#aby otrzyma� wynik z liczbami po przecinku musimy zamieni� nasze argumenty z int'a we float'a, by to zrobi� nale�y przepisa� warto�� przy u�yciu rejestr�w CPU do rejestru przechowuj�cego floaty
	cvt.s.w $f0,$f0		#teraz konwertujemy zapisan� warto�� w float'a i otrzymujemy w ten spos�b warto�� naszego pierwszego argumentu w typie float w rejestrze $f0
	mtc1 $t2,$f1		#robimy to samo z drugim argumentem
	cvt.s.w $f1,$f1
	div.s $f2,$f0,$f1	#teraz wykonujemy dzielenie liczb pojedynczej precyzji (czyli float�w)
	j print_result_float	#drukujemy wynik
	
multiplication:			#nag��wek mno�enia
	jal print_choice_multiplication
	mul  $t3,$t1,$t2	#u�ywamy gotowej instrukcji
	j print_result
	
print_result:			#nag��wek drukowania wyniku
	li $v0,4		
	la $a0,result_string	#drukujemy wcze�niej przygotowan� wiadomo�� "Wynik dzialania: "
	syscall
	
	li $v0,1		#ustawiamy syscall na druk inta
	move $a0,$t3		#nadpisujemy rejestr s�u��cy do druku warto�ci� zawart� w rejestrze $t3, czyli naszym wynikiem
	syscall			#i drukujemy nasz wynik
	
	j continue		#przeskakujemy do coninue
	
print_result_float:		#nag��wek drukowania wyniku
	li $v0,4		
	la $a0,result_string	#drukujemy wcze�niej przygotowan� wiadomo�� "Wynik dzialania: "
	syscall
	
	li $v0,2		#ustawiamy syscall na druk floata
	mov.s $f12,$f2  	#nadpisujemy rejestr s�u��cy do druku warto�ci� float zawart� w rejestrze $f2, czyli naszym wynikiem
	syscall			#i drukujemy nasz wynik
	
	j continue		#przeskakujemy do coninue
	
print_choice_addition:		#drukowanie informacji, kt�r� operacj� aktualnie wykonuje program
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
	
continue:			#kod tutaj zawarty s�u�y do zapytania si� czy u�ytkownik chce kontynowa�, czy te� nie
	li $v0,4
	la $a0,continue_string	#drukujemy wiadomo��
	syscall
	
	li $v0,5		#ustawiamy syscall na wczytywanie inta i pobieramy warto�� od u�ytkownika
	syscall			
	move $t0,$v0		#zapisujemy pobran� warto�� w rejestrze $t0
	
	jal line		#drukujemy 'enter'
	
	beq $t0,1,main		#je�eli warto�� r�wna si� 1 to wracamy do nag��wku main
	beqz $t0, end		#je�eli r�wna si� 0 to skaczemy do end, czyli ko�czymy program 
	j error			#je�eli warto�� nie r�wna si� 0 lub 1 to wy�wietlamy b��d
	
line: 				#tutaj tworzymy nasz� now� linijk� - 'enter'
	li $v0,4
	la $a0,newLine		#�adujemy i drukujemy
	syscall
	jr $ra			#i wracamy do miejsca z kt�rego nag��wek ten zosta� wywo�any komend� "jal"

error:				#drukujemy tutaj wiadomo�� o b��dzie, po czym przeskakujemy do maina
	jal line
	li $v0,4
	la $a0,error_string
	syscall
	j main
	
end:				#w tym nag��wku drukujemy po�egnanie i zamykamy program
	li $v0,4
	la $a0,goodbye_string   #drukujemy po�egnanie
	syscall
	
	li $v0,10	        #�adujemy 10 do rejestru, a ona w SPIM syscalls zamyka program
	syscall
