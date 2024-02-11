 ; In 1-tier array find the sum of the numbers in given borders

.model small
.stack 100h
.data
    msg1    db  "Input your array: $"  
    msg2    db  "Input low border: $"
    msg3    db  "Input high border: $"
    msg4    db  "Answer is: $"
  
    point       dw  0
    high_border dw  0
    low_border  dw  0
    
   
    buffer  db 6, 7 dup (?)
    array   dw 10 dup (?)
.code 

in_int proc
    push cx
    xor ax, ax
    mov ah, 0Ah
    xor di, di
    mov dx, offset buffer 
    int 21h
    
    mov dl, 0Ah
    mov ah, 02h
    int 21h 
    mov dl, 0Dh
    int 21h
    
    mov si, offset buffer+2
    mov ax, 0
    mov bx, 10 
    
    mark:
    mov cl, [si]
    cmp cl, 0Dh
    jz end_in
    
    sub cl, 30h
    mul bx
    add ax, cx
    inc si
    jmp mark
        
    
    
    end_in:
    pop cx 
    ret
in_int endp    

out_int proc
    xor cx, cx
    mov bx, 10
    mark2:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax 
    jnz mark2 
    
    mov ah, 02h
    loop_out:
    pop dx
    add dl, 30h
    int 21h
    loop loop_out
    
    ret
out_int endp
 
start:
    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    mov ah, 09h
    mov dx, offset msg1
    int 21h
      
    mov cx, 10
  loop_int:  
    call in_int 
    mov si, point
    mov array[si], ax
    add point, 2
  loop loop_int 
    
    ;; input borders
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    call in_int
    mov low_border, ax
    xor ax, ax
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    call in_int
    mov high_border, ax  
    
   
    ;; count sum   
    xor ax, ax
    mov point, 0
    checksum: 
    xor bx, bx
    
    mov si, point
    cmp si, 14h
    je stop_parse
    mov bx, array[si]
    cmp bx, low_border
    jl  skip
    cmp bx, high_border
    jg  skip
    
    add ax, bx
    
    skip:
    add point, 2
    
    jmp checksum 
    
    
    ;; output sum
  stop_parse:  
    push ax
    mov ah, 09h
    mov dx, offset msg4
    int 21h  
    pop ax
    call out_int
    
  
    
    
    
    
exit:    
    mov ax, 4c00h
    int 21h
    
end start        