;RetroNick's Asm Test/Learning Code
;cpu     286
;bits    16
;segment data 

segment CODE

global PassN
global ChangeN
global ReturnN
global ReturnN2

PassN: 
push bp
mov bp,sp
sub sp,0x40    ; 64 bytes of local stack space

mov ax,[bp+10] ; copy n1 value to si 
add ax,10      ; add 10 ax

mov si,[bp+6]  ; copy n2 to  si  
mov [si],ax    ; change n2 variable value - take value from ax

mov sp,bp ; undo "sub sp,0x40" above
pop bp
retf 4

ChangeN: 
push bp
mov bp,sp
sub sp,0x40 ; 64 bytes of local stack space

mov si,[bp+10] ; first  parameter to procedure
mov bx,[si]
add bx,10
mov [si],bx    

mov si,[bp+6] ; second parameter to procedure
mov bx,[si]
add bx,10
mov [si],bx

mov sp,bp ; undo "sub sp,0x40" above
pop bp
retf 4 

ReturnN: 
push bp
mov bp,sp
sub sp,0x40 ; 64 bytes of local stack space

mov si,[bp+6]  ; n1 - first  parameter in function
mov ax,si      ; move n1/si value to ax - why si not in [si]? - don't know
add ax,10      ; add 10 to ax - ax register is the return value to function

; some more code
mov sp,bp ; undo "sub sp,0x40" above
pop bp
retf 2

ReturnN2: 
push bp
mov bp,sp
sub sp,0x40 ; 64 bytes of local stack space

mov si,[bp+6]  ; n1 - first  parameter in function
mov ax,si      ; move n1/si value to ax - why si not in [si]? - don't know
add ax,10      ; add 10 to ax - ax register is the return value to function
mov dx,1111    ; dx is the 2 High bytes, and AX is the 2 low bytes of the longint return
; some more code
mov sp,bp ; undo "sub sp,0x40" above
pop bp
retf 2