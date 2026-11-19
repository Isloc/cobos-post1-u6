; lab6_instrucciones.asm - Demostracion de categorias de instrucciones x86
; Compilar (nombre 8.3 en DOSBox): nasm -f bin lab6ins.asm -o lab6ins.com
; Formato .COM: un solo segmento de 64 KB, origen en el offset 100h.

org  100h                   ; offset de inicio para archivos .COM

; -- Datos ----------------------------------------------------------------
jmp  inicio                 ; saltar sobre los datos hacia el codigo

valor_a   dw  45            ; primer operando
valor_b   dw  12            ; segundo operando
resultado dw  0             ; almacena el resultado de la suma
contador  db  5             ; contador de bucle (informativo)
mascara   db  0Fh           ; mascara de 4 bits bajos

; -- Codigo ---------------------------------------------------------------
inicio:

; -- BLOQUE 1: Transferencia de datos -------------------------------------
    mov  ax, [valor_a]      ; AX = 45 (contenido de valor_a)
    mov  bx, [valor_b]      ; BX = 12 (contenido de valor_b)

    mov  cx, ax             ; CX = AX = 45 (copia entre registros)
    mov  dx, bx             ; DX = BX = 12

    lea  si, [valor_a]      ; SI = direccion de valor_a (no su valor)
    mov  ax, [si]           ; AX = mem[SI] = 45 (indirecto por SI)

    xchg cx, dx             ; CX = 12, DX = 45
    xchg cx, dx             ; se restaura: CX = 45, DX = 12

    push ax                 ; guarda AX = 45 en la pila
    mov  ax, 0FFFFh         ; modifica AX temporalmente
    pop  ax                 ; restaura AX = 45

; -- BLOQUE 2: Operaciones aritmeticas ------------------------------------
    mov  ax, [valor_a]      ; AX = 45
    add  ax, [valor_b]      ; AX = 57 (ZF=0, CF=0, OF=0)
    mov  [resultado], ax    ; guarda 57 en memoria

    mov  ax, [valor_b]      ; AX = 12
    sub  ax, [valor_a]      ; AX = 12 - 45 = -33 (SF=1, CF=1)

    mov  ax, [valor_a]      ; AX = 45
    inc  ax                 ; AX = 46 (INC no afecta CF)
    dec  ax                 ; AX = 45

    mov  al, 10             ; AL = 10
    mov  bl, 7              ; BL = 7
    mul  bl                 ; AX = AL * BL = 70

    mov  ax, 100            ; AX = 100
    mov  bl, 7              ; BL = 7
    div  bl                 ; AL = 14 (cociente), AH = 2 (resto)

; -- BLOQUE 3: Operaciones logicas ----------------------------------------
    mov  al, 0B7h           ; AL = 1011 0111b
    and  al, [mascara]      ; AL = B7h AND 0Fh = 07h (limpia los 4 bits altos)

    mov  al, 0B7h           ; se restaura AL
    or   al, 0F0h           ; AL = B7h OR F0h = F7h (activa los 4 bits altos)

    mov  al, 0AAh           ; AL = 1010 1010b
    xor  al, 0FFh           ; AL = NOT AL = 55h (inversion selectiva)

    xor  bx, bx             ; BX = 0 (forma estandar de poner a cero)

    mov  al, 0B7h
    test al, 01h            ; ZF = 0 porque el bit 0 vale 1 (numero impar)

    mov  al, 08h            ; AL = 8
    shl  al, 2              ; AL = 8 << 2 = 20h
    shr  al, 1              ; AL = 20h >> 1 = 10h

; -- BLOQUE 4: Control de flujo -------------------------------------------
    mov  ax, [valor_a]      ; AX = 45
    cmp  ax, [valor_b]      ; 45 - 12 = 33 > 0
    jg   .mayor             ; salta si AX > valor_b (con signo)
    je   .igual             ; salta si AX == valor_b
    xor  cx, cx             ; caso menor: CX = 0 (no se alcanza)
    jmp  .fin_cmp
.mayor:
    mov  cx, 1              ; CX = 1: valor_a > valor_b
    jmp  .fin_cmp
.igual:
    mov  cx, 2              ; CX = 2: igualdad
.fin_cmp:

    xor  ax, ax             ; AX = 0 (acumulador)
    mov  cx, 5              ; CX = contador del bucle
    mov  bx, 1              ; BX = valor inicial a sumar
.bucle_suma:
    add  ax, bx             ; AX += BX
    inc  bx                 ; BX++
    loop .bucle_suma        ; CX--; si CX != 0 repite
    ; Al terminar: AX = 1+2+3+4+5 = 15

; -- BLOQUE 5: Rotacion - ROL/ROR frente a SHL/SHR ------------------------
    mov  al, 81h            ; AL = 1000 0001b (bits 7 y 0 en 1)

    mov  bl, al             ; BL = 81h
    shl  bl, 1              ; BL = 02h, CF = 1 (el bit 7 se pierde)

    mov  cl, al             ; CL = 81h
    rol  cl, 1              ; CL = 03h, CF = 1 (el bit 7 reaparece en el bit 0)

    mov  dl, al             ; DL = 81h
    shr  dl, 1              ; DL = 40h, CF = 1 (el bit 0 se pierde)

    mov  bh, al             ; BH = 81h
    ror  bh, 1              ; BH = C0h, CF = 1 (el bit 0 reaparece como bit 7)

    mov  al, 0A5h           ; AL = 1010 0101b (nibble alto A, nibble bajo 5)
    rol  al, 4              ; AL = 5Ah (nibbles intercambiados)

    int  20h                ; retornar a DOS
