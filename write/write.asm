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

BUFF_SIZE    equ 255 

NULL equ 0 ; end of string

; -----
; Provided Data
filename  db "test.txt", NULL
text  db "This is a write test"
len dq $-text
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
    mov rax, SYS_WRITE
    mov rdi, qword [file_desc]
    mov rsi, text
    mov rdx, qword [len]
    syscall

    ; -----
    ; Close the file
    mov rax, SYS_CLOSE
    mov rdi, qword [file_desc]
    syscall

    ; -----
    ; Exit program
    end:
        mov rax, SYS_EXIT ; call code for exit
        mov rdi, EXIT_SUCCESS ; exit with success
        syscall