section .text
global _start
    _start:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16

        ; x - right
        ; y - down
        mov     byte [rbp+1], 3 ; y position
        mov     byte [rbp+2], 10 ; x position
        mov     byte [rbp+3], 1 ; y speed
        mov     byte [rbp+4], 1 ; x speed

        ; surface index eval
        xor     rbx, rbx
        mov     bl, byte [rbp+1]
        imul    bx, 65
        xor     ax, ax
        add     bl, byte [rbp+2]
        add     bx, ax

        ; draw position
        mov     byte [surface+rbx], '@'
        mov     rdi, 1
        mov     rsi, drawSurface
        call    print_string

        .loop:
        mov     rdi, 16
        call    ms_delay

        ; erase previous
        mov     byte [surface+rbx], '.'

        ; y collision check
        mov     al, byte [rbp+1]
        add     al, byte [rbp+3]
        cmp     al, 26
        jl      .bottom
        neg     byte [rbp+3]
        .bottom:
        cmp     al, 0
        jge      .up
        neg     byte [rbp+3]
        .up:

        ; x collision check
        mov     al, byte [rbp+2]
        add     al, byte [rbp+4]
        cmp     al, 64
        jl      .right
        neg     byte [rbp+4]
        .right:
        cmp     al, 0
        jge      .left
        neg     byte [rbp+4]
        .left:

        ; new position
        mov     al, byte [rbp+3]
        add     byte [rbp+1], al
        mov     al, byte [rbp+4]
        add     byte [rbp+2], al

        ; surface index eval
        xor     rbx, rbx
        mov     bl, byte [rbp+1]
        imul    bx, 65
        xor     ax, ax
        mov     al, byte [rbp+2]
        add     bx, ax

        ; draw new position
        mov     byte [surface+rbx], '@'

        mov     rdi, 1
        mov     rsi, drawSurface
        call    print_string
        loop    .loop

        .end:
        add     rsp, 16
        pop     rbp

        mov     rax, 60 ; exit syscall
        xor     rdi, rdi
        syscall

    ;   input:
    ; rdi - file descriptor
    ; rsi - string address
    ;   output:
    ; rax = written string len (including 0)
    ; rbx - same
    ; rcx - same
    ; rdx = string len (including 0)
    ; rdi - input
    ; rsi - input
    print_string:
        xor     rdx, rdx
        .loop:
        mov     al, byte [rsi+rdx]
        inc     rdx
        test     al, al
        jnz     .loop

        mov     rax, 1 ; write syscall
        syscall

        ret

    ;   input:
    ; rdi - delay in milliseconds
    ;   output:
    ; rax = 0
    ; rbx - same
    ; rcx - same
    ; rdx - same
    ; rdi = real delay in nanoseconds
    ; rsi = 0
    ms_delay:
        imul    rdi, 1000000
        cmp     rdi, 1000000000
        jl      .ok
        mov     rdi, 999999999
        .ok:
        push    rdi
        xor     rdi, rdi
        push    rdi

        mov     rax, 35 ; nanosleep syscall
        mov     rdi, rsp
        mov     rsi, 0
        syscall

        pop     rdi
        pop     rdi

        ret

section .data
data:
    drawSurface:
        db 27, 91, 72, 27, 91, 74
    surface:
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db "................................................................", 10
        db 0

section .bss
    buf:
        resb 256
