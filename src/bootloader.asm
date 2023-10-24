org 0x7C00
bits 16

start:
    jmp main

puts:
    ; save registers that we will modify
    push si ; pushes the SI(Source Index) register to the top of the stack
    push ax

; for printing the data
.loop:
    lodsb ; loads a byte from the memory into AL register (ax -> al|ah(8-bit))
    or al, al ; check OR between the same value and raise zero flag if al is null (zero)
    jz .done ; jz-> jump if zero to destination

    mov ah, 0x0e ; for printing data
    int 0x010 ; interrupts software to call a BIOS or video service routine
    ; the interrupt type depends on the value of ah 
    ; 0x010 is associated with video signal
    jmp .loop

.done:
    pop ax ; to restore the original value of the ax
    pop si 
    ret
main:
    ; we cannot write the data directly into ds / es so 
    ; we first put it in general register
    ; then move them from there to ds / es
    mov ax, 0 ; copies value 0 to ax
    mov ds, ax ; Now the the word or data is in gpr which we copy from ax to ds
    mov es, ax

    ;Stack data
    mov ss, ax
    mov sp, 0x7C00 ; move the pointer to address where the bios loads the mbr

    mov si , hello_string
    call puts

    hlt

.halt:
    jmp .halt
hello_string db 'Hello, world!', 0
times 510-($-$$) db 0 ; fills 510 bytes $-> assembly position of beginnig of the current line
                      ; $$-> gives the position of the beginning of the current section ($-$$)-> length of the program so far in bytes
dw 0AA55h ; 2 byte constant generally refered to as word
