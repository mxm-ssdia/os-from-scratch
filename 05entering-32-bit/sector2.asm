; sector2.asm - Second stage loader. Enters 32-bit Protected Mode.
bits 16
org 0x7e00

start:
    cli                     ; Disable interrupts during setup
    call enable_a20         ; Enable the A20 address line
    call load_gdt           ; Load the Global Descriptor Table
    call enter_pm           ; Flip the bit to enter Protected Mode

    ; We never return here. The 'enter_pm' routine jumps to our 32-bit code.

; -------------------------------------------------------------------
; 16-bit Functions
; -------------------------------------------------------------------

enable_a20:
    ; A fast and common method to enable the A20 line
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

load_gdt:
    lgdt [gdt_descriptor]   ; Load the GDT descriptor structure
    ret

enter_pm:
    mov eax, cr0            ; Get the current control register value
    or eax, 0x1             ; Set the Protection Enable bit (bit 0)
    mov cr0, eax            ; Write back to CR0 - CPU is now in PM!
    jmp 0x08:pm_start       ; Far jump to our 32-bit code. 0x08 is the code segment selector.

; -------------------------------------------------------------------
; Data: The GDT (Global Descriptor Table) - MOVED TO THE END OF 16-bit CODE
; -------------------------------------------------------------------
gdt_start:
    ; The first descriptor is always null.
    dd 0x0
    dd 0x0

; Code segment descriptor
gdt_code:
    dw 0xffff       ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10011010b    ; Access byte: Present, Ring 0, Code, Exec/Read
    db 11001111b    ; Flags + Limit (bits 16-19): 4KB granules, 32-bit, max limit
    db 0x0          ; Base (bits 24-31)

; Data segment descriptor
gdt_data:
    dw 0xffff       ; Limit
    dw 0x0          ; Base
    db 0x0          ; Base
    db 10010010b    ; Access byte: Present, Ring 0, Data, Read/Write
    db 11001111b    ; Flags + Limit
    db 0x0          ; Base
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of the GDT
    dd gdt_start                ; Start address of the GDT

; -------------------------------------------------------------------
; 32-bit Protected Mode Code
; -------------------------------------------------------------------
bits 32                         ; Tell NASM to generate 32-bit code now
pm_start:
    ; Set up data segments for PM
    mov ax, 0x10                ; 0x10 is the selector for our data segment
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Set up the stack for PM
    mov ebp, 0x90000            ; Set the stack base pointer
    mov esp, ebp                ; Set the stack pointer

    ; Call our main 32-bit function
    call pm_main

    ; Hang if we return
    hlt

; Our main 32-bit routine
pm_main:
    ; Print a message by writing directly to VGA text memory
    mov esi, pm_msg
    mov edi, 0xb8000            ; VGA text memory starts here
.print_loop:
    mov al, [esi]               ; Get character from string
    cmp al, 0                   ; Check for null terminator
    je .done
    mov ah, 0x0f                ; Attribute: white on black
    mov [edi], ax               ; Write character + attribute to VGA memory
    add esi, 1                  ; Next character
    add edi, 2                  ; Next VGA cell (each is 2 bytes: char + attr)
    jmp .print_loop
.done:
    ret

pm_msg: db "32-Bit Protected Mode Active!", 0

; Pad the rest of the sector
times 512 - ($-$$) db 0
