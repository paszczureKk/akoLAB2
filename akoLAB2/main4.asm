; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)

public _main
.data
	tekst_pocz		db		10, 'Prosz', 169, ' napisa', 134, ' jaki', 152, ' tekst '
					db		'i nacisn', 165, 134,' Enter', 10
	koniec_t		db		?
	magazyn			db		80 dup (?)
	nowa_linia		db		10
	liczba_znakow	dd		?
.code
_main PROC
	; wyœwietlenie tekstu informacyjnego
	; liczba znaków tekstu
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
	 call __write ; wyœwietlenie tekstu pocz¹tkowego
	 add esp, 12 ; usuniecie parametrów ze stosu
	; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znaków
	 push OFFSET magazyn
	 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znaków z klawiatury
	 add esp, 12 ; usuniecie parametrów ze stosu
	; kody ASCII napisanego tekstu zosta³y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbê
	; wprowadzonych znaków
	 mov liczba_znakow, eax
	; rejestr ECX pe³ni rolê licznika obiegów pêtli
	 mov ecx, eax
	 mov ebx, 0 ; indeks pocz¹tkowy
	ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	 cmp dl, 'a'
	 jb dalej ; skok, gdy znak nie wymaga zamiany
	 cmp dl, 'z'+1
	 jb ascii ; skok, gdy znak ascii wymaga zamiany

	 cmp dl, 165
	 jne literac
	 mov dl, 164
	literac:
	 cmp dl, 134
	 jne e
	 mov dl, 143
	e:
	 cmp dl, 169
	 jne l
	 mov dl, 168
	l:
	 cmp dl, 136
	 jne n
	 mov dl, 157
	n:
	 cmp dl, 228
	 jne o
	 mov dl, 227
	o:
	 cmp dl, 162
	 jne s
	 mov dl, 224
	s:
	 cmp dl, 152
	 jne ziet
	 mov dl, 151
	ziet:
	 cmp dl, 171
	 jne zet
	 mov dl, 141
	zet:
	 cmp dl, 190
	 jne dalej
	 mov dl, 189
	 jmp dalej
	ascii:
	 sub dl, 20H; zamiana na wielkie litery
	dalej:
	 mov magazyn[ebx], dl ; odes³anie znaku do pamiêci
	 inc ebx ; inkrementacja indeksu
	 loop ptl ; sterowanie pêtl¹
	; wyœwietlenie przekszta³conego tekstu
	 push liczba_znakow
	 push OFFSET magazyn
	 push 1
	 call __write ; wyœwietlenie przekszta³conego tekstu
	 add esp, 12 ; usuniecie parametrów ze stosu
	 push 0
	 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END