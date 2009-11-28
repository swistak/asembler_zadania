segment .data
test    db 'raz dwa trzy',0

segment .text
global start, _strlen
extern _print_nmber

_strlen:
        push ebp                 ; Zachowujemy wartość ebp
        mov  ebp, esp            ; i przenosimy do niego esp
        push edi                 ; zachowujemy wartość edi

        xor  eax                 ; zerujemy al żeby móc porównywać z 0 przy pomocy scasb
        or   ecx, 0xffffffff     ; ustawiamy ecx na bardzo dużą wartość.
        mov  edi, [ebp + 8]      ; do edi wrzucamy adres poczatku lancucha znajdujacy sie pod [ebp+8]

        repne scasb              ; porownoj az cmp al,[edi] albo ecx = 0

        mov  eax, edi            ; do eax przenosimy adres edi
        sub  eax, [ebp + 8]      ; odejmujemy początek łancucha
        sub  eax, 2              ; edi jest po ostatniej instrukcji scasb o jeden za daleko, dodatkowo nie zliczamy 0 

        pop  edi
        pop  ebp
        ret

start:
        push dword test
        call _strlen
        call _print_number

exit:
        mov eax, 1
        mov eax, 0
        int 0x80

_print_number: ;wypisuje numer zawarty w rejestrze eax, razem z koncem nowej linii
        mov edi, write_buffer + 14 ; zostawiamy jeden znak na końcu na nową linię
        mov byte [edi+1], 0x0a  ; i ladujemy ja na sam koniec

        xor ecx, ecx            ; zerujemy ecx
        xor edx, edx            ; zerujemy edx
        mov cl, 10              ; ustalamy dzielnik na 10

        division:
          div ecx               ; eax = eax mod ecx
                                ; edx = eax rem ecx
          add dl, 48            ; dodajemy '0'
          mov [edi], dl         ; kopiujemy znak do bufora
          dec edi               ; przesuwamy wskaznik

          cmp eax, 0            ; nie mozna uzyc jz bo ZF jest ustawiane nie przez dzielenie tylko dec
        jne division

        mov edx, write_buffer + 16 ;obliczamy dlugosc lancucha
        sub edx, edi
        mov ecx, edi            ; w edi jest adres poczatku lancucha

        mov eax, 4 ;write       ; i wolamy sys_write
        mov ebx, 1 ;stdout
        int 0x80

        ret

