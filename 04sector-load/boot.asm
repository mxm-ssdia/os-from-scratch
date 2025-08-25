bits 16
org 0x7c00

    ;cpu uses diff more complex calculation
    ;phy add = (segment reg* 16) + offset
    ;setting the segment reg to known value so that it not access garbage memory or cache
 
boot:
   mov ax, 0 ; temp holding place as we cant mov value directly to segment reg
    mov ds, ax ; data segment to 0 so when we access data via an offfset (mov al, [si]) the cpu calculate the correct phy address
    mov es, ax ; exxtra seg used for string operation or a temp segment same reason as abbove
    mov ss, ax ; stack segment special area of mem used for temp storage (return addr for call )
    mov sp, 0x7c00  ;stack grows downwards from 0x7c00 so it points to the head 

    mov si, loading_msg
    call print_string ;call the print.asm with we take the si and move to al and print loading msg

    ;read the disk sector
    mov ah, 0x02    ;bios read sector fun
    mov al, 1        ; no of sector to read (1 sec to read)
    mov ch, 0       ; cylinder no (0)
    mov cl, 2       ; sec no to read (sec 2)
    mov dh, 0       ; head num (0)
    mov dl, 0x80    ; driver no (0x80 for harddisk 0x00 for floppy)
    mov bx, 0x7e00  ; es:bx -> Memory address to load sectors into (0x7e00)
    int 0x13        ; call bios disk interrupt
    jc disk_error   ; jmp if erroe (carry flag is set)

    jmp 0x0000:0x7e00 ; jmp far to the code we just loaded

disk_error:
    mov si, error_msg
    call print_string
    jmp $           ; hang on error

loading_msg: db "loading ...", 0
error_msg: db "error kela!!", 0

%include "print.asm"

times 510 - ($-$$) db 0
dw 0xaa55

;nasm -f bin boot.asm -o boot.bin
;nasm -f bin sector2.asm -o sector2.bin

;Create a blank 1.44MB floppy image (2880 sectors)
;dd if=/dev/zero of=disk.img bs=512 count=2880

;Copy the bootloader to the first sector (sector 1)
;dd if=boot.bin of=disk.img bs=512 count=1 conv=notrunc

;Copy the second stage to the second sector (sector 2)
;dd if=sector2.bin of=disk.img bs=512 seek=1 conv=notrunc

;qemu-system-x86_64 -drive format=raw,file=disk.img
