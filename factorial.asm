.model small
.stack 100h
.data
    number  db  ?
    msg     db  "Input your digit to count factorial: $", 0Dh, 0Ah
    msg2    db  "Answer is: $"   
    next_line   db  0Dh, 0Ah, '$'
    
.code
    
     

invite proc
    mov ah, 09h
    lea dx, msg
    int 21h   
    
    mov ah, 01h
    int 21h   
    
    sub al, 30h
    xor ah, ah
      
    ret  
invite endp 

factorial proc
    cmp ax, 1
    jle done
    
    mov bx, ax
    dec ax
    
    call factorial
    
    mul bx
    inc bx   
    
    done:
    ret
factorial endp

result proc
    mov bx, ax
    mov ah, 09h
    lea dx, next_line
    int 21h
    lea dx, msg2
    int 21h
    
    call number_to_print
                            
    ret
result endp            

number_to_print proc
    xor cx, cx
    xor dx, dx
    xor ax, ax
    mov ax, bx
    mov bx, 10
    
    loop1:
    xor dx, dx
    div bx 
    add dl, 30h
    push dx
    inc cx
    test ax, ax
    jnz loop1
    
    loop2:
    mov ah, 02h
    pop dx
    int 21h
    loop loop2
    
    
    
    ret
number_to_print endp
     

    main:
    mov ax, @data
    mov ds, ax
    xor ax, ax
          
    call invite
    call factorial
    call result
    
    
    exit:
    mov ah, 4ch
    int 21h    
end main 