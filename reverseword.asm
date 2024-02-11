.model small
.stack 100h
.data

    string  db  (?) dup 16
    strlen  equ 15
    msg     db  "Input string: $"
    msg2    db  "Reverse words: $"

.code
main:
    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    ; invite
    mov ah, 09h
    lea dx, msg
    int 21h
    
    mov cx, strlen
    ;dec cx
    mov si, 0
    
    ; input string
    inputloop:
    mov ah, 01h
    int 21h
    mov string[si], al
    inc si
    loop inputloop
                    
    mov al, 24h                
    mov string[si], al 
    
    ; next line
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h
    
    ;mov ah, 02h
;    mov cx, strlen
;    mov si, 0
;    inputcheck:
;    mov dl, string[si]
;    int 21h
;    inc si
;    loop inputcheck
    
    ; next line
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h 
    
    ; output
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    ; -------- action --------
    
    ; external loop
    xor si, si
    mov cx, strlen
    ;dec cx
    mirror:
        mov al, string[si]
        cmp al, 20h
        je  endofword
        
        cmp cx, 1
        je endofword 
        inc si
    
    
    
    loop mirror
    
    
    
    
    
    
    ; -------- action --------
    
    
    
    
    exit:
    mov ah, 4ch
    int 21h
    
    endofword:
    push cx
    mov di, si
    mov cx, si
    dec si        
    mov ah, 02h
        
        reversingword:
        mov dl, string[si]
        int 21h
        dec si 
        mov al, string[si]
        cmp al, 20h
        je stop
        loop reversingword
    
    stop:
    ; add space
    mov dl, 20h
    int 21h
    
    pop cx 
    cmp cx, 1
    je  exit   
    mov si, di
    inc si    
    jmp mirror
    
    
end main