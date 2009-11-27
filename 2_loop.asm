segment .bss
target  resd    100
length  equ  $-target

segment .text
        global _start

_start: mov edx, target          ; do ds adres docelowy
        mov ecx, 0     

_loop:  mov dword [edx], ecx
        add edx, 4

        inc ecx
        cmp ecx, length
        jne _loop

        mov eax, 1
        mov ebx, 0
        int 0x80
