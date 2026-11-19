; lab6_modos_inverso.asm - Extension del Modo 4: recorrido inverso del array
; Compilar (nombre 8.3 en DOSBox): nasm -f bin lab6inv.asm -o lab6inv.com
; SI parte del ultimo elemento (indice 8 bytes) y decrece 2 bytes por iteracion.

org  100h

jmp  inicio

array    dw  10, 20, 30, 40, 50     ; mismo array que lab6_modos.asm

inicio:
    xor  ax, ax             ; acumulador en cero
    mov  bx, array          ; BX = direccion base del array
    mov  cx, 5              ; numero de elementos
    mov  si, 8              ; SI = indice en bytes del ultimo elemento (4 * 2)
.bucle_inverso:
    add  ax, [bx + si]      ; AX += array[SI/2], de array[4] hacia array[0]
    sub  si, 2              ; retroceder una palabra
    loop .bucle_inverso     ; AX = 150 al terminar

    int  20h                ; retornar a DOS
