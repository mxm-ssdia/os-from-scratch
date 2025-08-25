; cpu is dumb dosent even know if our code is 16/32 bit 
; we have to tell the assmb te use 16 bit ins because cpu starts in that mode 
; when the cpu start its in primitive mode called Real Mode 
; In this mode it behaves like an old 8086 cpu and only understand 16 bit instruction
; our botloader must use 16bit code because the bios which runs in real mode is the one that will exec it 
bits 16 

; org = origin tell the assembler this code will be loaded into mmemory at address 0x7c00
; we are teling the assembler that that when calculating memory add for my labels (loop start etc)
; assume this code is located at 0x7c00
org 0x7c00

; this is a lable not a ins for cpu its a note for the assembler 
; it marks a location in ur code with a name 
; give a human redable name to the the memory add where ur code begins 
; others parts of the code could jump to start
start :
    ; mov copies data form source to a destination (mov des source)
    ; ax,ds = registers special named storage location inside the cpu itself fster > ram
    mov ax, 0 ; ax = general purpose 16 bit register
    mov ds, ax ; ds = data segment register 
    ; in real mode memory add are calculaed as (segment* 16 + offfset)
    ; ds regis is used ass default segment for most data operation 
    ; by setting ds=0 we ensure memory access at offset 0x7c00
    ;the cpu calculates the correct physiical address (0*16+0xx7c00=0x7c00)

    ; ah &  al high and low 8-bits parts of 16-bit ax register 
    ; 0x0e is a hex dec num, 0x prefixx is a c style notation for hex 
    ; we are selecting a fun from the bios video service (int 0x10) by putting 0x0e in ah 
    ; mov al X is providing the argument to that fun 
    ; so for ttf fun the rule is print the char in al register
    mov ah, 0x0e
    mov al, 'X'
    int 0x10

    ; tells the cpu to continue execution form a new address
    ; $ in nasm means current address 
    ; this create a infinite loop cpu gets stuck here foreever 
    ; if code ended the cpu would keep reading and exec whatever garbage data is in the next memory 
    ; location leading to a crash
    jmp $

; filling 510bytes with 0 and last with aa 55
; $ current position $$ start of the section (boot start loop etc)
;$-$$ size of our code so far
; we need to pad the file with 510 bytes so it ends up 512bytes after the 2 bytes
times 510 - ($-$$) db 0
; bootsignature , bios checck if last 2 bytes are 0x55 and0xaa written 55 aa on disk 
; this sector is bootable
dw 0xaa55
