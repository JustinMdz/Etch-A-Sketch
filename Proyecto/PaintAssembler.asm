.model small 
.stack 100h

.data 
;LABELS
  COLORS BYTE "COLORS$" 
  CLEAR BYTE "CLEAR$"
  SAVE BYTE "SAVE$"
  LOAD BYTE "LOAD$"
  INSERT BYTE "INSERT$"
  FILENAME BYTE "File Name:$"

  COL DW ?
  FIL DW ?
  X DW 220
  Y DW 305

  SETPOSITION MACRO x, y
    MOV ah,02h
    MOV bh,0
    MOV dh, x 
    MOV dl,y
    INT 10h
  ENDM
  
  DRAW_PIXEL MACRO color, x, y
    MOV ah, 0CH
    MOV AL, color 
    MOV bh, 00
    MOV cx, x
    MOV dx, y
    INT 10H
  ENDM

  PRINTMESSAGE MACRO msg
    MOV ah,9
    MOV dx,OFFSET msg
    INT 21h 
  ENDM

.code
  ; Inicializacion
  MOV ax, @DATA
  MOV ds, ax

  MOV ah, 00;;color de fondo
  MOV al, 12H
  INT 10H

   ; -- Inicializa el mouse
  MOV ax, 00 
  INT 33h

  ; -- Muestra puntero del mouse en pantalla
  MOV ax, 01h 
  INT 33h

  ; Pinta palabras de cada cuadro
  SETPOSITION 1, 24
  PRINTMESSAGE COLORS

  SETPOSITION 24, 64
  PRINTMESSAGE CLEAR

  SETPOSITION 27, 64
  PRINTMESSAGE INSERT

  SETPOSITION 1, 64
  PRINTMESSAGE SAVE

  SETPOSITION 4, 64
  PRINTMESSAGE LOAD

  SETPOSITION 7, 62
  PRINTMESSAGE FILENAME

  ;Pintar areas para la zona de trabajo
  MOV cx, 400
  MOV COL, 20
  Sketch_horizontal: 
    PUSH cx
    DRAW_PIXEL 15, COL, 140
    DRAW_PIXEL 15, COL, 470
    INC COL 
    POP cx
  LOOP Sketch_horizontal

  MOV cx, 331
  MOV FIL, 140
  Sketch_vertical:
    PUSH cx
    DRAW_PIXEL 15 , 20, FIL
    DRAW_PIXEL 15 420, FIL
    INC FIL     
    POP cx
  LOOP Sketch_vertical

  ; Area de eleccion de colores 
  MOV COL, 20
  MOV cx, 400
  Colores_Horizontal:
    PUSH cx
    DRAW_PIXEL 1, COL, 10
    DRAW_PIXEL 14, COL, 130
    INC COL
    POP cx
  LOOP Colores_Horizontal

  MOV FIL, 10
  MOV cx, 120
  Colores_Vertical:
    PUSH cx
    DRAW_PIXEL 4, 20, FIL
    DRAW_PIXEL 2, 420, FIL
    INC FIL     
    POP cx
  LOOP Colores_Vertical

  ; Area del boton guardar bosquejo
  MOV COL, 485
  MOV cx, 100
  Guardar_Horizontal: 
    PUSH cx
    DRAW_PIXEL 11, COL, 5
    DRAW_PIXEL 11, COL, 45
    INC COL
    POP cx
  LOOP Guardar_Horizontal
  
  MOV FIL, 5
  MOV cx, 40
  Guardar_Vertical:
    PUSH cx
    DRAW_PIXEL 11, 485, FIL
    DRAW_PIXEL 11, 585, FIL
    INC FIL
    POP cx 
  LOOP Guardar_Vertical

  ; Area del boton cargar imagen
  MOV COL, 485
  MOV cx, 100
  Cargar_Horizontal:
    PUSH cx
    DRAW_PIXEL 4, COL, 55
    DRAW_PIXEL 4, COL, 95
    INC COL
    POP cx
  LOOP Cargar_Horizontal

  MOV FIL, 55
  MOV cx, 40
  Cargar_Vertical:
    PUSH cx
    DRAW_PIXEL 4, 485, FIL
    DRAW_PIXEL 4, 585, FIL
    INC FIL
    POP cx
  LOOP Cargar_Vertical

 ; Area del nombre asignado al bosquejo
  MOV COL, 485 
  MOV cx, 100
  Nombre_Horizontal:
    PUSH cx
    DRAW_PIXEL 5, COL, 105
    DRAW_PIXEL 5, COL, 145
    INC COL
    POP cx
  LOOP Nombre_Horizontal

  MOV FIL, 105
  MOV cx, 40
  Nombre_Vertical:
    PUSH cx
    DRAW_PIXEL 5, 485, FIL
    DRAW_PIXEL 5, 585, FIL
    INC FIL
    POP cx 
  LOOP Nombre_Vertical

  ; Area del boton limpiar bosquejo
  MOV COL, 485
  MOV cx, 100
  Limpiar_Horizontal:
    PUSH cx
    DRAW_PIXEL 12, COL, 370
    DRAW_PIXEL 12, COL, 410
    INC COL
    POP cx
  LOOP Limpiar_Horizontal

  MOV FIL, 370
  MOV cx, 40
  Limpiar_Vertical:
    PUSH cx
    DRAW_PIXEL 12, 485, FIL
    DRAW_PIXEL 12, 585, FIL
    INC FIL
    POP cx
  LOOP Limpiar_Vertical

  ; Area del boton para insertar imagen
  MOV COL, 485
  MOV cx, 100
  Insertar_Horizontal:
    PUSH cx
    DRAW_PIXEL 10, COL, 420
    DRAW_PIXEL 10, COL, 460
    INC COL
    POP cx
  LOOP Insertar_Horizontal
