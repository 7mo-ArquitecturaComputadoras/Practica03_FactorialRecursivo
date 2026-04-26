; ============================================================
; Autor: Edson Joel Carrera Avila
; factorial.asm
; ============================================================

.586
.model flat, c         

; ============================================================
; SECCIÓN DE CÓDIGO (.code)
; ============================================================
.code
; --- Inicio del programa ---

; Mi_fact: Calcula x! mediante un bucle descendente
; Parámetro: [EBP+8]=x
Mi_fact PROC
    PUSH    EBP
    MOV     EBP, ESP
    SUB     ESP, 8
    FLD     QWORD PTR [EBP+8]   

    ; --- x <= 1.0 ---
    FLD1                            ; Meter 1.0 en la FPU
    FCOMIP  ST(0), ST(1)            ; Comparar 1.0 con x
    JAE     caso_base               ; Si 1.0 >= x, ir al caso base

    ; --- x > 1.0 ---
    FLD1							; Meter 1.0 en la FPU
    FSUBP   ST(1), ST(0)            ; ST(0) = x - 1.0
    FSTP    QWORD PTR [EBP-8]       ; Guardar (x - 1.0) en la variable local y vaciar la FPU
    PUSH    DWORD PTR [EBP-4]       ; Pasar (x - 1.0) como argumento
    PUSH    DWORD PTR [EBP-8]       ; (en dos partes de 32 bits porque es un double)
    CALL    Mi_fact                 ; Llamada recursiva y el resultado queda en ST(0)
    ADD     ESP, 8                  ; Limpiar el argumento de la pila
    FMUL    QWORD PTR [EBP+8]       ; ST(0) = factorial(x-1) * x
    JMP     fin						; Salta al cierre del programa

caso_base:
    FSTP    ST(0)                   ; Descartar x de la FPU
    FLD1                            ; Meter 1.0 en la FPU

; --- Fin del programa ---
fin:
    MOV     ESP, EBP
    POP     EBP
    RET
Mi_fact ENDP

END
