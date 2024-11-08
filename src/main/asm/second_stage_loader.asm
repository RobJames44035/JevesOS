[BITS 16]
[ORG 0x0000]

start:
    ; Initialize the shell with basic commands
    ; Display a welcome message or prompt

    mov si, welcome_message
    call print_string

shell:
    ; Implement basic shell logic here
    ; For example, read user input and process commands

    jmp shell

welcome_message db 'Welcome to the simple shell!', 0

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

; Other necessary functions and shell commands...

times 510-($-$$) db 0
