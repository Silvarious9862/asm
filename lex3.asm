.model small
.stack 255h
.data            
    msg0    db  "Enter size of matrix (lines): $"
    msg0_1  db  "Enter size of matrix (columns): $"
    msg1    db  "Enter element of matrix: $" 
    msg1_1  db  "Entered matrix: ", 0Dh, 0Ah, '$'
    msg2    db  "Maxsum column - ", '$'
    msg3    db  "Sum of this column: ", '$'
    
    line        dw  0 
    line_size   dw  0
    column      dw  0
    column_size dw  0      
    count_space dw  0  
    
    max_value       dw  00h 
    max_value_pos   dw  00h
    
    point   dw  0         
    
    buffer  db  6, 7 dup (?) 
    matrix  dw  100 dup (?)
    
    
.code  
print_matrix proc 
    push cx     ; save cx of full loop
    
    
    mov cx, line_size
    xor si, si
    loop1:
        
        push cx
        mov cx, column_size
        loop2:   
            
            mov  ax, matrix[si]
            call out_int 
            add si, 2    
            push cx
            mov cx, 6
            sub cx, count_space
            mov ah, 02h
            mov dl, 20h 
            loop3:   
                int 21h
                loop loop3
            pop cx    
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
    mov line_size, ax
    mov ah, 09h
    mov dx, offset msg0_1
    int 21h
    call in_int
    mov column_size, ax
    
    mov bx, line_size
    mul bx  ; full size of matrix
    mov cx, ax
    
    ; add matrix
    
    
    mov di, 0
  matrix_in:
    ; clear screen  
    ;mov ax, 03h
    ;int 10h 
    ;mov di, point
    ;mov matrix[di], 3Fh
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
    mov dx, offset msg1_1
    int 21h
    call print_matrix               
    
 ; find maxsum
    ; full clear 
    xor ax, ax
    xor bx, bx  
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di 
    
    ;find maxsum col
    mov line, 0
    mov column, 0
    maxsum:
        
        xor ax, ax
        mov bx, column
        cmp bx, column_size
        ja  stop_maxsum
        maxsum_thiscol:
            push ax
            call select_element 
            mov  bx, matrix[si]  
            pop  ax
            add  ax, bx
            inc  line
            mov  bx, line
            cmp  bx, line_size 
            jb   maxsum_thiscol
        cmp ax, max_value
        jbe skip_maxsum
        mov max_value, ax  
        mov bx, column
        mov max_value_pos, bx
    skip_maxsum:
    inc column  
    mov line, 0  
    jmp maxsum               
    stop_maxsum:
    
    ; print max col
    mov ah, 09h
    mov dx, offset msg2
    int 21h 
    mov ax, max_value_pos 
    inc ax
    call out_int
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    mov line, 0
    mov bx, max_value_pos
    mov column, bx
    mov cx, line_size
    print_maxcol:    
        call select_element
        mov  ax, matrix[si]
        call out_int
        mov  ah, 02h
        mov  dl, 0Ah
        int  21h
        mov  dl, 0Dh
        int  21h
        inc  line
    loop print_maxcol
    
    ; print sum
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    mov ax, max_value
    call out_int                
                   
    
  exit:  
    mov ax, 4c00h
    int 21h
end start
       