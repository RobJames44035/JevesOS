BITS 16             ; 16-bit real mode

org 0x7C00          ; BIOS loads bootloaders at this memory location

start:
    mov ah, 0x0E    ; BIOS teletype function for displaying text
    mov al, 'H'
    int 0x10        ; BIOS interrupt to print 'H'
    mov al, 'i'
    int 0x10        ; BIOS interrupt to print 'i'

hang:
    jmp hang        ; Infinite loop to keep the system running

times 512 - ($ - $$) db 0 ; Pad with zeros to reach 512 bytes
dw 0xAA55           ; Boot signature
