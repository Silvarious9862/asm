.model small
.stack 100h
.data
    array       dw (?) dup 10
    arraylen    equ 9
    msg         db "Insertsort. Print array: $"
    msg2        db "Sorted: $"
    i           dw ?
    j           dw ?
    tmp         dw ?
    
.code
 
exchange proc   
    ; tmp = array[j-1] 
    mov bx, array[si]
    mov tmp, bx
    
    ; array[j-1] = array[j]
    mov bx, array[di]
    mov array[si], bx
    
    ; array[j] = tmp
    mov bx, tmp
    mov array[di], bx
    
    ret
exchange endp    
    
main:
    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    
    
    mov ah, 9h
    lea dx, msg
    int 21h
    
           
    xor si, si
    mov cx, arraylen
    inc cx
    input:
    mov ah, 01h
    int 21h 
    sub al, 30h
    mov ah, 00h
    mov array[si], ax
    add si, 2
    loop input
    
    mov cx, arraylen
    inc cx
    mov si, 0
    
    
    mov ah, 2h
    mov dx,0ah
    int 21h
    mov dx,0dh
    int 21h 
    print:
    
    mov dx, array[si]
    add dl, 30h
    int 21h
    
    mov dx, 20h
    int 21h
    add si,2
    loop print
    
    mov dx,0ah
    int 21h
    mov dx,0dh
    int 21h 





    mov i, 1
    mov cx, arraylen
    
    loop_i:
    mov ax, i
    mov j, ax
         
        loop_j:
        mov ax, j   ; di = array[j]
        cmp ax, 0
        jle  checkfail
        
        mov di, j   ; si = array[j-1]
        mov si, j
        dec si
        shl si, 1
        shl di, 1
        
        
        mov bx, array[si]
        cmp bx, array[di]
        jle checkfail
        
        call exchange
        
        dec j
        jmp loop_j
        
         
   
    checkfail:
    inc i
    loop loop_i
    
    ;---------------------------------
    mov ah, 9h
    lea dx, msg2
    int 21h
    
    mov cx, arraylen
    inc cx
    mov si, 0
    
    print2:
    mov ah, 2h
    mov dx, array[si]
    add dl, 30h
    int 21h
    
    mov dx, 20h
    int 21h
    add si, 2
    loop print2
    
    mov ax, 4c00h
    int 21h
    
    


end main