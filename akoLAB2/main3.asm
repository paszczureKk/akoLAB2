; Przyk³ad wywo³ywania funkcji MessageBoxA i MessageBoxW
.686
.model flat

extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC

public _main
.data
	tytul_Unicode	dw		'T','e','k','s','t',' ','w',' '
					dw		'f','o','r','m','a','c','i','e',' '
					dw		'U','T','F','-','1','6', 0
	tekst_Unicode	dw		'T','o',' ','j','e','s','t',' '
					dw		'p','i','e','s',' '
					dw		0D83DH, 0DC15H
					dw		' ','i',' ','k','o','t',' '
					dw		0D83DH, 0DC08H
.code
_main PROC
	 push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	 push OFFSET tytul_Unicode
	; adres obszaru zawieraj¹cego tekst
	 push OFFSET tekst_Unicode
	 push 0 ; NULL
	 call _MessageBoxW@16
	 push 0 ; kod powrotu programu
	 call _ExitProcess@4
_main ENDP
END