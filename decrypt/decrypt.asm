; ---------------------------------------------------------------------------
; This program read from a file a series of integer numbers of up to 3 digits
; translates them from ASCII into integer and writes them on memory.
; Then it read that memory and performs the inverse process writing then into 
; output txt file, each separated by a space
; 
; Author: Jose Alejandro Chavarria Madriz
; Email: joalchama@gmail.com
; ---------------------------------------------------------------------------

; -------------------------------------------------
; Macro definitions
; No macros where used
; -------------------------------------------------

; -------------------------------------------------
; Data declarations
section .data
; -----
; Define constants
    EXIT_SUCCESS equ 0                 ; successful operation

    SYS_OPEN     equ 2                 ; call code for open
    SYS_READ     equ 0                 ; call code for read
    SYS_WRITE    equ 1                 ; call code for write
    SYS_CREATE   equ 85                ; call code for file open/create
    SYS_CLOSE    equ 3                 ; call code for file close
    SYS_EXIT     equ 60                ; call code for terminate

    SPACE        equ 0x20              ; ASCII for blank space

    O_RDONLY     equ 000000q           ; read only
    S_IRUSR      equ 00400q
    S_IWUSR      equ 00200q

    ; 640x480
    ; INPUT_IMG_SIZE  equ 614400          ; size of the input image
    ; OUTPUT_IMG_SIZE equ 307200          ; size of the output image

    ; 320x320
    INPUT_IMG_SIZE  equ 204800          ; size of the input image
    OUTPUT_IMG_SIZE equ 102400          ; size of the output image

    NULL equ 0                         ; end of string

; -----
; Provided data
    input_file   db "input.txt",  NULL ; name of the input txt file
    output_file  db "output.txt", NULL ; name of the output txt file
    key_file     db "key.txt", NULL    ; name of the key txt file

    decrypted_counter dq 0             ; different pixels that have been decrypted 

; -----
; Define variables
    str_buffer   db 4 dup (0)          ; buffer to hold converted integers
    file_desc    dq 0                  ; file descriptor
; -------------------------------------------------

; -------------------------------------------------
; Uninitialized data
section .bss
    img_buffer         resq INPUT_IMG_SIZE ; buffer to hold file read data
    key_buffer         resd 2              ; buffer to hold the private key
    decryption_table   resq 255            ; table to hold the decrypted code for quick access

; -------------------------------------------------

; -------------------------------------------------
; Program code
section .text

global _start
_start:

    ; -----
    ; Read input file into memory buffer
    mov rdi, input_file             ; file name string 
    mov rsi, img_buffer             ; set the buffer to store the read data
    call _input                     ; call _input function to read the file

    ; -----
    ; Read private key file into memory buffer
    mov rdi, key_file               ; file name string 
    mov rsi, key_buffer             ; set the buffer to store the read data
    call _input                     ; call _input function to read the file

    ; -----
    ; Load private key (d, n) into registers
    xor r13, r13                    ; clear any thrash in r13
    xor r14, r14                    ; clear any thrash in r14
    mov r13w, word [key_buffer]     ; load private key (d)
    mov r14w, word [key_buffer + 4] ; load private key (n)

    ; Load image buffer address into rbx and r12
    mov rbx, img_buffer             ; set the buffer to read the data from
    mov r12, rbx                    ; r12 has a copy of the address

    ; Decrypt the data in the buffer in 8-byte chunks
    mov rcx, INPUT_IMG_SIZE         ; set the loop counter to image size in bytes

    decrypt_image:
        ; Load the current 8-byte chunk to be decrypted into rdx
        mov rdx, rbx

        ; Call the _decrypt function with arguments d, n, and the current 8-byte chunk
        xor rdi, rdi                ; clear any thrash in rdi
        xor rsi, rsi                ; clear any thrash in rsi
        mov di, r13w                ; pass d as the first argument
        mov si, r14w                ; pass n as the second argument
        push rcx                    ; save rcx on stack
        call _decrypt               ; call _decrypt function to decrypt the data
        pop rcx                     ; restore rcx from stack

        ; Store the decrypted 4-byte chunk to r12
        mov [r12], rax
        add rbx, 8                  ; advance the read pointer by 8 bytes
        add r12, 4                  ; advance the write pointer by 4 bytes

    loop decrypt_image               ; continue looping while rcx is not zero

    ; -----
    ; Write the decrypted data to output file
    call _output                    ; call _output function to write the data

    ; -----
    ; Exit program
    end:
    mov rax, SYS_EXIT               ; system call number for exit
    mov rdi, EXIT_SUCCESS           ; set the exit status as success
    syscall                         ; call the kernel to exit

