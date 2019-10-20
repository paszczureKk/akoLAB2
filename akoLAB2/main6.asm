; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat

extern _ExitProcess@4 : PROC
extern __read : PROC ; (dwa znaki podkre�lenia)
extern __write : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxW@16 : PROC

public _main
.data
	tytul			dw		'T','e','k','s','t',' ','w',' '
					dw		'f','o','r','m','a','c','i','e',' '
					dw		'U','T','F','-','1','6', 0
	tekst_pocz		db		10, 'Prosz', 169, ' napisa', 134, ' jaki', 152, ' tekst '
					db		'i nacisn', 165, 134,' Enter', 10
	koniec_t		db		?
	magazyn			db		80 dup (?)
					db		0
	wynik			dword   80 dup (?)
					dword	0
	nowa_linia		db		10
	liczba_znakow	dd		?

.code
_main PROC
	; wy�wietlenie tekstu informacyjnego
	; liczba znak�w tekstu
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	 call __write ; wy�wietlenie tekstu pocz�tkowego
	 add esp, 12 ; usuniecie parametr�w ze stosu
	; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znak�w
	 push OFFSET magazyn
	 push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znak�w z klawiatury
	 add esp, 12 ; usuniecie parametr�w ze stosu
	; kody ASCII napisanego tekstu zosta�y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczb�
	; wprowadzonych znak�w
	 mov liczba_znakow, eax
	; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	 mov ecx, eax
	 mov esi, 0 ; indeks pocz�tkowy
	 mov edi, 0

	ptl: mov dl, magazyn[esi] ; pobranie kolejnego znaku
	 cmp dl, 0AH
	 je koniec
	 cmp dl, ' '
	 je spacja
	 cmp dl, 'a'
	 jb dalej ; skok, gdy znak nie wymaga zamiany
	 cmp dl, 'z'+1
	 jb ascii ; skok, gdy znak ascii wymaga zamiany

	 cmp dl, 165
	 jne malec
	 mov edx, 0104H
	malec:
	 cmp dl, 134
	 jne malee
	 mov edx, 0106H
	malee:
	 cmp dl, 169
	 jne malel
	 mov edx, 0118H
	malel:
	 cmp dl, 136
	 jne malen
	 mov edx, 0141H
	malen:
	 cmp dl, 228
	 jne maleo
	 mov edx, 0143H
	maleo:
	 cmp dl, 162
	 jne males
	 mov edx, 00D3H
	males:
	 cmp dl, 152
	 jne maleziet
	 mov edx, 015AH
	maleziet:
	 cmp dl, 171
	 jne malezet
	 mov edx, 0179H
	malezet:
	 cmp dl, 190
	 jne duzea
	 mov edx, 017BH
	duzea:
	 cmp dl, 164
	 jne duzec
	 mov edx, 0104H
	duzec:
	 cmp dl, 143
	 jne duzee
	 mov edx, 0106H
	duzee:
	 cmp dl, 168
	 jne duzel
	 mov edx, 0118H
	duzel:
	 cmp dl, 157
	 jne duzen
	 mov edx, 0141H
	duzen:
	 cmp dl, 227
	 jne duzeo
	 mov edx, 0143H
	duzeo:
	 cmp dl, 224
	 jne duzes
	 mov edx, 00D3H
	duzes:
	 cmp dl, 151
	 jne duzeziet
	 mov edx, 015AH
	duzeziet:
	 cmp dl, 141
	 jne duzezet
	 mov edx, 0179H
	duzezet:
	 cmp dl, 189
	 jne dalej
	 mov edx, 017BH
	 jmp dalej
	ascii:
	 sub dl, 20H; zamiana na wielkie litery
	spacja:
	 mov dh, 00H
	dalej:
	 mov wynik[edi], edx ; odes�anie znaku do pami�ci
	koniec:
	 inc esi ; inkrementacja indeksu
	 add edi, 2

	 ;loop ptl
	 dec ecx ; sterowanie p�tl�
	 jnz ptl ; sterowanie p�tl�

	; wy�wietlenie przekszta�conego tekstu
	 push 0
	 push OFFSET tytul
	 push OFFSET wynik
	 push 0
	 call _MessageBoxW@16 ; wy�wietlenie przekszta�conego tekstu
	 push 0
	 call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END