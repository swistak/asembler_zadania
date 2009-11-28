segment .data
test    db 'raz dwa trzy',0

segment .text
global start, _strlen
extern _print_nmber

_strlen:
        push ebp                 ; Zachowujemy wartość ebp
        mov  ebp, esp            ; i przenosimy do niego esp
        push edi                 ; zachowujemy wartość edi

        xor  eax
        or   ecx, 0xffffffff
        sub  ebp, 8              ; pierwszy parameter jest domyslnie pod [esp + 8]
        mov  edi, ebp            ; 

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
