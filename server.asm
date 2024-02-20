section     .data
    ; exit codes
    EXIT_SUCCESS    EQU     0
    EXIT_FALIURE    EQU     1

    ; syscalls
    SYS_EXIT        EQU     60
    SYS_SOCKET      EQU     41
    SYS_BIND        EQU     49
    SYS_LISTEN      EQU     50
    SYS_ACCEPT      EQU     43
    SYS_READ        EQU     0
    SYS_WRITE       EQU     1
    SYS_OPEN        EQU     2
    SYS_CLOSE       EQU     3

    ; some constants
    AF_INET         EQU     2
    SOCK_STREAM     EQU     1
    O_RDONLY        EQU     0

    ; server port number
    PORT            EQU     0x901f  ; port 8080 in little-endian format
    
; This is the sockaddr_in data structure
address:
    sa_family_t     dw      AF_INET
    in_port_t       dw      PORT
    sin_addr        dd      0
                    dq      0       ; Padding

buffer:
    ; define a buffer of size 256 bytes initialized with nulls
    times  256      db      0

buffer2:
    ; this buffer will contain the contents of 'index.html'
    times  256      db      0

path: db "index.html", 0  
     
; This is how arguments are passed into the system in x86_64 architecture:
; rdi   rsi   rdx   r10   r8    r9

section     .text
global _start
_start:
    ; calling SYS_SOCKET

    mov     rax, SYS_SOCKET     ; syscall number
    mov     rdi, AF_INET        ; domain
    mov     rsi, SOCK_STREAM    ; socket type (TCP)
    mov     rdx, 0              ; Protocol (0 for the default protocol)
    syscall

    ; after the syscall is complete we will have the socket_fd stored in rax
    ; i will save it in r12
    mov     r12, rax            ; socket_fd 

    cmp     r12, -1
    je      exit_with_faliure   ; checking for errors

    ; calling SYS_BIND
    
    mov     rax, SYS_BIND
    mov     rdi, r12            ; socket_fd
    mov     rsi, address        ; sockaddr
    mov     rdx, 16             ; addrlen, size of the structure is 16 bytes
    syscall

    ; calling SYS_LISTEN
    mov     rax, SYS_LISTEN
    mov     rdi, r12            ; socket_fd
    mov     rsi, 10             ; backlog
    syscall
    
    cmp     rax, -1
    je      exit_with_faliure

loop:
    ; calling SYS_ACCEPT
    mov     rax, SYS_ACCEPT
    mov     rdi, r12            ; socket_fd
    mov     rsi, 0
    mov     rdx, 0
    syscall
    
    mov     r13, rax            ; client socket_fd

    cmp     r13, -1
    je      exit_with_faliure

    ; reading the client request via SYS_READ
    mov     rax, SYS_READ
    mov     rdi, r13            ; reading the client socket
    mov     rsi, buffer         ; the buffer we will read into
    mov     rdx, 256            ; size of th buffer
    syscall

    cmp     rax, -1
    je      exit_with_faliure

    ; writing back to the client 
    mov     rax, SYS_OPEN
    mov     rdi, path
    mov     rsi, O_RDONLY
    syscall

    ; SYS_READ
    mov     rdi, rax            ; file descriptor returned by SYS_OPEN
    mov     rsi, buffer2        
    mov     rdx, 256
    mov     rax, SYS_READ
    syscall

    ; writing to the client socket via SYS_WRITE
    mov     rax, SYS_WRITE
    mov     rdi, r13
    mov     rsi, buffer2
    mov     rdx, 256
    syscall
    
    ; closing the connection with client via SYS_CLOSE
    mov     rax, SYS_CLOSE
    mov     rdi, r13
    syscall

    cmp     rax, -1
    je      exit_with_faliure

    jmp     loop

    call    exit_with_success
exit_with_faliure:
    ; calling SYS_EXIT, and exiting with error code 1
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_FALIURE   ; error code
    syscall

exit_with_success:
    ; calling SYS_EXIT, and exiting with error code o for success
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_SUCCESS
    syscall

  
