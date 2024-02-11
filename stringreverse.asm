.model small
.stack 100h
.data

    string  db  (?) dup 16
    strlen  equ 16
    msg     db  "Input string: $"
    msg2    db  "Reverse: $"

.code
main:
    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    mov ah, 09h
    lea dx, msg
    int 21h
    
    mov cx, strlen
    mov si, 0
    
    inputloop:
    mov ah, 01h
    int 21h
    
    mov string[si], al
    inc si
    loop inputloop
    
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h 
    
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    mov cx, strlen
    mov ah, 02h
    dec si
    
    printloop:
    mov dl, string[si]
    int 21h
    dec si
    loop printloop
    
    exit:
    mov ah, 4ch
    int 21h
    
end main