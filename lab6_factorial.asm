; lab6_factorial.asm - Variante del bucle del Bloque 4: factorial de 5
; Compilar (nombre 8.3 en DOSBox): nasm -f bin lab6fac.asm -o lab6fac.com
; Se reemplaza ADD por MUL: AX acumula el producto 1*1*2*3*4*5 = 120.

org  100h

inicio:
    mov  ax, 1              ; AX = 1 (acumulador del producto)
    mov  cx, 5              ; CX = contador del bucle
    mov  bx, 1              ; BX = factor actual
.bucle_fact:
    mul  bx                 ; DX:AX = AX * BX (DX queda en 0 mientras quepa en 16 bits)
    inc  bx                 ; siguiente factor
    loop .bucle_fact        ; CX--; si CX != 0 repite
    ; Al terminar: AX = 120 = 78h

    int  20h                ; retornar a DOS