; Parse space-separated numeric file and load them a integer array to memory
; Arg 1: Name of the file
; Arg 2: Address to store to
global _input
_input:

    ; -----
    ; Open file
    open_file:
    push rsi                   ; save second argument
    mov rax, SYS_OPEN          ; system call number for opening a file
    mov rsi, O_RDONLY          ; read only access
    syscall                    ; call the kernel

    mov qword [file_desc], rax ; save the file descriptor

    ; -----
    ; Read file
    read_file:
    mov rdi, qword [file_desc] ; set file descriptor as argument for the next system call
    pop rsi                    ; retrieve second argument
    xor rbx, rbx               ; initialize a temporary buffer to store the current value being read
    mov r10, 10                ; set r10 to 10 for later multiplication

    ; -----
    ; Read one character at a time, split on space
    read_char:
        mov rax, SYS_READ      ; system call number for reading from a file
        mov rdx, 1             ; read one byte at a time
        syscall                ; read the character into [rsi]

        cmp rax, 0             ; compare the return value with 0 to check for end of file
        je end_read            ; jump to end_read if end of file is reached

        cmp byte [rsi], SPACE  ; check if the current character is a space

        ; If the current character is not a space, convert the character to an integer and add it to the current value
        jne continue_reading
        
        save_value:
        mov [rsi], rbx         ; save the current value
        add rsi, 4             ; move the pointer to the next address in the buffer
        xor rbx, rbx           ; reset the temporary buffer to 0
    jmp read_char              ; jump back to read the next character

        continue_reading:
        mov rax, rbx           ; get current value
        mul r10                ; multiply it by 10
        mov rbx, rax           ; save the result to the temporary buffer
        movzx eax, byte [rsi]  ; load the input character into the lower 8 bits of eax
        sub al, '0'            ; convert from ASCII to int
        add rbx, rax           ; add the converted character to the temporary buffer
    jmp read_char              ; jump back to read the next character

    end_read:
    mov [rsi], rbx             ; save the last value
ret                            ; return from the function

; Decrypt RSA data
; Arg 1: Private key (d)
; Arg 2: Private key (n)
; Arg 3: Memory address of data (read)
global _decrypt
_decrypt:

    ; Load encrypted number
    ; The encrypted number is stored at the memory address given in the third argument
    ; It consists of two bytes, the most significant byte (MSB) at offset 0 and the least significant byte (LSB) at offset 4
    xor rcx, rcx             ; clear any thrash
    mov cl,  byte [rdx]      ; load MSB byte
    shl rcx, 8               ; shift it 
    mov r8b, byte [rdx+4]    ; load LSB byte
    add rcx, r8              ; add it to the MSB

    ; Search decryption table
    ; A table is used to store previously decrypted values
    ; This loop searches for the encrypted value in the table
    ; If found, the corresponding decrypted value is returned
    mov rax, decryption_table
    xor r9, r9
    search_loop:
        add r9, 4                    ; increment the index of the table entry being checked
        cmp r9, [decrypted_counter]  ; compare the index to the number of entries in the table
        ja start_decrypt             ; if the index is greater than the number of entries, the value needs to be decrypted
        mov dx, word[rax]            ; load the encrypted value from the current entry
        add rax, 4                   ; increment the pointer to the next entry in the table
        cmp cx, dx                   ; compare the encrypted value to the input value
    jne search_loop                  ; if the values don't match, keep searching
    sub rax, 4                       ; if the encrypted value is found in the table, go back one entry to get the corresponding decrypted value
    mov rax, [rax]                   ; load the decrypted value
    shr rax, 16                      ; shift the value right by 16 bits to get rid of the padding
    jmp decoded                      ; jump to the end of the function to return the decrypted value
    
    ; If the encrypted value is not found in the table, it needs to be decrypted using the private key
    ; The following loop performs the modular exponentiation algorithm to decrypt the value
    ; c^d mod n
    ; rax = rcx^rdi mod rsi
    start_decrypt:
    xor rax, rax                     ; clear rax (accumulator)
    mov rax, 1                       ; initialize rax to 1
    push rcx                         ; push rcx (the encrypted value) onto the stack
    decrypt_loop:
        mov r8, rdi                  ; copy rdi (the private key exponent) to r8
        and r8, 1                    ; check the least significant bit of r8
        cmp r8, 0                    ; compare to zero
        je next_bit                  ; if r8 is 0, skip the that power of 2
        mul rcx                      ; multiply rax by rcx.
        div rsi                      ; divide by n to get the remainder.
        mov rax, rdx                 ; move the remainder to rax.
        next_bit:
        shr rdi, 1                   ; shift the private key exponent right by one bit.
        cmp rdi, 0                   ; check if the private key exponent is zero.
        je store_decode              ; if it's 0, jump to store_decode
        push rax                     ; push the current value of rax to the stack
        mov rax, rcx                 ; move the value of rcx to rax
        mul rcx                      ; multiply rax by rcx
        div rsi                      ; divide the result by rsi
        mov rcx, rdx                 ; move the remainder to rcx (the result of multiplying rcx with rax)
        pop rax                      ; pop the previous value of rax from the stack
    jmp decrypt_loop                 ; jump back to decrypt_loop and repeat the process with the next bit

    ; Store the decoded number
    ; Both the encrypted number and its decryption are strored on the same memory address
    store_decode:
    mov rdi, rax                     ; move the decoded number to rdi
    shl rdi, 16                      ; shift left by 16 bits
    pop rcx                          ; pop the original encrypted number from the stack
    add rdi, rcx                     ; add the original encrypted number to rdi
    mov rsi, decryption_table        ; move the address of decryption_table to rsi
    add rsi, [decrypted_counter]     ; add the decrypted_counter to the address of decryption_table
    mov [rsi], rdi                   ; store the decoded number at the current index of decryption_table
    add qword [decrypted_counter], 4 ; increment the decrypted_counter by 4 bytes (since we are using it as addressing offset too)

    decoded:
