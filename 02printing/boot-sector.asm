; infinite loop (e9 fd ff)
loop: 
   jmp loop

; fill with 510 zeros minus the size of the previous code 
times 510-($-$$) db 0
; Magic number
dw 0xaa55

; nasm -f bin boot-sector.asm -o boot-sector.bin
; qemu-system-x86_64 boot-sector.bin
