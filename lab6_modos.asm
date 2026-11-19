; lab6_modos.asm - Demostracion de modos de direccionamiento x86
; Compilar (nombre 8.3 en DOSBox): nasm -f bin lab6mod.asm -o lab6mod.com

org  100h

; -- Datos de prueba ------------------------------------------------------
jmp  inicio

array    dw  10, 20, 30, 40, 50     ; array de 5 enteros de 16 bits

nota1    dw  85                     ; registro de estudiante: nota1, nota2, promedio
nota2    dw  73
promedio dw  0

var_x    dw  0FFFFh                 ; variable simple para direccionamiento directo

inicio:

; -- MODO 1: INMEDIATO ----------------------------------------------------
    mov  ax, 100            ; AX = 100 (inmediato decimal)
    mov  bx, 0A5h           ; BX = A5h (inmediato hexadecimal)
    add  cx, 55             ; CX += 55 (inmediato en una suma)
    and  dx, 00FFh          ; DX AND mascara inmediata

; -- MODO 2: DIRECTO ------------------------------------------------------
    mov  ax, [var_x]        ; AX <- mem[var_x] = FFFFh
    mov  bx, [array]        ; BX <- mem[array] = 10 (primer elemento)
    mov  cx, [nota1]        ; CX <- mem[nota1] = 85
    mov  word [var_x], 0    ; mem[var_x] = 0 (escritura directa)

; -- MODO 3: INDIRECTO POR REGISTRO ---------------------------------------
    mov  si, nota1          ; SI = direccion de nota1
    mov  ax, [si]           ; AX <- mem[SI] = 85
    mov  si, nota2          ; SI = direccion de nota2
    mov  bx, [si]           ; BX <- mem[SI] = 73
    add  ax, bx             ; AX = 158
    shr  ax, 1              ; AX = 79
    mov  si, promedio       ; SI = direccion de promedio
    mov  [si], ax           ; mem[SI] = 79

; -- MODO 4: INDEXADO (BASE + INDICE + DESPLAZAMIENTO) --------------------
    mov  bx, array          ; BX = direccion base del array
    mov  si, 4              ; SI = 2 * 2 bytes
    mov  ax, [bx + si]      ; AX <- array[2] = 30

    xor  ax, ax             ; acumulador en cero
    mov  bx, array
    mov  cx, 5              ; numero de elementos
    xor  si, si             ; indice en bytes
.bucle_array:
    add  ax, [bx + si]      ; AX += array[SI/2]
    add  si, 2              ; avanzar una palabra
    loop .bucle_array       ; AX = 150 al terminar

    mov  bx, nota1          ; BX = base del "struct"
    mov  ax, [bx]           ; AX = nota1 = 85 (desplazamiento 0)
    mov  cx, [bx + 2]       ; CX = nota2 = 73 (desplazamiento 2)
    mov  dx, [bx + 4]       ; DX = promedio = 79 (desplazamiento 4)

    int  20h                ; retornar a DOS
