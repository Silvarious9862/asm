.model small
.stack 255h
.data            
    msg0    db  "Enter size of matrix (NxN): $"
    msg1    db  "Enter element (?) of matrix: $"
    msg2    db  "Original matrix: ", 0Dh, 0Ah, '$'
    msg3    db  "Edited matrix: ", 0Dh, 0Ah, '$'
    
    line        dw  0
    column      dw  0
    column_size dw  0      
    count_space dw  0  
    
    max_value       dw  00h 
    max_value_pos   dw  00h
  
    min_value       dw  00h
    min_value_pos   dw  00h
    
    point   dw  0         
    
    buffer  db  6, 7 dup (?) 
    matrix  dw  100 dup (?)
    
    
.code  
print_matrix proc 
    push cx     ; save cx of full loop
    
    
    mov cx, column_size
    xor si, si
    loop1:
        
        push cx
        mov cx, column_size
        loop2:   
            
            mov  ax, matrix[si]
            call out_int 
            add si, 2    
            cmp ax, 3Fh
            je  skip_?_print
            push cx
            mov cx, 6
            sub cx, count_space
            mov ah, 02h
            mov dl, 20h 
            loop3:   
                int 21h
                loop loop3
            pop cx   
            skip_?_print: 
            loop loop2 
        pop cx
        mov ah, 02h
        mov dl, 0Ah
        int 21h    
        int 21h
        mov dl, 0Dh
        int 21h
        loop loop1
    
    pop cx  ; get cx of full loop
    ret
print_matrix endp

in_int proc   
    ;; out - number in AX
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
    ; what to print - in AX  
    push cx  
    
    cmp ax, 3Fh
    jne skip_?
    
    mov ah, 02h
    mov dl, 3Fh
    int 21h
    jmp spaces
    
    skip_?:
    
    xor cx, cx
    mov bx, 10
    mark2:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax 
    jnz mark2 
    
    mov count_space, cx
    mov ah, 02h
    loop_out:
    pop dx
    add dl, 30h
    int 21h
    loop loop_out
    jmp end_out 
    
    spaces:
    mov cx, 5
    mov ah, 02h
    mov dl, 20h
    print_spaces:
    int 21h
    loop print_spaces
    mov ax, 3Fh
    
    end_out:        
    pop cx        
    ret
out_int endp 

select_element proc
    mov ax, line
    mul column_size
    add ax, column
    mov bx, 2
    mul bx
    
    mov si, ax
    ret
select_element endp


check_min proc   
    ; compare elem w/ min_value
    cmp bx, min_value
    jnb next1  ; if equal or above, skip
    
    mov min_value_pos, si  ; min value pos
    mov min_value, bx
    
    next1:

    ret
check_min endp 

check_max proc   
    ; compare elem w/ max_value
    cmp bx, max_value
    jna next2  ; if equal or below, skip
    
    mov max_value_pos, si  ; min value pos
    mov max_value, bx
    
    next2:

    ret
check_max endp


start:
    mov ax, @data
    mov ds, ax
    xor ax, ax
    xor cx, cx
    
    ; input size of matrix
    mov ah, 09h
    mov dx, offset msg0
    int 21h
    call in_int
    mov column_size, ax
    
    mul ax  ; full size of matrix
    mov cx, ax
    
    ; add matrix
    
    
    mov di, 0
  matrix_in:
    ; clear screen  
    mov ax, 03h
    int 10h 
    mov di, point
    mov matrix[di], 3Fh
    ;call print_matrix 
    ; instruct   
    mov ah, 09h
    mov dx, offset msg1
    int 21h
    
    call in_int 
    mov di, point
 
    mov matrix[di], ax
    add point, 2
  loop matrix_in
    
    ; print 1 matrix
    mov ax, 03h   ; clear screen
    int 10h    
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    call print_matrix               
    
 ; find max and min
    ; full clear 
    xor ax, ax
    xor bx, bx  
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di 
    
    ; set max  
    mov si, 2     
    mov dx, matrix[si]
    mov max_value, dx
    mov max_value_pos, si
    ; set min               
    xor si, si    
    mov ax, column_size
    mov bx, 2
    mul bx
    mov si, ax
    mov dx, matrix[si]
    mov min_value, dx
    mov min_value_pos, si      
    
    
    ; find min and max values
    mov ax, column_size
    mul ax
    mov cx, ax
  minmax_checker:     
    ; select element
    call select_element
    mov bx, matrix[si] ;1 elem 
    ; compare line-column
    mov dx, line
    cmp dx, column
    
    ja  find_min
    jb  find_max
    jmp skip 
    
    find_min:
    call check_min
    jmp  skip
    
    find_max:
    call check_max
    jmp  skip
    
    skip:
    inc column          ; col +1
    mov ax, column_size
    cmp ax, column      ; compare to max_col
    jne cancel_0        ; if not max, jump
    
    mov column, 0       ; cancel col
    inc line            ; line +1
    cancel_0:
  loop minmax_checker
                   
    ; exchange min and max
    mov si, max_value_pos
    mov bx, min_value
    mov matrix[si], bx
    
    mov si, min_value_pos
    mov bx, max_value
    mov matrix[si], bx
    
    ; print 2 matrix 
    mov ah, 02h
    mov dl, 0Ah
    int 21h 
    int 21h
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    call print_matrix           
                   
    
  exit:  
    mov ax, 4c00h
    int 21h
end start
       