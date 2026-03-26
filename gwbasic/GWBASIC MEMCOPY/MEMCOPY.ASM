;Fast Memory Copy - Code for GW-BASIC By RetroNick (with Claude)
;Format: Call MEMCOPY(SRC%,DST%,CNT%) from GW-BASIC
;SRC% = Source address (from VARPTR)
;DST% = Destination address (from VARPTR)
;CNT% = Number of bytes to copy
;
;Compile with TASM: tasm memcopy.asm
;Link with TLINK:   tlink memcopy.obj
;Convert:           exe2bin memcopy.exe memcopy.com
;Convert:           bin2bsv memcopy.com memcopy.bsv
;
;from GW-BASIC:
;
;10 DIM MC%(19)
;20 DEF SEG
;30 BLOAD "MEMCOPY.BSV",VARPTR(MC%(0))
;40 SRC%=VARPTR(A%(0)): DST%=VARPTR(B%(0)): CNT%=100
;50 MEMCOPY=VARPTR(MC%(0)):CALL MEMCOPY(SRC%,DST%,CNT%)
;
code segment
assume cs:code,ds:code,es:code,ss:code
MEMCOPY PROC FAR
        PUBLIC MEMCOPY
          PUSH   BP
          MOV    BP,SP
          PUSH   SI
          PUSH   DI

          MOV    BX,[BP + 10]   ;SRC address pointer
          MOV    SI,[BX]        ;SI = source address

          MOV    BX,[BP + 8]    ;DST address pointer
          MOV    DI,[BX]        ;DI = dest address

          MOV    BX,[BP + 6]    ;CNT byte count pointer
          MOV    CX,[BX]        ;CX = byte count

          PUSH   DS
          POP    ES             ;ES = DS (same segment)
          CLD                   ;forward direction
          SHR    CX,1           ;word count
          REP    MOVSW          ;copy words
          ADC    CX,CX          ;pick up odd byte
          REP    MOVSB          ;copy odd byte if any

          POP    DI
          POP    SI
          POP    BP
          RET    6              ;far return, clean 3 params
MEMCOPY ENDP
code ends
END
