.model small
.stack 100h
.data
    player1 db  1
    player2 db  2
    player1move db  'X'
    player2move db  'O'
    board   db  31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h
    msg_instruction db "Print one of these numbers to put a mark $"
    msg_players db  "Player 1 - X, player 2 - O. $"
    msg_wait    db  "Press any key to continue...$"
    msg_player1 db  "Player 1$"
    msg_player2 db  "Player 2$"
    msg_next_move   db "'s next move: $"
    msg_draw    db  "It's draw!$"  
    msg_winner  db  " win the game!$"
    msg_repeat  db  "This cell is occupied! Choose another.$"
    which_move  db  255
    game_over   db  0
    column      dw  0
    repeat_turn db  0

.code 
printfullboard proc
; print the board
    mov ah, 02h
    mov si, 0 
    mov cx, 3
    
    printboard:
    push cx
    mov cx, 25
    mov dl, 20h
    printspaceline:
    int 21h
    loop printspaceline
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h    
    
    mov cx, 3 
        
    printrow:
    mov dl, 20h
    int 21h
    int 21h
    
    mov dl, board[si]
    int 21h
    
    mov dl, 20h
    int 21h
    int 21h
    
    cmp cx, 1
    je  skippart
    
    mov dl, 0b3h
    int 21h 
    skippart:
    inc si
    loop printrow
    
    pop cx
    cmp cx, 1 
    push cx
    je  skip
    
    mov cx, 17
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h
    mov dl, 0c4h 
    printline:
    int 21h
    loop printline
    skip:
    pop cx
    loop printboard
    
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h
    
    ret    
printfullboard endp

declare_instructions proc
    ; how to play
    mov ah, 09h
    lea dx, msg_instruction
    int 21h
    call printfullboard 
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h
    mov ah, 09h
    lea dx, msg_players
    int 21h
    lea dx, msg_wait
    int 21h
    mov ah, 07h
    int 21h
    ret
declare_instructions endp

clear_board proc
    ; set all tiles to SPACE
    mov si, 0
    mov cx, 9
    mov bl, 20h
    clear:
    mov board[si], bl
    inc si
    loop clear
    
    mov si, 0
    ret
clear_board endp

turn proc
    ; player # move 
    not which_move
    repeat:
    mov ax, 03h
    int 10h
    call printfullboard
    mov dl, repeat_turn
    cmp dl, 0
    jne please_repeat
    
    after_repeat:
    mov ah, 09h    
    mov al, which_move
    cmp al, 0
    jne wm_player2
    lea dx, msg_player1
    int 21h
    jmp nextmove
    wm_player2:
    lea dx, msg_player2
    int 21h
    nextmove:
    lea dx, msg_next_move
    int 21h
    
    mov si, 0 
    mov ah, 01h
    int 21h
    xor ah, ah
    sub ax, 30h
    sub ax, 1h
    mov si, ax 
    
    mov dl, board[si]
    mov repeat_turn, 1
    cmp dl, 20h    
    jne repeat
    mov repeat_turn, 0
    
    
    
    mov bl, which_move
    cmp bl, 0
    jne setmark2   
    mov bh, player1move
    mov board[si], bh
    jmp skip_p2
    setmark2:
    mov bh, player2move
    mov board[si], bh
    skip_p2:
    
    
    
    ret 
    
    please_repeat:
    mov ah, 09h
    lea dx, msg_repeat
    int 21h      
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h
    jmp after_repeat
turn endp

check_rules proc
    ; check for game over
    call check_row    ; row crossed
    mov dl, game_over 
    cmp dl, 1
    je check_rules_end
    
    call check_column ; column crossed
    mov dl, game_over 
    cmp dl, 1
    je check_rules_end
    
    call check_diagonal
    
    check_rules_end:
    ret
check_rules endp

check_row proc
    mov cx, 3
    mov si, 0
    
    row_loop:
    mov dl, board[si]
    inc si
    cmp dl, board[si]   ; board[][0] = board[][1]
    jne continue_row_on_1st
    mov dl, board[si]
    inc si
    cmp dl, board[si]   ; board[][1] = board[][2]
    jne continue_row_on_2nd
    cmp dl, 20h         ; board[][1] != space
    je  continue_row_on_2nd
    mov cx, 0
    mov game_over, 1
    jmp check_row_end    
    
    
    continue_row_on_1st:
    inc si
    continue_row_on_2nd:
    inc si
    
    
    
    loop row_loop
    
    check_row_end:
    ret
check_row endp

check_column proc
    mov cx, 3
    mov column, 0
    
    column_loop:
    mov si, column
    mov dl, board[si]
    add si, 3
    cmp dl, board[si]
    jne continue_column
    mov dl, board[si]
    add si, 3
    cmp dl, board[si]
    jne continue_column
    cmp dl, 20h
    je  continue_column
    mov cx, 0
    mov game_over, 1
    jmp check_column_end
    
    continue_column:
    inc column
    mov si, column
    
    loop column_loop
    
    check_column_end:
    
    ret
check_column endp 

check_diagonal proc
    ;main diagonal
    mov si, 0
    
    mov dl, board[si]
    add si, 4
    cmp dl, board[si]
    jne check_side_diagonal
    mov dl, board[si]
    add si, 4
    cmp dl, board[si]
    jne check_side_diagonal
    cmp dl, 20h
    je  check_side_diagonal
    mov game_over, 1
    jmp check_diagonal_end
    
    
    check_side_diagonal:
    mov si, 2
    mov dl, board[si]
    add si, 2
    cmp dl, board[si]
    jne check_diagonal_end
    mov dl, board[si]
    add si, 2
    cmp dl, board[si]
    jne check_diagonal_end
    cmp dl, 20h
    je  check_diagonal_end
    mov game_over, 1
    
    
    check_diagonal_end:
    ret
check_diagonal endp 

declare_winner proc
    mov ah, 09h
    
    mov dl, game_over
    cmp dl, 0
    jne win_p1
    lea dx, msg_draw
    
    int 21h
    jmp declare_end
    
    win_p1: 
    mov dl, which_move
    cmp dl, 0
    jne win_p2
    
    lea dx, msg_player1
    int 21h
    jmp declare_win
    
    win_p2:
    lea dx, msg_player2
    int 21h
    
    declare_win:
    lea dx, msg_winner
    int 21h
    declare_end:
    ret
declare_winner endp

main proc
    mov ax, @data
    mov ds, ax
    xor ax, ax 
    
    call declare_instructions
    call clear_board
    mov cx, 9
    turnloop:
    push cx
    call turn
    call check_rules
    mov dl, game_over
    cmp dl, 1
    je  stop_game 
    pop cx
    loop turnloop
    
    
    stop_game:
    mov ax, 03h
    int 10h
    call printfullboard
    call declare_winner
    
    
    exit:
    mov ah, 4ch
    int 21h
main endp

end main 