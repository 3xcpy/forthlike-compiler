format ELF64 executable 3
segment readable executable
print:
    mov rax, [r15]    ; POP compiler intrinsic
    sub r15, 8
    mov rdi, rax
    mov     r9, -3689348814741910323
    sub     rsp, 40
    mov     BYTE [rsp+31], 1
    lea     rcx, [rsp+30]
.L2:
    mov     rax, rdi
    lea     r8, [rsp+32]
    mul     r9
    mov     rax, rdi
    sub     r8, rcx
    shr     rdx, 3
    lea     rsi, [rdx+rdx*4]
    add     rsi, rsi
    sub     rax, rsi
    add     eax, 48
    mov     BYTE [rcx], al
    mov     rax, rdi
    mov     rdi, rdx
    mov     rdx, rcx
    sub     rcx, 1
    cmp     rax, 9
    ja      .L2
    lea     rax, [rsp+32]
    mov     edi, 1
    sub     rdx, rax
    xor     eax, eax
    lea     rsi, [rsp+32+rdx]
    mov     rdx, r8
    mov     rax, 1
    syscall
    add     rsp, 40
    ret
entry start
start:
    mov r15, mem
   call print
    add r15, 8    ; PUSH compiler intrinsic
    mov QWORD [r15], 3
    add r15, 8    ; PUSH compiler intrinsic
    mov QWORD [r15], 2
    mov rax, [r15]    ; POP compiler intrinsic
    sub r15, 8
    add [r15], rax    ; ADD compiler intrinsic
    mov rax, 60
    mov rdi, 0
    syscall
   segment readable writable
mem:  rb 4096
