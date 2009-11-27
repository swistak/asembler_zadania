segment .data
buffer    db      0

eol       db      0x0a
to_big    db      "podana liczba jest zbyt duza", 0x0a
to_big_l  equ     $-to_big 
nan       db      "nie podales poprawnej liczby naturalnej", 0x0a
nan_l     equ     $-nan

stdin     equ     0
stdout    equ     1
stderr    equ     2

sys_read  equ     3
sys_write equ     4
sys_exit  equ     1

hex_codes db      '0123456789ABCDEF'

segment .text
    global      _start

_print_hex:  ; wypisuje znak w rejestrze eax jako hexa
      mov ecx, 8            ; ile znaków ma liczba

      hex_loop:  
        mov ebx, eax        ; pętla
        and ebx, 0xF0000000 ; sprawdzamy czy najbardziej znaczacy bit jest ustawiony
        rol ebx, 4          ; obracamy w lewo o 4 bity (16 wartości)
        pushad              ; zrzucamy rejestry na stos przed wołaniem _p

        mov ecx, hex_codes  ; ustalamy adres na łańcuch '0'
        add ecx, ebx        ; dodajemy wartość rejestru ebx do wskaźnika przesuwając go o 0-15 wartosci,
                            ; jeśli adresy są dopasowywane do 4 bajtów, należy zrobić rol ebx, 3
        mov eax, sys_write  ; wypisujemy znak
        mov ebx, stdout
        mov edx, 1
        int 0x80
 
        popad               ; odzyskujemy wartości AX i CX

        shl eax, 4          ; przesuwamy AX w lewo o 4 (dzielimy przez 16)
      loop hex_loop         ; i skaczemy do początku pętli
      
      ret

_start: 

        mov ecx, buffer
        mov edx, 1
        xor eax, eax   ; zerujemy eax
        
        loop:   
          push eax     ; zczytujemy znak ze standardowego wejscia
            mov eax, sys_read
            mov ebx, stdin
            int 0x80
          pop eax

          cmp byte [buffer], 0x0a ; Sprawdzamy czy nacisnieto enter 
          je  _output             ; jesli tak to skaczemy do obliczen
 
          xor ebx, ebx            ; kopiujemy znak z bufora do ebx, dla dalszych obliczen
          mov bl, [buffer]
          
          clc                     ; czyscimy CF
          sub ebx, 48             ; odejmujemy 48 (kod '0')
          jc  _nan                ; sprawdzamy CF, jesli jest ustawiona dostalismy znak o kodzie < 48
          cmp ebx, 10             ; porownojemy z 10 - potrzeba nam liczby jedynie z zakresu 0-9
          jnc _nan                ; jesli nie ustawiono CF, liczba jest >= 10
          
          push ebx
          inc  eax
        jmp loop
         
; ### Wypisanie wyniku ###
_output:
      ; na stosie mamy eax, podwojnych slow ktore musimy teraz do siebie dodac, uwzgledniajac ich porzadek
      mov ecx, eax    ; licznik
      xor eax, eax    ; tymczasowiec
      xor ebx, ebx    ; suma
      mov esi, 1      ; aktualny mmnoznik
      
      pop_and_add:
        mov eax, esi  ;
        pop edx       ;
        mul edx       ; eax = liczba ze stosu * aktualny mnoznik

        add ebx, eax  ; suma += eax
        jc  _to_big   

        mov eax, 10   ;
        mul esi       ; 
        mov esi, eax  ; aktualny mnoznik *= 10
        jc  _to_big

      loop pop_and_add

      mov eax, ebx
      call _print_hex

      ; co by bylo ladnie wypisujemy koniec linii
      mov ecx, eol
      mov edx, 1
      mov eax, sys_write
      mov ebx, stdout
      int 0x80

      mov ebx, 0 ; czyste wyjscie
      jmp _exit

; ### Obsluga bledow ###
_nan:
        mov ecx, nan
        mov edx, nan_l
        jmp _print_error
_to_big:
        mov ecx, to_big
        mov edx, to_big_l
        jmp _print_error
_print_error:
        mov eax, sys_write
        mov ebx, stderr
        int 0x80
        mov ebx, -1 ; wyjscie z bledem

; ### wyjscie z programu ###
_exit:
        mov eax, sys_exit
        int 0x80
