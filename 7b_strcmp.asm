segment .text
global asm_strcmp

asm_strcmp:
        push ebp                 ; Zachowujemy wartość ebp
        mov  ebp, esp            ; i przenosimy do niego esp
        push edi                 ; zachowujemy wartość edi

        xor  eax, eax            ; zerujemy al żeby móc porównywać z 0 przy pomocy scasb
        mov  ecx, 0xffffffff     ; ustawiamy ecx na bardzo dużą wartość.
        mov  esi, [ebp + 8]      ; do edi wrzucamy adres poczatku lancucha znajdujacy sie pod [ebp+8]
        mov  edi, [ebp + 12]     ; do esi wrzucamy adres poczatku drugiego lancucha

  loop:   
          cmpsb                  ; porownoj poki [esi] == [edi]
          je loop                ; jesli sa rowne lecimy dalej
          jz eos                 ; sprawdzamy czy jeden z lancochow jest 0
          
        
  eos:                           ; jeden lub dwa z lancuchow sie zakonczyl
        xor eax, eax
        xor ebx, ebx
        mov bh, [esi-1]
        mov bl, [edi-1]
        cmp bh, bl
        jz  end
        jnc add_one
        sbb eax, 0
        jmp  end
  add_one:
        add eax, 1

  end:

        pop  edi
        pop  ebp
        ret
