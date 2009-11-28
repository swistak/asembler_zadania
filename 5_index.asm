segment .data
what         db   1,2 
what_length  equ  $-what
where        db   1,2,1,2,0,0,0,0,0,0,0,1,2
where_length equ  $-where

segment .bss
write_buffer resb 16

segment .text
        global _start, _print_number

_print_number: ;wypisuje numer zawarty w rejestrze eax, razem z koncem nowej linii
        mov edi, write_buffer + 14 ; zostawiamy jeden znak na końcu na nową linię
        mov byte [edi+1], 0x0a  ; i ladujemy ja na sam koniec
        
        xor ecx, ecx            ; zerujemy ecx
        xor edx, edx            ; zerujemy edx
        mov cl, 10              ; ustalamy dzielnik na 10

        division:
          xor edx, edx
          div ecx               ; eax = eax mod ecx
                                ; edx = eax rem ecx
          add dl, 48            ; dodajemy '0'            
          mov [edi], dl         ; kopiujemy znak do bufora
          dec edi               ; przesuwamy wskazni
          
          cmp eax, 0            ; nie mozna uzyc jz bo ZF jest ustawiane nie przez dzielenie tylko dec
        jne division

        mov edx, write_buffer + 16 ;obliczamy dlugosc lancucha
        sub edx, edi
        mov ecx, edi            ; w edi jest adres poczatku lancucha

        mov eax, 4 ;write       ; i wolamy sys_write
        mov ebx, 1 ;stdout
        int 0x80

        ret

_start: 
        mov edi, where
        mov al, [what]          ; bierzemy pierwszy poszukiwany znak
        mov ecx, where_length - what_length + 1; 
        cld
        
        find_first:
          repne scasb                 ; porownoj az cmp al,[edi] albo ecx = 0
                                      ; znalezlismy pierwszy znak albo zakonczylismy poszukiwanie
          jne _exit                   ; jesli ostatnie porownanie nie ustawilo odpowiedniej flagi to wychodzimy                   

          pushad                      ; zrzucamy rejestry na stos, zebysmy mogli manipulowac ecx
            mov ecx, what_length - 1  ; pierwszy znak juz dopasowalismy
            mov esi, what + 1         ; wiec zaczynamy od drugiego, edi jest juz tez na odpowiedniej pozycji

            repe cmpsb                ; porownujemy znaki az znajdziemy jeden ktory sie rozni, lub cx = 0
          popad                       ; podnosimy rejestry ze stosu, EDI i ECX powinny miec stare wartosci
          
          jne find_first              ; jesli ostatnie porownanie nie bylo prawdziwe to
                                      ; ponownie zaczynamy dopasowywac pierwszy znak
          pushad
            mov eax, edi              ; w edi jest pozycja wystapienia pierwszego znaku + 1 
            sub eax, where + 1        ; wiec odejmujemy poczatek lancucha + 1
            call _print_number        ; wypisujemy numer
          popad

        jmp find_first                ; nie uzywamy loop, bo repne i tak zmniejsza ecx
          
_exit:
        mov eax, 1
        mov ebx, 0
        int 0x80
