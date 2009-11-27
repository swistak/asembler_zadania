_print: ; drukuje ograniczony 0 lancuch, ktorego adres jest w edi
        pushad

        mov ecx, 0xFFFFFFFF ; najpierw znajdujemy jego dlugosc
        xor al, al
        cld
        repnz scasb
        mov edx, 0xFFFFFFFE
        sub edx, ecx

        mov eax, sys_write
        mov ebx, stdout
        int 0x80

        popad
        ret

