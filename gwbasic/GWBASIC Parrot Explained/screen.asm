;Screen Code for GW-BASIC By RetroNick
;Created April 6 - 2022
;Last Update April 8 - 2022
;MIT License 
;See video Link

code segment
assume cs:code,ds:code,es:code,ss:code

SCVGA PROC FAR
          MOV    AX,12h
          INT    10h

          RET
SCVGA ENDP

code ends
END
