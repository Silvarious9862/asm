;sort words alphabetically without using additional strings 

.model small
.stack 100h
.data
    string      db  250, 250 dup (?)
    buffer      db  255 dup (?)
    switch_flag dw  0
    msg1        db  "Input your string: $"
    msg2        db  "Sorted string: $"  
 
    
    word_start  dw  0
    
.code
  start:
    mov ax, @data
    mov ds, ax
    mov es, ax
    xor ax, ax
    
    ; vivod msg
    lea dx, msg1
    mov ah, 09h
    int 21h
    
    ; vvod string
    mov ah, 0Ah
    xor di, di
    mov dx, offset string 
    int 21h
  
  
  start_startov:
    mov switch_flag, 0  
    xor si, si  
    add si, 2
    ; find words
  start_of_search: 
    mov ax, si          ;ax - start of word
  find_word:
    mov bl, string[si]
    cmp bl, 0Dh
    je full_stop
    cmp bl, 20h
    je stop
    inc si
  jmp find_word
    stop:
    inc si
    mov dx, si          ;dx - start of second word
    
    
    xchg ax, si         ; si - start 1word
    xchg dx, di         ; di - start 2word
                                          
    mov al, string[si]
    mov dl, string[di]
    sub al, dl
    cmp al, 0 
    jl  skip            ; pri raznosti <0 slova v vernom poryadke
    
    xchg di, dx         ; save in dx address 2word
    xor di, di 
    mov bx, si
  buffering_word:
    mov al, string[si]
    cmp al, 20h
    je stop2
    mov buffer[di], al
    inc si
    inc di 
  jmp buffering_word
    stop2: 
    
    ;dvigaem stroku 
    inc si  
    mov di, bx
  moving_next_word:
    
    mov al, string[si]
    cmp al, 20h
    je stop3
    mov string[di], al
    inc di 
    inc si
  jmp moving_next_word
    
    ; dobavil probel
    stop3:
    mov string[di], al 
    inc di
    
    ;add bufferword
    
    xor si, si   
  adding_buffer:
    mov al, buffer[si]
    cmp al, 00h
    je stop4 
    mov string[di], al 
    inc si
    inc di
  jmp adding_buffer  
  
 
    
    stop4:
    mov al, 20h
    mov string[di], al 
    mov di, dx
    mov switch_flag, 1 
    
  ;clear_buffer
    mov cx, 250
    mov al, 0
    mov si, 0
  clear_buffer:
    mov buffer[si], al
    inc si
    loop clear_buffer
    
 
    skip:
    mov al,string[di]
    cmp al, 20h
    je stop5
    dec di
    jmp skip
    stop5:
    inc di    
    mov si, di
    jmp start_of_search                                      
    
    
    full_stop:
    mov dx, switch_flag
    test dx, dx
    jnz start_startov
    
    mov si, 0 
  repeat:     
    inc si
    mov al, string[si]
    cmp al, 0Dh 
    jne repeat 
    mov al, 24h
    mov string[si], al
  output:
    mov ah, 02h   
    mov dl, 0ah
    int 21h    
    mov dl, 0dh
    int 21h
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    mov dx, offset string
    add dx, 2
    int 21h
    
    
    mov ah, 4ch
    int 21h
end start