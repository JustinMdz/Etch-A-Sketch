  .model small 
  .stack 100h

  .data 
  ; LABELS
    COLOR_SELECTED BYTE 2
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
      MOV ah, 02h
      MOV bh, 0
      MOV dh, x 
      MOV dl, y
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

      DRAW_SQUARE MACRO x_inicial, x_final, y_inicial, y_final, color
      MOV AH, 6          ; Función para scroll hacia arriba (limpiar pantalla)
      MOV AL, 0          ; Número de líneas a desplazar (0 significa llenar con el color)
      MOV BH, color      ; Color de fondo
      MOV CH, y_inicial  ; Coordenada Y inicial
      MOV CL, x_inicial  ; Coordenada X inicial
      MOV DH, y_final    ; Coordenada Y final
      MOV DL, x_final    ; Coordenada X final
      INT 10H            ; Llamada a la interrupción del BIOS de video
  ENDM

  .code
    ; Initialization
    MOV ax, @DATA
    MOV ds, ax

    MOV ah, 00 ;; background color
    MOV al, 12H
    INT 10H

    ; -- Initialize the mouse
    MOV ax, 00 
    INT 33h

    ; -- Show mouse pointer on screen
    MOV ax, 01h 
    INT 33h

    ; Print labels for each box
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

    ;Pintar los colores-----------------
    ;Pintar los colores
    DRAW_SQUARE 5,10,2,3,1
    DRAW_SQUARE 5,10,5,6,2

    DRAW_SQUARE 15,20,2,3,3
    DRAW_SQUARE 15,20,5,6,4

    DRAW_SQUARE 25,30,2,3,5
    DRAW_SQUARE 25,30,5,6,4
    
    DRAW_SQUARE 35,40,2,3,10
    DRAW_SQUARE 35,40,5,6,13

    DRAW_SQUARE 45,50,2,3,14
    DRAW_SQUARE 45,50,5,6,15

    ; Draw areas for the work zone
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
      DRAW_PIXEL 15, 20, FIL
      DRAW_PIXEL 15, 420, FIL
      INC FIL     
      POP cx
    LOOP Sketch_vertical

    ; Color selection area
    MOV COL, 20
    MOV cx, 400
    Colors_Horizontal:
      PUSH cx
      DRAW_PIXEL 1, COL, 10
      DRAW_PIXEL 14, COL, 130
      INC COL
      POP cx
    LOOP Colors_Horizontal

    MOV FIL, 10
    MOV cx, 120
    Colors_Vertical:
      PUSH cx
      DRAW_PIXEL 4, 20, FIL
      DRAW_PIXEL 2, 420, FIL
      INC FIL     
      POP cx
    LOOP Colors_Vertical

    ; Save button area
    MOV COL, 485
    MOV cx, 100
    Save_Horizontal: 
      PUSH cx
      DRAW_PIXEL 11, COL, 5
      DRAW_PIXEL 11, COL, 45
      INC COL
      POP cx
    LOOP Save_Horizontal
    
    MOV FIL, 5
    MOV cx, 40
    Save_Vertical:
      PUSH cx
      DRAW_PIXEL 11, 485, FIL
      DRAW_PIXEL 11, 585, FIL
      INC FIL
      POP cx 
    LOOP Save_Vertical

    ; Load button area
    MOV COL, 485
    MOV cx, 100
    Load_Horizontal:
      PUSH cx
      DRAW_PIXEL 4, COL, 55
      DRAW_PIXEL 4, COL, 95
      INC COL
      POP cx
    LOOP Load_Horizontal

    MOV FIL, 55
    MOV cx, 40
    Load_Vertical:
      PUSH cx
      DRAW_PIXEL 4, 485, FIL
      DRAW_PIXEL 4, 585, FIL
      INC FIL
      POP cx
    LOOP Load_Vertical

  ; File name area
    MOV COL, 485 
    MOV cx, 100
    Name_Horizontal:
      PUSH cx
      DRAW_PIXEL 5, COL, 105
      DRAW_PIXEL 5, COL, 145
      INC COL
      POP cx
    LOOP Name_Horizontal

    MOV FIL, 105
    MOV cx, 40
    Name_Vertical:
      PUSH cx
      DRAW_PIXEL 5, 485, FIL
      DRAW_PIXEL 5, 585, FIL
      INC FIL
      POP cx 
    LOOP Name_Vertical

    ; Clear button area
    MOV COL, 485
    MOV cx, 100
    Clear_Horizontal:
      PUSH cx
      DRAW_PIXEL 12, COL, 370
      DRAW_PIXEL 12, COL, 410
      INC COL
      POP cx
    LOOP Clear_Horizontal

    MOV FIL, 370
    MOV cx, 40
    Clear_Vertical:
      PUSH cx
      DRAW_PIXEL 12, 485, FIL
      DRAW_PIXEL 12, 585, FIL
      INC FIL
      POP cx
    LOOP Clear_Vertical

    ; Insert button area
    MOV COL, 485
    MOV cx, 100
    Insert_Horizontal:
      PUSH cx
      DRAW_PIXEL 10, COL, 420
      DRAW_PIXEL 10, COL, 460
      INC COL
      POP cx
    LOOP Insert_Horizontal

    MOV FIL, 420
    MOV cx, 40
    Insert_Vertical:
      PUSH cx
      DRAW_PIXEL 10, 485, FIL
      DRAW_PIXEL 10, 585, FIL
      INC FIL
      POP cx
    LOOP Insert_Vertical
    
    principal_Loop:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      CALL CheckMouse
      CALL read_Key
      jmp principal_Loop

    ; End the program
    MOV ah, 4CH
    INT 21H  

    CheckMouse PROC far
      ; Check if the left mouse button was clicked
      MOV ax, 03h   ; Function 03h of interrupt 33h: Get button state and cursor position
      INT 33h
      ; AX now contains the state of the mouse buttons
      ; CX contains the X position of the cursor
      ; DX contains the Y position of the cursor

      TEST bx, 01h  ; Check if the left mouse button is pressed (bit 0 of BX)
      JZ NoClick    ; If not pressed, jump

      ; Save the cursor position in variables X and Y
      MOV X, CX     ; Save the X position of the mouse
      MOV Y, DX     ; Save the Y position of the mouse

      NoClick:
      RET
  CheckMouse ENDP

  read_Key PROC far
      MOV ah, 01h         ; Leer estado de la tecla
      INT 16h

      JZ No_key           ; Si no se ha presionado ninguna tecla, saltar a No_key

      MOV ah, 00h         ; Leer la tecla
      INT 16h

      ; Verificar los códigos de las teclas de dirección
      CMP ah, 48h         ; arriba
      JE Tcl_up

      CMP ah, 50h         ; abajo
      JE Tcl_down

      CMP ah, 4Bh         ; izquierda
      JE Tcl_left

      CMP ah, 4Dh         ; derecha
      JE Tcl_right

      JMP No_key

  Tcl_up:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP Y, 141
      JLE Tcl_end         ; No moverse si está en el límite superior
      ; Verificar límites X también para evitar que pinte fuera del área
      CMP X, 21
      JL Tcl_end          ; No moverse si X está fuera del límite izquierdo
      CMP X, 419
      JG Tcl_end          ; No moverse si X está fuera del límite derecho
      DEC Y               ; Mover hacia arriba
      JMP Tcl_end

  Tcl_down:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP Y, 469
      JGE Tcl_end         ; No moverse si está en el límite inferior
      ; Verificar límites X también
      CMP X, 21
      JL Tcl_end          ; No moverse si X está fuera del límite izquierdo
      CMP X, 419
      JG Tcl_end          ; No moverse si X está fuera del límite derecho
      INC Y               ; Mover hacia abajo
      JMP Tcl_end

  Tcl_left:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP X, 21
      JLE Tcl_end         ; No moverse si está en el límite izquierdo
      ; Verificar límites Y también
      CMP Y, 141
      JL Tcl_end          ; No moverse si Y está fuera del límite superior
      CMP Y, 469
      JG Tcl_end          ; No moverse si Y está fuera del límite inferior
      DEC X               ; Mover hacia la izquierda
      JMP Tcl_end

  Tcl_right:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP X, 419
      JGE Tcl_end         ; No moverse si está en el límite derecho
      ; Verificar límites Y también
      CMP Y, 141
      JL Tcl_end          ; No moverse si Y está fuera del límite superior
      CMP Y, 469
      JG Tcl_end          ; No moverse si Y está fuera del límite inferior
      INC X               ; Mover hacia la derecha
      JMP Tcl_end

  Tcl_end:
      ; Solo pintar si X y Y están dentro de los límites correctos
      CMP X, 21
      JL No_draw          ; No pintar si X está fuera del límite izquierdo
      CMP X, 419
      JG No_draw          ; No pintar si X está fuera del límite derecho
      CMP Y, 141
      JL No_draw          ; No pintar si Y está fuera del límite superior
      CMP Y, 469
      JG No_draw          ; No pintar si Y está fuera del límite inferior
      DRAW_PIXEL COLOR_SELECTED, X, Y
      JMP Done

  No_draw:
      ; Si no está en los límites, no pintar nada
      JMP Done

  Done:
      RET

  No_key:
      RET

  read_Key ENDP



  end

  ; ;; Clear screen with int 10h and AH=6
  ;   MOV AH, 6
  ;   MOV AL, 0
  ;   MOV BH, 0
  ;   MOV CH, 2 ; Initial Y coordinate
  ;   MOV CL, 3 ; Initial X coordinate
  ;   MOV DH, 21 ; Final Y coordinate
  ;   MOV DL, 51 ; Final X coordinate
  ;   INT 10H
