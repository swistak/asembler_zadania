segment .data
msg     db      'hello, world!'
        db      0x0a
msglen  equ     $-msg

segment .text
    global      _start
_start: mov eax, 4 ;write
        mov ebx, 1 ;stdout
        mov ecx, msg
        mov edx, msglen
        int 0x80
        mov eax, 1
        mov ebx, 0
        int 0x80
