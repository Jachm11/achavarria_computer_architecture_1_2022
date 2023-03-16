; -------------------------------------------------
; This is a basic x86_64 template
; -------------------------------------------------

; -------------------------------------------------
; Macro definitions


; -------------------------------------------------
; Data declarations
section .data
; -----
; Define constants
EXIT_SUCCESS equ 0 ; successful operation

SYS_OPEN     equ 2 ; call code for open
SYS_READ     equ 0 ; call code for read
SYS_WRITE    equ 1 ; call for write
SYS_EXIT     equ 60 ; call code for terminate

SPACE        equ 0x20 ; ASCII for blank space

STDOUT equ 1 ; standard output

O_RDONLY     equ 000000q ; read only
BUFF_SIZE    equ 255 

NULL equ 0 ; end of string

; -----
; Provided Data
filename  db "test.txt", NULL
file_desc dq 0

; -----
; Additional variables

; -------------------------------------------------
; Uninitialized data
section .bss
read_buffer resb BUFF_SIZE

; -------------------------------------------------
; Program code
section .text

global _start
    _start:
    ; -----
    ; Open file
    open_file:
        mov rax, SYS_OPEN ; file open
        mov rdi, filename ; file name string
        mov rsi, O_RDONLY ; read only access
        syscall ; call the kernel 

        mov qword [file_desc], rax ; save descriptor

    ; -----
    ; Read file
    read_file:
        mov rdi, qword [file_desc]
        mov rsi, read_buffer
        mov rdx, 1     ; read one byte at a time
        xor rbx, rbx   ; temp_buffer
        mov r10, 10


        read_char:
            mov rax, SYS_READ
            mov rdx, 1     ; read one byte at a time
            syscall                ; read char goes to [rsi]
            cmp rax, 0             ; check if end of file has been reached
            je end_read            ; jump to end_read if end of file is reached
            cmp byte [rsi], SPACE       ; if space then save_number and go to next
            je save_value
            mov rax, rbx           ; get current value
            mul r10                ; multiply it by 10
            mov rbx, rax           ; save it on rbx
            movzx eax, byte [rsi]  ; load the input character into the lower 8 bits of eax
            sub al, '0'            ; covert from ASCII to int
            add rbx, rax
            jmp read_char

            save_value:
                mov [rsi], rbx
                add rsi, 4  ; point to next address
                jmp read_char

        end_read:
        ; -----
        ; Print the buffer.
        ; add the NULL for the print string
        mov rsi, read_buffer
        mov byte [rsi+rax], NULL
        mov rdi, read_buffer
        call print

    ; -----
    ; Exit program
    end:
        mov rax, SYS_EXIT ; call code for exit
        mov rdi, EXIT_SUCCESS ; exit with success
        syscall

;---------
;Arguments:
; 1) address of the string
global print
    print:
        push rbp
        mov  rbp, rsp
        push rbx
        ; -----
        ; Count characters in string.
        mov rbx, rdi
        mov rdx, 0
    str_count_loop:
        cmp byte [rbx], NULL
        je str_count_done
        inc rdx
        inc rbx
        jmp str_count_loop
    str_count_done:
        cmp rdx, 0
        je print_done
        ; -----
        ; Call OS to output string.
        mov rax, SYS_WRITE ; code for write()
        mov rsi, rdi ; addr of characters
        mov rdi, STDOUT ; file descriptor
        ; count set above
        syscall ; system call
        ; -----
        ; String printed, return to calling routine.
        print_done:
        pop rbx
        pop rbp
        ret