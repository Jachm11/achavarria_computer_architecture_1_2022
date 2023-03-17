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

SYS_OPEN     equ 2  ; call code for open
SYS_READ     equ 0  ; call code for read
SYS_WRITE    equ 1  ; call for write
SYS_CREATE   equ 85 ; file open/create
SYS_CLOSE    equ 3 ; file close
SYS_EXIT     equ 60 ; call code for terminate

SPACE        equ 0x20 ; ASCII for blank space

STDOUT equ 1 ; standard output

O_RDONLY     equ 000000q ; read only

S_IRUSR equ 00400q
S_IWUSR equ 00200q
S_IXUSR equ 00100q


BUFF_SIZE    equ 6 

NULL equ 0 ; end of string

; -----
; Provided Data
filename  db "test.txt", NULL
text  dd 1, 222, 34, 88, 23, 123, 3 
str_buffer db 4 dup (0) 
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
    ; Create the file
    create_file:
    mov rax, SYS_CREATE ; file open/create
    mov rdi, filename ; file name string
    mov rsi, S_IRUSR | S_IWUSR ; allow read/write
    syscall ; call the kernel

    mov qword [file_desc], rax ; save descriptor

    ; -----
    ; Write the file
    write_file:

        mov rbx, text
        mov rcx, BUFF_SIZE

        write_loop:
        mov rdx, [rbx]
        xor rdi, rdi
        mov dil, dl
        push rcx
        call _int_to_str
        mov rdx, 4         ;We'll write 4 characters
        cmp rdi, 100
        jae write_number
        mov rdx, 3         ;We'll write 3 characters
        cmp rdi, 10
        jae write_number
        mov rdx, 2        ;We'll write 2 characters

        ; -----
        ; Write the number
        write_number:
            mov rax, SYS_WRITE
            mov rdi, qword [file_desc]
            mov rsi, str_buffer
            syscall
        pop rcx
        add rbx, 4
        loop write_loop    
    ; -----
    ; Close the file
    close_file:
        mov rax, SYS_CLOSE
        mov rdi, qword [file_desc]
        syscall

    ; -----
    ; Exit program
    end:
        mov rax, SYS_EXIT ; call code for exit
        mov rdi, EXIT_SUCCESS ; exit with success
        syscall

_int_to_str:
        push rbx
        mov eax, edi        ; number to be converted  
        mov ecx, 10         ; divisor
        xor bx, bx          ; count digits

    divide:
        xor edx, edx        ; high part = 0
        div ecx             ; eax = edx:eax/ecx, edx = remainder
        push dx             ; DL is a digit in range [0..9]
        inc bx              ; count digits
        test eax, eax       ; EAX is 0?
        jnz divide          ; no, continue

        ; POP digits from stack in reverse order
        mov cx, bx          ; number of digits
        lea rsi, str_buffer   ; DS:SI points to string buffer

        ; Append space character to the beginning of the string
        mov byte [rsi], SPACE ; DS:SI points to string buffer
        inc si

    next_digit:
        pop ax
        add al, '0'         ; convert to ASCII
        mov [rsi], al       ; write it to the buffer
        inc si
        loop next_digit

        pop rbx
        ret