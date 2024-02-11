.model small
.stack 100h
.data
    array       dw 3,5,7,9,0,1,6,4,2,8
    array_len   equ 9
    msg         db "array unsorted: $"
    msg2        db "array sorted: $"
    i           dw 0
    j           dw 0
    tmp         dw 0

.code 
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
    
    print_array:
        mov dx, array[si]
        add dl, 30h
        mov ah, 02h
        int 21h
        add si, 2
        loop print_array
    
    ;for (i = 0;i < size;i++) {	// упорядочиваем array[i]
	;	for (j = size - 1; j >= 0;j--) {	// просматриваем массив с конца
	;		if (array[j - 1] > array[j]) {	// если предыдущий больше текущего элемента
	;			int tmp = array[j - 1];		
	;			array[j - 1] = array[j];
	;			array[j] = tmp;	
    
    mov i, 0
    loop_i:
        mov j, 9
        jmp loop_j
        
    exchange:
        mov bx, i
        shl bx, 1
        mov ax, array[bx]
        mov bx, j
        shl bx, 1
        cmp ax, array[bx]
        jle lesser
        
        mov bx, i
        shl bx, 1
        mov tmp, ax
        
        mov bx, j
        shl bx, 1
        mov ax, array[bx]
        mov bx, i
        shl bx, 1
        mov array[bx], ax
        
        mov bx, j
        shl bx, 1
        mov ax, tmp
        mov array[bx], ax 
        
    lesser:
        dec j
        
        loop_j:
            mov ax, j
            cmp ax, i
            jg exchange
            
            inc i
            cmp i, array_len
            jl loop_i
                
    ;print_array2
        mov ah, 09
        lea dx, msg2
        int 21h
        
        mov cx, 10
        mov si, 0
    print_array2:    
        mov dx, array[si]
        add dl, 30h
        mov ah, 02h
        int 21h
        add si, 2
        loop print_array2     
       
    
    mov ax, 4c00h
    int 21h   
end main