.model small
.data    

array dw 60 dup (?)
array_size dw 0 
buff db 6,7 dup (?)

prompt_msg db "input string: $"
sorted_array_msg db "output array: $"  

flag dw 0
flag_switch dw 0  
point dw 0

error db "error input$"

.code

IntInput proc
    push cx 
    
    
    mov ah, 0ah
    xor di, di
    mov dx, offset buff
    int 21h 
    mov dl, 0ah
    mov ah, 2
    int 21h 
    mov dl, 0dh
    int 21h
    
    mov si, offset buff + 2
    cmp byte ptr[si], "-"
    jnz ii1
    mov di, 1
    inc si 
    
    ii1:
    xor ax, ax 
    xor cx, cx
    mov bx, 10
    
    ii2:
    mov cl, [si]
    cmp cl, 0dh
    jz endin
    
    cmp cl, '0'
    jb er
    cmp cl, '9'
    ja er
    sub cl, '0'
    mul bx
    add ax, cx
    inc si
    jmp ii2
    
    er:
    mov dx, offset error
    mov ah, 9
    int 21h
    int 20h
    
    endin:
    cmp di, 1
    jnz ii3
    neg ax
    
    ii3:
    pop cx
    
    ret
IntInput endp

IntOutput proc
    push cx
    
    test ax, ax
    jns oi1
    
    mov cx, ax
    mov ah, 02h
    mov dl, '-'
    int 21h
    mov ax, cx
    neg ax
    
    oi1:
    xor cx, cx
    mov bx, 10
    
    oi2:
    xor dx, dx
    div bx
    
    push dx
    inc cx
    
    test ax, ax
    jnz oi2
    
    mov ah, 02h
    
    oi3:
    pop dx
    add dl, '0'
    int 21h
    loop oi3  
    
    
    pop cx
    ret
IntOutput endp


start:   

    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    mov ah, 09h
    mov dx, offset prompt_msg
    int 21h 
     
    call IntInput
    mov array_size, ax
    mov cx, ax
    xor si, si
    
    fill_array:
    call IntInput
    mov si, point
    mov array[si], ax
    add si, 2
    mov point, si
    loop fill_array               
    
    start_sort:
    xor si, si
    mov flag_switch, 0 
    mov flag, 0
    
    sort_bubble:
    mov ax, array[si]
    add si, 2
    mov bx, array[si]
    cmp bx, 00h
    jne stay_in_border
    mov flag, 1
    jmp skip
    stay_in_border:
    cmp ax, array[si]
    jng skip
    mov bx, array[si]
    mov array[si], ax
    sub si, 2
    mov array[si], bx
    add si, 2
    mov flag_switch, 1
    
    skip:
    cmp flag, 1
    jne sort_bubble
    cmp flag_switch, 1
    je start_sort
    
    start_sort2:
    xor si, si 
    mov point, si                                               
    mov flag, 0
    mov flag_switch, 0
    
    sort_bubble_neg: 
    mov point, si 
    ;mov si, point
    mov ax, array[si]
    cmp ax, 0 
    jnl skip3
    add si, 2
    mov bx, array[si]
    cmp bx, 0
    jge stop
        
    ret1:
    cmp ax, bx
    jnl skip3
    mov array[si], ax
    sub si, 2         
    mov array[si], bx
    add si, 2
    mov flag_switch, 1
    jmp skip3
    
    stop:
    mov flag, 1 
    jmp skip3
    
    skip3:
    cmp flag, 1
    jne sort_bubble_neg
    cmp flag_switch, 1
    je start_sort2 
    
    
    
    
    mov cx, array_size
    xor si, si
    mov ah, 09h
    mov dx, offset sorted_array_msg
    int 21h 
    output_array:
        mov ax, array[si]
        call IntOutput 
        mov dl, 20h
        mov ah, 02h
        int 21h
        add si, 2
    
    
    loop output_array
    
    mov ax, 4c00h
    int 21h
    
    end start
    
    
    
    
    
       