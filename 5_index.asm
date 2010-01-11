segment .data
what         db   'ala',0 
where        db   'ala ma kota, ale ala ma tez psa, aala'
where_length equ  $-where
marker       db   ' ^'
eol          db   0x0a

segment .bss
write_buffer resb 16

segment .text
        global _start, _print_number

_p:
        mov eax, 4 ;write   ;zakładamy że wołający zajął się przechowywaniem rejestrów, i umieścił adres do łańcucha w CX
        mov ebx, 1 ;stdout
        mov edx, 1          ; ustawiamy długość na 1
        int 0x80
        ret

_find: 
        mov edi, ebx            ; do edi lancuch docelowy
        mov al, [eax]           ; bierzemy pierwszy poszukiwany znak szukanego do porownywania
                                ; w ecx mamy dlugosc docelowego
        cld                     ; ustalamy kierunek przeszukiwania
        
        find_first:
          cmp_loop:
            scasb                 ; porownoj az cmp al,[edi] albo ecx = 0
            je next               ; jesli udalo nam sie porownac przeskakujemy do przodu
            pushad                ; wypisujemy spacje
              mov ecx, marker
              call _p
            popad
          loop cmp_loop           ; kontynuujemy petle az ecx bedzie 0
          jmp _end_find           ; konczymy wyszukiwanie
         
         next:
          mov esi, what + 1           ; zaczynamy od drugiego znaku, edi jest juz tez na odpowiedniej pozycji

          push ecx
          push edi                    ; zrzucamy rejestry na stos, zebysmy mogli wrocic do oryginalnej wartosci ecx i edi
            repe cmpsb                ; porownojemy [edi] oraz [esi]
          pop  edi                    ; podnosimy rejestry ze stosu, EDI i ECX powinny miec stare wartosci
          pop  ecx
  
          pushad                      ; Wypisujemy odpowiedni marker zaleznie czy ostani znak ktory porownalismy byl 0
            dec esi
            mov ecx, marker
            cmp byte [esi], 0         ; spawdzamy czy ostatni porownany znak byl 0
            jnz end_if
              inc ecx
            end_if:

            call _p
          popad
          
        jmp find_first                ; nie uzywamy loop, bo repne i tak zmniejsza ecx
_end_find:
        ret

_start:
        mov eax, 4 ;write             ; wypisujemy poszukiwany lancuch
        mov ebx, 1 ;stdout
        mov ecx, where
        mov edx, where_length
        int 0x80

        mov ecx, eol                  ; wupisujemy koniec linii 
        call _p

        mov eax, what                 ; uruchamiamy wyszukiwanie
        mov ebx, where
        mov ecx, where_length
        
        call _find                    ; 

        mov ecx, eol                  ; i koniec linii
        call _p


_exit:
        mov eax, 1
        mov ebx, 0
        int 0x80
