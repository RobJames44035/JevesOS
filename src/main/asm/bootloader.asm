[BITS 16]
[ORG 0x7C00]

start:
    ; Load second stage loader
    mov ax, 0x1000
    mov es, ax
    mov bx, 0x0000
    add ax, 0x0010

    ; Load 512 bytes from disk to 0x1000:0000 (second stage)
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    int 0x13

    ; Jump to second stage loader
    jmp 0x1000:0000

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xAA55
