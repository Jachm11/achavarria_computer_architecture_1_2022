; -------------------------------------------------
; This program read from memory an array of integer numbers of up to 3 digits
; translates them into ASCII and writes them on a output txt file, each separated
; by a space
; -------------------------------------------------

; -------------------------------------------------
; Macro definitions
; No macros where used

; -------------------------------------------------
; Data declarations
section .data
; -----
; Define constants
EXIT_SUCCESS equ 0  ; successful operation

SYS_OPEN     equ 2  ; call code for open
SYS_READ     equ 0  ; call code for read
SYS_WRITE    equ 1  ; call code for write
SYS_CREATE   equ 85 ; call code for file open/create
SYS_CLOSE    equ 3  ; call code for file close
SYS_EXIT     equ 60 ; call code for terminate

SPACE        equ 0x20 ; ASCII for blank space

STDOUT equ 1 ; standard output

O_RDONLY     equ 000000q ; read only

S_IRUSR equ 00400q
S_IWUSR equ 00200q

BUFF_SIZE    equ 6 

NULL equ 0 ; end of string

; -----
; Provided Data
filename  db "ouput.txt", NULL
text  dd 1, 222, 34, 88, 23, 123, 3 ; array of integers to be written to file
str_buffer db 4 dup (0)             ; buffer to hold converted integers
file_desc dq 0                      ; file descriptor for output file


; -----
; Additional variables

; -------------------------------------------------
; Uninitialized data
section .bss
read_buffer resb BUFF_SIZE ; buffer to hold file read data

; -------------------------------------------------
; Program code
section .text

global _start
_start:
    ; -----
    ; Create the file
    create_file:
    mov rax, SYS_CREATE ; set rax to call code for file open/create
    mov rdi, filename ; set rdi to filename string
    mov rsi, S_IRUSR | S_IWUSR ; set rsi to permissions for read/write
    syscall ; call kernel to open/create file

    mov qword [file_desc], rax ; save file descriptor

    ; -----
    ; Write the file
    write_file:
    mov rbx, text ; set rbx to beginning of integer array
    mov rcx, BUFF_SIZE ; set rcx to buffer size

    write_loop:
        mov rdx, [rbx] ; set rdx to current integer in array
        xor rdi, rdi ; set rdi to 0
        mov dil, dl ; set lower 8 bits of rdi to lower 8 bits of rdx
        push rcx ; push current buffer size to stack
        call _int_to_str ; call subroutine to convert integer to string
        mov rdx, 4 ; set rdx to write 4 characters to file
        cmp rdi, 100 ; compare rdi to 100
        jae write_number ; if rdi is greater than or equal to 100, write 4 characters
        mov rdx, 3 ; set rdx to write 3 characters to file
        cmp rdi, 10 ; compare rdi to 10
        jae write_number ; if rdi is greater than or equal to 10, write 3 characters
        mov rdx, 2 ; set rdx to write 2 characters to file

        ; -----
        ; Write the number
        write_number:
        mov rax, SYS_WRITE ; system call to write to file
        mov rdi, qword [file_desc] ; file descriptor
        mov rsi, str_buffer ; string buffer containing ASCII representation of number
        syscall ; call the kernel to write to the file
        pop rcx ; restore the loop counter from the stack
        add rbx, 4 ; increment the array pointer to the next integer
    loop write_loop ; repeat until all integers in array have been processed
  
    ; -----
    ; Close the file
    close_file:
    mov rax, SYS_CLOSE      ; call code for file close
    mov rdi, qword [file_desc] ; file descriptor to close
    syscall ; call the kernel to close to the file

    ; -----
    ; Exit program
    end:
        mov rax, SYS_EXIT          ; call code for program exit
        mov rdi, EXIT_SUCCESS      ; exit with success
        syscall

    ; Convert integer to string
_int_to_str:
    push rbx              ; preserve the value of RBX register
    mov eax, edi          ; number to be converted
    mov ecx, 10           ; divisor for decimal conversion
    xor bx, bx            ; count digits

    divide:
        xor edx, edx          ; high part = 0
        div ecx               ; EAX = EDX:EAX / ECX, EDX = remainder
        push dx               ; DL is a digit in range [0..9]
        inc bx                ; count digits
        test eax, eax         ; is EAX zero?
    jnz divide            ; no, continue division

    ; POP digits from stack in reverse order
    mov cx, bx            ; number of digits
    lea rsi, str_buffer   ; DS:SI points to string buffer

    ; Append space character to the beginning of the string
    mov byte [rsi], SPACE ; DS:SI points to string buffer
    inc si

    next_digit:
        pop ax               ; retrieve the next digit
        add al, '0'          ; convert digit to ASCII
        mov [rsi], al        ; write it to the buffer
        inc si               ; move to the next position in buffer
    loop next_digit      ; loop until all digits have been processed

    pop rbx              ; restore the value of RBX register
    ret                  ; return from the function