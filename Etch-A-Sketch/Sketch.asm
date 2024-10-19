.model small
.stack 100h
.data
  msg            db 'Hello, World!', 0Dh, 0Ah, '$'  ; El mensaje termina con '$' para DOS interrupt
  COLOR_SELECTED db 4
  COLORS         db "COLORS$"
  CLEAR          db "CLEAR$"
  SAVE           db "SAVE$"
  LOAD           db "LOAD$"
  INSERT         db "INSERT$"
  FILENAME       db "File Name:$"
  XPOS           db "X:$"
  YPOS           db "Y:$"
  buffer         DB 6 DUP(0)                        ; Buffer para almacenar el número convertido a cadena (máximo 5 dígitos más '$')
  TEN            DW 10                              ; Valor constante 10 para la división
        

  COL            DW ?
  FIL            DW ?
  X              DW 220
  Y              DW 305
  SKETCH_X       DW 220
  SKETCH_Y       DW 305

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
main PROC
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

     SETPOSITION 21,61
     PRINTMESSAGE  XPOS

     SETPOSITION 22,61
     PRINTMESSAGE  YPOS

         ;Pintar los colores-----------------
   
    DRAW_SQUARE 5,10,2,3,1
    DRAW_SQUARE 15,20,2,3,2
    DRAW_SQUARE 25,30,2,3,3 
    DRAW_SQUARE 35,40,2,3,4 
    DRAW_SQUARE 45,50,2,3,5

    DRAW_SQUARE 5,10,5,6,6
    DRAW_SQUARE 15,20,5,6,10
    DRAW_SQUARE 25,30,5,6,13
    DRAW_SQUARE 35,40,5,6,14
    DRAW_SQUARE 45,50,5,6,15  

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

        ; Draw areas for the work zone
        DrawWorkZoneAreas:
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

     principal_Loop:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      CALL CheckMouse
      CALL read_Key
      CALL PRINT_COORDINATES
      CALL CLEAR_SCREEN
      jmp principal_Loop
      
       PRINT_COORDINATES PROC
      MOV AX, X
CALL NUM_TO_STRING
SETPOSITION 21, 68
PRINTMESSAGE buffer

MOV AX, Y
CALL NUM_TO_STRING
SETPOSITION 22, 68
PRINTMESSAGE buffer
PRINT_COORDINATES ENDP

 NUM_TO_STRING PROC
    ; Entrada: AX contiene el número a convertir
    ; Salida: DS:SI apunta a la cadena convertida (buffer temporal)

    PUSH DX        ; Guardar registros
    PUSH CX
    PUSH BX

    MOV SI, OFFSET buffer ; Apuntar a donde almacenaremos la cadena
    MOV CX, 0            ; Inicializar contador de dígitos

    CMP AX, 0
    JNE ConvertLoop
    MOV BYTE PTR [SI], '0' ; Si el número es 0, manejar caso especial
    INC SI
    JMP EndConvert

ConvertLoop:
    MOV DX, 0            ; Limpiar DX para la división
    DIV TEN              ; Dividir AX entre 10 (guardando cociente en AX y residuo en DX)
    ADD DL, '0'          ; Convertir el dígito a carácter ASCII
    PUSH DX              ; Almacenar el dígito
    INC CX               ; Aumentar el contador de dígitos
    TEST AX, AX          ; Ver si hemos terminado (AX == 0)
    JNZ ConvertLoop

PopDigits:
    POP DX               ; Recuperar el dígito en orden inverso
    MOV [SI], DL         ; Almacenar en la cadena
    INC SI               ; Mover el puntero de la cadena
    LOOP PopDigits        ; Repetir hasta que CX == 0

EndConvert:
    MOV BYTE PTR [SI], '$' ; Terminar la cadena con '$'
    INC SI                ; Ajustar el puntero de la cadena

    POP BX                ; Restaurar registros
    POP CX
    POP DX
    RET
NUM_TO_STRING ENDP

       CheckMouse PROC 
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

      CALL CheckInterSketchZone
      CALL CheckClearZone
      CALL CheckClick


      NoClick:
      RET
  CheckMouse ENDP

  CheckInterSketchZone PROC
    CMP X, 20
    JL CheckInterSketchZoneEnd
    CMP X, 420
    JG CheckInterSketchZoneEnd
    CMP Y, 140
    JL CheckInterSketchZoneEnd
    CMP Y, 470
    JG CheckInterSketchZoneEnd
          MOV AX,X
      MOV SKETCH_X,AX
      MOV BX,Y
      MOV SKETCH_Y,BX

