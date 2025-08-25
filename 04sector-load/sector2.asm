; context a simple program to print message 
; whhich we will load in boot.asm

bits 16
; 0x7c00 bioas load bootloader at 0x7c00(512bytes)
; next free memory add is 0x7e00 (512 + 0x7c00 =.)
org 0x7e00

start: 
    mov si, loaded_msg; we put addr of our string si (source index) register
    call print_string ; jumps to the p_s lable and saves the return add so ret can bring us back
    cli               ;clear interrupts before halt
    hlt               ; halt the cpu(stop exec)

loaded_msg: db "Sector 2 loaded successfully", 0

; simple print string function
print_string:
    mov ah, 0x0e      ;bios teletype fun
  .print_loop:
    lodsb           ; load bytes from si into al and increment si therefore points to next char
    cmp al, 0       ; is the char null 0?
    je .done        ; if yes jump to .done lable
    int 0x10        ; else print it
    jmp .print_loop ; repeat for nexxt char 

  .done:
    ret             ; return from the fun call

times 512 - ($-$$) db 0 
