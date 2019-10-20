; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat

extern _ExitProcess@4 : PROC
extern __read : PROC ; (dwa znaki podkre�lenia)
extern __write : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxA@16 : PROC

public _main
.data
	tytul			db		'Tekst w standardzie Windows 1250' , 0
	tekst_pocz		db		10, 'Prosz', 169, ' napisa', 134, ' jaki', 152, ' tekst '
					db		'i nacisn', 165, 134,' Enter', 10
	koniec_t		db		?
	magazyn			db		80 dup (?)
					db		0
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

	ptl: mov dl, magazyn[esi] ; pobranie kolejnego znaku
	 cmp dl, ' '
	 je dalej
	 cmp dl, 'a'
	 jb dalej ; skok, gdy znak nie wymaga zamiany
	 cmp dl, 'z'+1
	 jb ascii ; skok, gdy znak ascii wymaga zamiany

	 cmp dl, 165
	 jne malec
	 mov edx, 165
	malec:
	 cmp dl, 134
	 jne malee
	 mov edx, 198
	malee:
	 cmp dl, 169
	 jne malel
	 mov edx, 202
	malel:
	 cmp dl, 136
	 jne malen
	 mov edx, 163
	malen:
	 cmp dl, 228
	 jne maleo
	 mov edx, 209
	maleo:
	 cmp dl, 162
	 jne males
	 mov edx, 211
	males:
	 cmp dl, 152
	 jne maleziet
	 mov edx, 140
	maleziet:
	 cmp dl, 171
	 jne malezet
	 mov edx, 143
	malezet:
	 cmp dl, 190
	 jne duzea
	 mov edx, 175
	duzea:
	 cmp dl, 164
	 jne duzec
	 mov edx, 165
	duzec:
	 cmp dl, 143
	 jne duzee
	 mov edx, 198
	duzee:
	 cmp dl, 168
	 jne duzel
	 mov edx, 202
	duzel:
	 cmp dl, 157
	 jne duzen
	 mov edx, 163
	duzen:
	 cmp dl, 227
	 jne duzeo
	 mov edx, 209
	duzeo:
	 cmp dl, 224
	 jne duzes
	 mov edx, 211
	duzes:
	 cmp dl, 151
	 jne duzeziet
	 mov edx, 140
	duzeziet:
	 cmp dl, 141
	 jne duzezet
	 mov edx, 143
	duzezet:
	 cmp dl, 189
	 jne dalej
	 mov edx, 175
	 jmp dalej
	ascii:
	 sub dl, 20H; zamiana na wielkie litery
	dalej:
	 mov magazyn[esi], dl ; odes�anie znaku do pami�ci
	 inc esi ; inkrementacja indeksu

	 ;loop ptl
	 dec ecx ; sterowanie p�tl�
	 jnz ptl ; sterowanie p�tl�

	; wy�wietlenie przekszta�conego tekstu
	 push 0
	 push OFFSET tytul
	 push OFFSET magazyn
	 push 0
	 call _MessageBoxA@16 ; wy�wietlenie przekszta�conego tekstu
	 push 0
	 call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END