CheckInterSketchZoneEnd:

CheckInterSketchZone ENDP 

CheckClearZone PROC
    CMP X, 485
    JL ENDZONE
    CMP X, 585
    JG ENDZONE
    CMP Y, 370
    JL ENDZONE
    CMP Y, 410
    JG ENDZONE
   
   CALL PINTARLIMPIAR

ENDZONE:
RET
  
CheckClearZone ENDP

  PINTARLIMPIAR PROC
 DRAW_SQUARE 02,52,08,29,0
    MOV cx, 400
    MOV COL, 20
    Sketch_horizontal1: 
      PUSH cx
      DRAW_PIXEL 15, COL, 140
      DRAW_PIXEL 15, COL, 470
      INC COL 
      POP cx
    LOOP Sketch_horizontal1

    MOV cx, 331
    MOV FIL, 140
    Sketch_vertical1:
      PUSH cx
      DRAW_PIXEL 15, 20, FIL
      DRAW_PIXEL 15, 420, FIL
      INC FIL     
      POP cx
    LOOP Sketch_vertical1

    ; Color selection area
    MOV COL, 20
    MOV cx, 400
    Colors_Horizontal1:
      PUSH cx
      DRAW_PIXEL 1, COL, 10
      DRAW_PIXEL 14, COL, 130
      INC COL
      POP cx
    LOOP Colors_Horizontal1

    MOV FIL, 10
    MOV cx, 120
    Colors_Vertical1:
      PUSH cx
      DRAW_PIXEL 4, 20, FIL
      DRAW_PIXEL 2, 420, FIL
      INC FIL     
      POP cx
    LOOP Colors_Vertical1
    PINTARLIMPIAR ENDP



      read_Key PROC 
      MOV ah, 01h         ; Leer estado de la tecla
      INT 16h

      JZ NoKeyFirstTwoTeclas           ; Si no se ha presionado ninguna tecla, saltar a No_key

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

      JMP NoKeyFirstTwoTeclas

  Tcl_up:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP SKETCH_Y, 141
      JLE Tcl_end         ; No moverse si está en el límite superior
      ; Verificar límites X también para evitar que pinte fuera del área
      CMP SKETCH_X, 21
      JL Tcl_end          ; No moverse si X está fuera del límite izquierdo
      CMP SKETCH_X, 419
      JG Tcl_end          ; No moverse si X está fuera del límite derecho
      DEC SKETCH_Y               ; Mover hacia arriba
      JMP Tcl_end

  Tcl_down:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP SKETCH_Y, 469
      JGE Tcl_end         ; No moverse si está en el límite inferior
      ; Verificar límites X también
      CMP SKETCH_X, 21
      JL Tcl_end          ; No moverse si X está fuera del límite izquierdo
      CMP SKETCH_X, 419
      JG Tcl_end          ; No moverse si X está fuera del límite derecho
      INC SKETCH_Y               ; Mover hacia abajo
      JMP Tcl_end

      NoKeyFirstTwoTeclas:
      RET

  Tcl_left:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP SKETCH_X, 21
      JLE Tcl_end         ; No moverse si está en el límite izquierdo
      ; Verificar límites Y también
      CMP SKETCH_Y, 141
      JL Tcl_end          ; No moverse si Y está fuera del límite superior
      CMP SKETCH_Y, 469
      JG Tcl_end          ; No moverse si Y está fuera del límite inferior
      DEC SKETCH_X               ; Mover hacia la izquierda
      JMP Tcl_end

  Tcl_right:
      ; Verificar si está dentro del rango permitido antes de mover
      CMP SKETCH_X, 419
      JGE Tcl_end         ; No moverse si está en el límite derecho
      ; Verificar límites Y también
      CMP SKETCH_Y, 141
      JL Tcl_end          ; No moverse si Y está fuera del límite superior
      CMP SKETCH_Y, 469
      JG Tcl_end          ; No moverse si Y está fuera del límite inferior
      INC SKETCH_X               ; Mover hacia la derecha
      JMP Tcl_end

  Tcl_end:
      ; Solo pintar si X y Y están dentro de los límites correctos
      CMP SKETCH_X, 21
      JL No_draw          ; No pintar si X está fuera del límite izquierdo
      CMP SKETCH_X, 419
      JG No_draw          ; No pintar si X está fuera del límite derecho
      CMP SKETCH_Y, 141
      JL No_draw          ; No pintar si Y está fuera del límite superior
      CMP SKETCH_Y, 469
      JG No_draw          ; No pintar si Y está fuera del límite inferior
      DRAW_PIXEL COLOR_SELECTED, SKETCH_X, SKETCH_Y

      MOV AX,SKETCH_X
      MOV X,AX
      MOV bx,SKETCH_Y
      MOV Y,bx
      JMP Done

  No_draw:
      ; Si no está en los límites, no pintar nada
      JMP Done

  Done:
      RET

  No_key:
      RET

  read_Key ENDP

      CLEAR_SCREEN PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH BX

    MOV AX, 0600h   
    MOV BH, 00h     
    MOV CX, 153Fh   
    MOV DX, 164Fh    
    INT 10h         

    POP BX
    POP DX
    POP CX
    POP AX
    RET