MOV FIL, 420
  MOV cx, 40
  Insertar_Vertical:
    PUSH cx
    DRAW_PIXEL 10, 485, FIL
    DRAW_PIXEL 10, 585, FIL
    INC FIL
    POP cx
  LOOP Insertar_Vertical
  
  ciclo:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    CALL ChecMouse
    CALL Leer_tecla 
    DRAW_PIXEL 12, X, Y
    JMP ciclo

  ; Terminar el programa
  MOV ah, 4CH
  INT 21H  

   ChecMouse PROC far
    ; Verificar si se ha hecho clic con el botón izquierdo del mouse
    MOV ax, 03h   ; Función 03h de la interrupción 33h: Obtener el estado de los botones y la posición del cursor
    INT 33h
    ; AX ahora contiene el estado de los botones del mouse
    ; CX contiene la posición X del cursor
    ; DX contiene la posición Y del cursor

    TEST bx, 01h  ; Verificar si el botón izquierdo del mouse está presionado (bit 0 de BX)
    JZ NoClick    ; Si no está presionado, saltar

    ; Guardar la posición del cursor en las variables X e Y
    MOV X, CX     ; Guardar la posición X del mouse
    MOV Y, DX     ; Guardar la posición Y del mouse


    NoClick:
    RET
ChecMouse ENDP


  Leer_tecla PROC far
    MOV ah, 00h ; Leer tecla
    INT 16h

    ; Comparar con los códigos de las teclas de dirección
    CMP ah, 48h    ; arriba
    JE Tcl_arriba

    CMP ah, 50h    ; abajo
    JE Tcl_abajo

    CMP ah, 4Bh    ; <-
    JE Tcl_izq

    CMP ah, 4Dh    ; ->
    JE Tcl_der

    RET

    Tcl_arriba:
        CMP Y, 31
        JLE Tcl_final   ; No moverse si está en el límite superior
        DEC Y
        JMP Tcl_final

    Tcl_abajo:
        CMP Y, 359
        JGE Tcl_final   ; No moverse si está en el límite inferior
        INC Y
        JMP Tcl_final

    Tcl_izq:
        CMP X, 21
        JLE Tcl_final   ; No moverse si está en el límite izquierdo
        DEC X
        JMP Tcl_final

    Tcl_der:
        CMP X, 419
        JGE Tcl_final   ; No moverse si está en el límite derecho
        INC X
        JMP Tcl_final

    Tcl_final:
        RET

  Leer_tecla ENDP

end


; ;; Limpiar pantalla con int 10h y AH=6
;   MOV AH, 6
;   MOV AL, 0
;   MOV BH, 0
;   MOV CH, 2 ; Coordenada Y inicial
;   MOV CL, 3 ; Coordenada X inicial
;   MOV DH, 21 ; Coordenada Y final
;   MOV DL, 51 ; Coordenada X final
;   INT 10H