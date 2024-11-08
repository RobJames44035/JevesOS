[BITS 16]
[ORG 0x7C00]

; First Stage Bootloader Code
start:
    ; Clear screen (optional for visualization)
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    ; Load second stage loader into memory at 0x9000:0000
    mov ax, 0x9000    ; Set segment for second stage
    mov es, ax
    mov si, boot_code

    ; Copy second stage loader to 0x9000:0000
copy_stage_two:
    lodsb
    stosb
    cmp si, (boot_code + stage_two_size)
    jne copy_stage_two

    ; Jump to second stage loader at 0x9000:0000
    jmp 0x9000:0000

hang:
    ; Simple hang for debug
    jmp $

boot_code:
    ; Second Stage Loader Code Embedded Here
    times 512 - ($ - $$) db 0
stage_two_start:
    ; Print welcome message
    mov si, welcome_msg
print_msg:
    lodsb
    cmp al, 0
    je hang_stage_two
    mov ah, 0x0E
    int 0x10
    jmp print_msg

hang_stage_two:
    ; Hang if message prints successfully
    jmp $

welcome_msg db 'Welcome to Stage Two', 0
stage_two_size equ ($ - stage_two_start)
times 1024 - ($ - $$) db 0 ; Filling to ensure that it fits within an appropriate number of sectors

dw 0xAA55 ; Boot signature to mark the end of the bootloader
