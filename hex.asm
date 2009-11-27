segment .data
hex_codes  db      '0123456789ABCDEF' 
eol        db      0x0a ; koniec lini

segment .text
        global      _start ; zaczynamy od startu

_p:    
        mov eax, 4 ;write   ;zakładamy że wołający zajął się przechowywaniem rejestrów, i umieścił adres do łańcucha w CX
        mov ebx, 1 ;stdout
        mov edx, 1          ; ustawiamy długość na 1
        int 0x80
        ret 

_start: mov eax, 0x89ABCDEF ; liczba którą zmieniamy na jedynke
        mov ecx, 8          ; ile znaków ma liczba

_loop:  mov ebx, eax        ; pętla
        and ebx, 0xF0000000 ; sprawdzamy czy najbardziej znaczacy bit jest ustawiony
        rol ebx, 4          ; obracamy w lewo o 4 bity (16 wartości) 
        pushad              ; zrzucamy rejestry na stos przed wołaniem _p
        
        mov ecx, hex_codes  ; ustalamy adres na łańcuch '0'
        add ecx, ebx        ; dodajemy wartość rejestru ebx do wskaźnika przesuwając go o 0-15 wartosci, 
                            ; jeśli adresy są dopasowywane do 4 bajtów, należy zrobić rol ebx, 3
        call _p             ; wypisujemy cyferkę
        popad               ; odzyskujemy wartości AX i CX
        
        shl eax, 4          ; przesuwamy AX w lewo o 4 (dzielimy przez 16)
        loop _loop          ; i skaczemy do początku pętli
_nl:  
        mov ecx, eol        ; wypisujemy koniec linii
        call _p

_exit:
        int 0x80            ; i wychodzimy z programu
        mov eax, 1
        mov ebx, 0
        int 0x80