ret                                  ; Return from the function, the decoded number is now stored in decryption_table, and the result in rax

; Create a space-separated txt file from array of integers in memory
global _output
_output:
    ; -----
    ; Create the file
    create_file:
    mov rax, SYS_CREATE            ; set rax to call code for file open/create
    mov rdi, output_file           ; set rdi to output_file string
    mov rsi, S_IRUSR | S_IWUSR     ; set rsi to permissions for read/write
    syscall                        ; call kernel to open/create file

    mov qword [file_desc], rax     ; save file descriptor

    ; -----
    ; Write the file
    write_file:
    mov rbx, img_buffer            ; set rbx to beginning of integer array
    mov rcx, OUTPUT_IMG_SIZE       ; set rcx to buffer size

    write_loop:
        mov rdx, [rbx]             ; set rdx to current integer in array
        xor rdi, rdi               ; set rdi to 0
        mov dil, dl                ; set lower 8 bits of rdi to lower 8 bits of rdx
        push rcx                   ; push current buffer size to stack
        call _int_to_str           ; call subroutine to convert integer to string
        mov rdx, 4                 ; set rdx to write 4 characters to file
        cmp rdi, 100               ; compare rdi to 100
        jae write_number           ; if rdi is greater than or equal to 100, write 4 characters
        mov rdx, 3                 ; set rdx to write 3 characters to file
        cmp rdi, 10                ; compare rdi to 10
        jae write_number           ; if rdi is greater than or equal to 10, write 3 characters
        mov rdx, 2                 ; set rdx to write 2 characters to file

        ; -----
        ; Write the number
        write_number:
        mov rax, SYS_WRITE         ; system call to write to file
        mov rdi, qword [file_desc] ; file descriptor
        mov rsi, str_buffer        ; string buffer containing ASCII representation of number
        syscall                    ; call the kernel to write to the file
        pop rcx                    ; restore the loop counter from the stack
        add rbx, 4                 ; increment the array pointer to the next integer
    loop write_loop                ; repeat until all integers in array have been processed
  
    ; -----
    ; Close the file
    close_file:
    mov rax, SYS_CLOSE             ; call code for file close
    mov rdi, qword [file_desc]     ; file descriptor to close
    syscall                        ; call the kernel to close to the file
ret                                ; return from the function

; Convert integer to string
_int_to_str:
    push rbx              ; preserve the value of RBX register
    mov eax, edi          ; number to be converted
    mov ecx, 10           ; divisor for decimal conversion
    xor bx, bx            ; count digits

    divide:
        xor edx, edx      ; high part = 0
        div ecx           ; EAX = EDX:EAX / ECX, EDX = remainder
        push dx           ; DL is a digit in range [0..9]
        inc bx            ; count digits
        test eax, eax     ; is EAX zero?
    jnz divide            ; no, continue division

    ; POP digits from stack in reverse order
    mov cx, bx            ; number of digits
    lea rsi, str_buffer   ; DS:SI points to string buffer

    ; Append space character to the beginning of the string
    mov byte [rsi], SPACE ; DS:SI points to string buffer
    inc si

    next_digit:
        pop ax            ; retrieve the next digit
        add al, '0'       ; convert digit to ASCII
        mov [rsi], al     ; write it to the buffer
        inc si            ; move to the next position in buffer
    loop next_digit       ; loop until all digits have been processed

    pop rbx               ; restore the value of RBX register
ret                       ; return from the function