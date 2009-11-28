segment .text
global _strlen

_strlen:
        push ebp                 ; Zachowujemy wartość ebp
        mov  ebp, esp            ; i przenosimy do niego esp
        push edi                 ; zachowujemy wartość edi

        xor  eax, eax            ; zerujemy al żeby móc porównywać z 0 przy pomocy scasb
        mov  ecx, 0xffffffff     ; ustawiamy ecx na bardzo dużą wartość.
        mov  edi, [ebp + 8]      ; do edi wrzucamy adres poczatku lancucha znajdujacy sie pod [ebp+8]

        repne scasb              ; porownoj az cmp al,[edi] albo ecx = 0

        mov  eax, edi            ; do eax przenosimy adres edi
        sub  eax, [ebp + 8]      ; odejmujemy początek łancucha
        sub  eax, 1              ; nie zliczamy 0 

        pop  edi
        pop  ebp
        ret
