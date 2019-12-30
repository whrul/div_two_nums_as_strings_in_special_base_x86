    section .text
    global sdiv
sdiv:
    push    ebp             
    mov     ebp, esp        
    sub     esp, 16         ; for addr of last digit in s2 - 4 bytes (ebp - 4)
                            ; for addr of current byte in s1, which is last in substraction - 4 bytes (ebp - 8)
                            ; for addr of byte of result for wiriting new digit - 4 bytes (ebp - 12)
                            ; carry flag - 1 byte (ebp - 13) 

    mov     eax, [ebp + 20] ; s2
divisor_length_step:
    mov     dl, [eax]
    inc     eax
    test    dl, dl
    jnz     divisor_length_step
    sub     eax, 2           ; eax contains addr of byte with last digit in s2
    mov     [ebp - 4], eax  

    sub     eax, [ebp + 20] ; eax contains length-1 of s2 

    mov     ebx, [ebp + 16] ; s1
    mov     ecx, [ebp + 20] ; s2
    jmp     last_dig_s1_for_substr_start
last_dig_s1_for_substr_step:
    inc     ebx
    inc     ecx
last_dig_s1_for_substr_start:
    mov     dh, [ebx]
    mov     dl, [ecx]
    test    dh, dh
    jz      last_dig_s1_for_substr_start_from_first
    cmp     dh, dl
    je      last_dig_s1_for_substr_step
    mov     ebx, [ebp + 16] ; s1
    add     ebx, eax
    cmp     dh, dl                                                  ; or actually not should
    ja      last_dig_s1_for_substr_start_from_first
    inc     ebx
last_dig_s1_for_substr_start_from_first:
    mov     [ebp - 8], ebx

main_loop:
    mov     dl, [ebp - 8]
    test    dl, dl
    jz      exit_func


    inc     dword [ebp - 8]
    jmp     main_loop

exit_func:
    mov     eax, [ebp + 16]
    mov     esp, ebp        
    pop     ebp             
    ret 
    

