;common code will be repeating 

print_string:
    mov ah, 0x0e ; calling the teletype fun
.print_loop:
    lodsb       ;load bytes from si into al
    cmp al, 0   ;check for null terminator 
    je .done    ;if null we are done
    int 0x10    ;print char
    jmp .print_loop ;repeat
.done:
    ret

