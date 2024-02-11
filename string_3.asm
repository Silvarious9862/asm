 .model small

.data 

string db 60, 60 dup (?)
new_string db 60 dup (?) 

prompt db "input string: $"
output_prompt db "output string: $"
min_prompt  db  "Min word: $"
max_prompt  db  "Max word: $"

max_word_pos dw 0
min_word_pos dw 0

len_max dw 0
len_min dw 0  

min_word_value dw 99
max_word_value dw 0 

max_word_1letter db 0
min_word_1letter db 0 

start_of_word dw 0 
save_si dw  0  
flag_stop dw 0

tmp_pointer dw 0



.code

main proc
    mov ax, @data
    mov ds, ax
    xor ax, ax
    
    mov ah, 09h
    mov dx, offset prompt
    int 21h 
    
input: 
    mov ah,1
    int 21h
    cmp al,13
    je display
    mov [si],al
    inc si
    jmp input

display:
    mov [si],'$'
    mov di, offset string +2 
    mov dl,13
    mov ah,2
    int 21h
    mov dl,10
    mov ah,2
    int 21h
         
    ; STRING PROCESSING
    
    mov si, 0   
    
    search:
    mov start_of_word, si 
    
    find_word:
    get_end_of_word:
    
    mov al, string[si]
    cmp al, 24h
    je  flag_stop_set
    
    cmp al, 20h
    jne skip
    
    flag_stop_back:
    mov save_si, si
    sub si, start_of_word
    cmp si, max_word_value
    ja  set_new_max
    
    check_min:
    cmp si, min_word_value
    jb set_new_min
    
    jmp skip_full
    
    set_new_max:
    mov max_word_value, si
    mov bx, start_of_word
    mov max_word_pos, bx  
    push si
    mov si, max_word_pos
    mov al, string[si]
    pop si
    mov max_word_1letter, al
    jmp check_min
    
    set_new_min:
    mov min_word_value, si
    mov bx, start_of_word
    mov min_word_pos, bx 
    push si
    mov si, min_word_pos
    mov al, string[si]
    pop si
    mov min_word_1letter, al
    jmp skip_full    
    
    flag_stop_set:
    mov flag_stop, 1
    jmp flag_stop_back
    
    skip:
    inc si
    jmp find_word
    
    skip_full: 
    mov si, save_si
    inc si 
    mov bx, flag_stop
    cmp bx, 1
    je  stop_search
    jmp search
    
    stop_search: 
    
    ; FILL NEW BUFF

    xor ax, ax
    mov di, 0
    mov si, 0
    
    ; string out
    mov ah, 09h
    mov dx, offset output_prompt 
    int 21h 
    
    mov ah, 09h
    mov dx, offset string
    int 21h    
    
    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h    
    
    ; min out
    mov ah, 09h
    mov dx, offset min_prompt 
    int 21h  
    
    mov si, min_word_pos
    mov ah, 02h  
    
    print_min:
    mov dl, string[si]
    cmp dl, 20h
    je  stop_min
    int 21h  
    inc si
    jmp print_min
    
    ; max out
    
    stop_min:
    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h
    
    mov ah, 09h
    mov dx, offset max_prompt 
    int 21h  
    
    mov si, max_word_pos
    mov ah, 02h 
    
    print_max:
    mov dl, string[si]
    cmp dl, 20h
    je  stop_max
    int 21h 
    inc si
    jmp print_max 
    
    stop_max:
    
    exit:  
    mov ax, 4c00h
    int 21h
             
main endp

end main