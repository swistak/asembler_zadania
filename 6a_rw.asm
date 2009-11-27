segment .data
buffer  db      0

stdin   equ     0
stdout  equ     1

sys_read  equ   3
sys_write equ   4
sys_exit  equ   1

segment .text
    global      _start
_start: 

        mov ecx, buffer
        mov edx, 1
        
loop:   
        mov eax, sys_read
        mov ebx, stdin
        int 0x80

        or eax, eax
        je _exit

        mov eax, sys_write
        mov ebx, stdout
        int 0x80
        
        cmp byte [buffer], 0x0a ; Sprawdzamy czy nacisnieto enter 
        jne loop

_exit:
        mov eax, sys_exit
        mov ebx, 0
        int 0x80
