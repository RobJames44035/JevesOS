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

    ; Print first stage message
    mov si, first_stage_msg
print_first_stage_msg:
    lodsb
    cmp al, 0
    je load_stage_two
    mov ah, 0x0E
    int 0x10
    jmp print_first_stage_msg

load_stage_two:
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

first_stage_msg db ' First stage bootloader', 0
boot_code:
    ; Second Stage Loader Code
    times 512 - ($ - $$) db 0
stage_two_start:
    ; Print welcome message
    mov si, welcome_msg
print_msg:
    lodsb
    cmp al, 0
    je load_kernel
    mov ah, 0x0E
    int 0x10
    jmp print_msg

load_kernel:
    ; Load embedded kernel from stage two loader to 0x1000:0000
    mov ax, 0x1000    ; Set segment for kernel
    mov es, ax
    mov si, kernel_code
    mov di, 0x0000    ; Destination offset is 0x0000

    ; Copy kernel from second stage to 0x1000:0000
copy_kernel:
    lodsb
    stosb
    cmp si, (kernel_code + kernel_size)
    jne copy_kernel

    ; Jump to kernel entry point
    jmp 0x1000:0000

welcome_msg db '    Welcome to StarshipOS v0.1', 0

; Embedded kernel
kernel_code:
    ; Embedded Kernel Code
    mov si, embedded_kernel_msg
print_embedded_kernel_msg:
    lodsb
    cmp al, 0
    je hang_kernel
    mov ah, 0x0E
    int 0x10
    jmp print_embedded_kernel_msg

hang_kernel:
    ; Hang to keep message
    jmp $

embedded_kernel_msg db 'Kernel has been loaded!', 0
kernel_size equ ($ - kernel_code)

stage_two_size equ ($ - stage_two_start)
times 1024 - (stage_two_size % 1024) db 0 ; Fill to align size to appropriate multiple of sectors

dw 0xAA55 ; Boot signature to mark the end of the bootloader

