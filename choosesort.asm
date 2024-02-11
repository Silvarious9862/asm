.model small
.stack 100h
.data
    array   dw  6,5,3,7,8,2,1,9,0,4
    array_len equ 9
    i       dw 0
    j       dw 0
    min     dw 0
    tmp     dw 0 
    msg     db "Choosesort. Examle array: $"
    msg2    db "Sorted: $"
    
.code

exchange proc
    ; tmp = array[i]
    mov di, i
    shl di, 1
    mov bx, array[di]
    ;shl bx, 1
    mov tmp, bx
    
    ; array[i] = array[min]
    mov bx, array[si]
    ;shl bx, 1
    mov array[di], bx
    
    ; array[min] = tmp
    mov bx, tmp
    mov array[si], bx
    mov tmp, 0
    
    
    ret    
exchange endp 

main:

    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    mov ah, 9
    lea dx, msg
    int 21h
    
    xor cx, cx
    mov cx, 10
    mov si, 0
    print:
        mov dx, array[si]
        add dl, 30h
        mov ah, 02h
        int 21h 
        add si, 2
        mov dx, 20h
        mov ah, 02h 
        int 21h
    loop print  


;    for (i = 0; i < size - 1; i++) {    
;    int min = i;
;       for (j = i + 1; j < size; j++)
;           if (array[j] < array[min])
;               min = j;   
;       int tmp = array[i];
;       array[i] = array[min];
;       array[min] = tmp;  
;   }    
    mov cx, array_len   ; i < size
    mov i, 0            ; i = 0
    xor bx, bx 
    
    loop_i:
    mov si, i
    mov j, si
    shl si, 1
    mov bx, array[si]
    mov min, bx      ; min = i
    mov di, si       ; si = minvalue
       
        loop_j:    
        inc j
        add di, 2        ; di = compare value
        mov ax, array_len
        inc ax
        
        
        mov bx, array[di]
        cmp bx, array[si]
        jl  setmin
        
        fromsetminproc:
        cmp j, ax
        jl loop_j
    call exchange    
    inc i
    loop loop_i    
    
    
    output:
    mov ah, 9
    lea dx, msg2
    int 21h
    
    xor cx, cx
    mov cx, 10
    mov si, 0
    printout:
        mov dx, array[si]
        add dl, 30h
        mov ah, 02h
        int 21h 
        add si, 2
        mov dx, 20h
        mov ah, 02h 
        int 21h
    loop printout
    
    exit:
    mov ax, 4c00h
    int 21h
    
    setmin:
        mov si, di 
        xor dx, dx
        mov dx, array[si]
        mov min, dx
        jmp  fromsetminproc
        
   
end main


    