CLEAR_SCREEN ENDP


CheckClick PROC
CheckColor1:
    CMP X, 040
    JL CheckColor2
    CMP X, 086
    JG CheckColor2
    CMP Y, 032
    JL CheckColor2
    CMP Y, 063
    JG CheckColor2
    MOV COLOR_SELECTED, 1
    JMP EndCheck1

CheckColor2:
    CMP X, 120
    JL CheckColor3
    CMP X, 166
    JG CheckColor3
    CMP Y, 032
    JL CheckColor3
    CMP Y, 063
    JG CheckColor3
    MOV COLOR_SELECTED, 2
    JMP EndCheck1


CheckColor3:
CMP X, 200
    JL CheckColor4
    CMP X, 246
    JG CheckColor4
    CMP Y, 032
    JL CheckColor4
    CMP Y, 063
    JG CheckColor4
    MOV COLOR_SELECTED, 3
    JMP EndCheck1

    CheckColor4:
CMP X, 280
    JL CheckColor5
    CMP X, 326
    JG CheckColor5
    CMP Y, 032
    JL CheckColor5
    CMP Y, 063
    JG CheckColor5
    MOV COLOR_SELECTED, 4
    JMP EndCheck1


    CheckColor5:
     CMP X, 406
    JG CheckColor6;exist fast intercambiar a evaluar la derecha primero
    CMP Y, 032
    JL CheckColor6
    CMP X, 360
    JL CheckColor6
    CMP Y, 063
    JG CheckColor6
    MOV COLOR_SELECTED, 5
    JMP EndCheck1

EndCheck1:
JMP EndCheck


    CheckColor6:
    CMP X, 040
    JL EndCheck2
    CMP X, 086
    JG CheckColor7
    CMP Y, 080
    JL EndCheck2
    CMP Y, 110
    JG EndCheck2
    MOV COLOR_SELECTED, 6
    JMP EndCheck

CheckColor7:
    CMP X, 120
    JL EndCheck2
    CMP X, 166
    JG CheckColor8
    CMP Y, 080
    JL EndCheck2
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 10
    JMP EndCheck2
 
 EndCheck2:
JMP EndCheck

CheckColor8:
CMP X, 200
    JL EndCheck
    CMP X, 246
    JG CheckColor9
    CMP Y, 080
    JL EndCheck
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 13
    JMP EndCheck

    CheckColor9:
CMP X, 280
    JL EndCheck
    CMP X, 326
    JG CheckColor10
    CMP Y, 080
    JL EndCheck
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 14
    JMP EndCheck


    CheckColor10:
    CMP X, 360
    JL EndCheck
    CMP X, 406
    JG EndCheck
    CMP Y, 080
    JL EndCheck
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 15
    JMP EndCheck

    

EndCheck:
    RET
CheckClick ENDP
 

main ENDP
end main


  ; ;; Clear screen with int 10h and AH=6
  ;   MOV AH, 6
  ;   MOV AL, 0
  ;   MOV BH, 0
  ;   MOV CH, 2 ; Initial Y coordinate
  ;   MOV CL, 3 ; Initial X coordinate
  ;   MOV DH, 21 ; Final Y coordinate
  ;   MOV DL, 51 ; Final X coordinate
  ;   INT 10H
