;Set Vga Palette Code for GW-BASIC By RetroNick
;Created April 16 - 2022
;Last Update April 16 - 2022
;MIT License 
;See video Link

code segment
assume cs:code,ds:code,es:code,ss:code

SETRGB PROC FAR
          PUSH   BP
          MOV    BP,SP

          MOV    SI,[BP + 12]   ;Color N
          MOV    BL,[SI]
          MOV    BH,[SI]
          MOV    AH,10h
          MOV    AL,0h
          INT 10h 

          MOV    AH,10h
          MOV    AL,10h
          MOV    BX,[SI]        ;Color N

          MOV    SI,[BP + 10]   ;R
          MOV    DH,[SI]
          
          MOV    SI,[BP + 8]    ;G
          MOV    CH,[SI]

          MOV    SI,[BP + 6]    ;B
          MOV    CL,[SI]
          INT 10h 

          POP    BP
          RET    8
SETRGB ENDP

code ends
END
