segment .data
bin_data  db      '01' ; ustawiamy zero i jeden
eol       db      0x0a ; koniec lini

segment .text
        global      _start ; zaczynamy od startu

_p:    
        mov eax, 4 ;write   ;zakładamy że wołający zajął się przechowywaniem rejestrów, i umieścił adres do łańcucha w CX
        mov ebx, 1 ;stdout
        mov edx, 1          ; ustawiamy długość na 1
        int 0x80
        ret 

_start: mov eax, 0xFF000000 ; liczba którą zmieniamy na jedynke
        mov ecx, 32         ; ile bitów ma liczba

_loop:  mov ebx, eax        ; pętla
        and ebx, 0x80000000 ; sprawdzamy czy najbardziej znaczacy bit jest ustawiony
        rol ebx, 1          ; jeśli tak, to obracamy raz w lewo żeby dostać jedynkę
        pushad              ; zrzucamy rejestry na stos przed wołaniem _p
        
        mov ecx, bin_data   ; ustalamy adres na łańcuch '0'
        add ecx, ebx        ; jeśli jednak jest to jedynka podbijamy wskaźnik adresu o jeden, 
                            ; jeśli adresy są dopasowywane do 4 bajtów, należy zrobić rol ebx, 3
        call _p             ; wypisujemy cyferkę
        popad               ; odzyskujemy wartości AX i CX
        
        shl eax, 1          ; przesuwamy AX o jeden w lewo, by dostać kolejny bajt
        loop _loop          ; i skaczemy do początku pętli
_nl:  
        mov ecx, eol        ; wypisujemy koniec linii
        call _p

_exit:
        int 0x80            ; i wychodzimy z programu
        mov eax, 1
        mov ebx, 0
        int 0x80
