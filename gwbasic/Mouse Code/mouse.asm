;Mouse Code for GW-BASIC By RetroNick
;Created April 6 - 2022
;Last Update April 8 - 2022
;MIT License 
;See video Link

code segment
assume cs:code,ds:code,es:code,ss:code

MOUSE PROC FAR
          PUSH   BP
          MOV    BP,SP

          MOV    SI,[BP + 12]   ;Set AX register with passed AX% value
          MOV    AX,[SI]
          
          CMP    AX,0           ;init
          JE Init
          CMP    AX,1           ;show
          JE ShowOrHide
          CMP    AX,2           ;hide
          JE ShowOrHide
          CMP    AX,3           ;get status pos/mouse button 
          JE Status
          CMP    AX,9           ;set mouse shape/hot spot
          JE Shape
          JMP Finish            ;no more options jump to finish
          
          Init:
          INT 33h               ;AX% value is already set   
          MOV    SI,[BP + 12]   ;AX% return value - none zero = mouse present
          MOV    [SI],BX
          MOV    SI,[BP + 10]   ;BX% return value - # of buttons
          MOV    [SI],BX
          JMP Finish
          
          ShowOrHide:           ;same action for show or hide
          INT 33h               ;AX% value is already set   
          JMP Finish
          
          Status:
          INT 33h               ;AX% value is already set   
          MOV    SI,[BP + 10]   ;BX% - return Button Status Left/Right/Centre
          MOV    [SI],BX
          MOV    SI,[BP + 8]    
          MOV    [SI],CX        ;CX% - return Horizontal 
          MOV    SI,[BP + 6]    
          MOV    [SI],DX        ;DX% - return Vertical
          JMP Finish
          
          Shape:
          MOV    SI,[BP + 6]    ;DX%
          MOV    DX,[SI]
          MOV    SI,[BP + 8]    ;CX%
          MOV    CX,[SI]
          MOV    SI,[BP + 10]   ;BX%
          MOV    BX,[SI]
          INT 33h              ;AX% value is already set   
          ;JMP Finish - we don't need the final jump or do we? Leaving it here to remind me
          
          Finish:
          POP    BP
          RET    8
MOUSE ENDP

code ends
END
