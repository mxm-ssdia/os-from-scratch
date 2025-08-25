; Displaying AAA 
 ; switch to teletype mode
; mov ah, 0x0e  
; mov al, 65 ; decimal of A
; int 0x10 ; call bios interrupt 0x10
; mov ah, 0x0e
; mov al, 66
; int 0x10
; mov ah, 0x0e
; mov al, 67
; int 0x10

; displaying by incrementing the deccimal
; mov ah, 0x0e
; mov al, 65
; int 0x10
; inc al  ; add 1 to al
; int 0x10
; inc al  ; add 1 to al
; int 0x10
; inc al  ; add 1 to al
; int 0x10

; conditional jump
; mov bx, 5
; cmp bx, 5
; je label
; jmp $
; label:
 ;     mov ah, 0x0e
 ;     mov al, 'x'
 ;     int 0x10
;jmp $ 

mov ah, 0x0e
mov al, 'a'
int 0x10

loop:
   inc al
   cmp al, 'z' + 1
   je exit
   int 0x10
   jmp loop
exit:
jmp $

times 510-($-$$) db 0
dw 0xaa55
