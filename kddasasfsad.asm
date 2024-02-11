.model small
.stack 256h
.data    
    msg db 'input array',0AH,0DH,"$" 
    arr dw 100 dup (?)
    ten db 10
    two db 2
    res dw 0  
    newline db ' ',0Ah, 0Dh, '$'     
    min1 dw 0
    min2 dw 0
    min3 dw 0   
    arrlen db 0 
    loopc db 0
.code 


start:

mov ax, @data
mov ds, ax
mov dx, offset msg
mov ah, 09h  
int 21h      

xor bx, bx
xor ax, ax
mov si, 0
xor cx, cx
;=========== input
P1:
push ax
mov ah, 01h
int 21h
cmp al, 20h
je space
cmp al, 0Dh
je inputEnd
;not_enter:
sub al, 30h
mov bl, al
pop ax
mul ten
add ax, bx
jmp P1
space:
pop ax
mov arr[si], ax
xor ax, ax 
add si, 2
inc cl
jmp P1

inputEnd:
mov ah, 02h
mov dl, 0Ah
int 21h
mov dl, 0Dh
int 21h

pop ax
mov arr[si], ax
xor ax, ax 
inc cl
;==== task
mov ax,si 
mov dx,2
div dl 
mov arrlen,al
xor si, si
mov dx,0
mov bx,0
mov ax,3
mov loopc,al          
          loop1:
            mov cl,arrlen
            loop2:
                mov ax,arr[si]
                add si,2
                cmp ax,dx
                jge skipl2                
                cmp ax,bx
                jl skipl2
                mov dx,ax
                                
                skipl2:
             loop loop2
             mov bx,dx 
             push bx 
             mov ax,0
             mov al,loopc
             sub al,1
             mov loopc,al
             cmp al,0
             je endsearch
             jmp loop1
          
endsearch:          
pop bx
mov min1,bx
pop bx 
mov min2,bx
pop bx
mov min3,bx          
jmp output11          
          
          
          
          
sub cl, 1  
push cx
xor dx, dx
mov dx, arr[si]
mov min1, dx
add si, 2
l1:
    mov ax, arr[si]
    cmp min1, ax
    jle next
    mov min1, ax
    ;mov dx, min1
    ;cmp dx, min2
    ;jle next
    ;mov min2, dx
    ;mov dx, min2
    ;cmp min3, dx
    ;jle next
    ;mov min3, dx
    next:     
    add si, 2
loop l1
pop cx 

xor si, si
mov dx, 0xFFFFh
mov min2, dx
inc cx  
push cx
l2:
    mov ax, arr[si]
    
    cmp ax, min1
    jle skip2
    cmp min2, ax
    jg  skip2
    
    mov min2, ax
    skip2:
    add si, 2
loop l2
pop cx

xor si, si
mov dx, min2

mov min3, dx   
l3:
    mov ax, arr[si]
    cmp ax, min3
    jge skip3
    cmp ax, min2
    jle skip3
    mov min2, ax
    skip3:
    add si, 2
loop l3
 
;================= output
output11: 



mov dx, offset newline
mov ah, 09H
int 21h    
mov ax, cx



;mov ax, res  
mov bl, 100
nextdigit:
    xor dx, dx
    cmp ax, 0
    jz stop_print:
    cmp bl, 0
    jz stop_print:
    div bl  
    mov ch, ah
    cmp al, 0
    jz skip
    mov bh, ah    
    mov dl, al
    add dl, 30H
    mov dh, 0
    mov ch, ah
    mov ah, 02h
    int 21h
    skip:
    mov al, bl
    mov bh, ch
    mov ah, 0
    div ten
    mov bl, al
    mov al, bh

jmp nextdigit
stop_print:
mov ax, 4c00h
int 21h


end start