    section .text
    global sdiv
sdiv:
    push    ebp             
    mov     ebp, esp        
    sub     esp, 20         ; for addr of last digit in s2 - 4 bytes (ebp - 4)
                            ; for length of s2 for ecx loop - 4 bytes (ebp - 8)
                            ; for addr of current byte in s1, which is last in substraction - 4 bytes (ebp  - 12)
                            ; for addr of byte of result for wiriting new digit - 4 bytes (ebp - 16)
                            ; carry flag - 1 byte (ebp  - 17) 
                            ; has digit on left flag - 1 byte (ebp  - 18)

    mov     eax, [ebp + 20] ; s2
divisor_length_step:
    mov     dl, [eax]
    inc     eax
    test    dl, dl
    jnz     divisor_length_step
    sub     eax, 2           ; eax contains addr of byte with last digit in s2
    mov     [ebp - 4], eax  

    sub     eax, [ebp + 20] ; eax contains length-1 of s2 
    inc     eax
    mov     [ebp - 8], eax
    dec     eax

    mov     ebx, [ebp + 16] ; s1
    mov     ecx, [ebp + 20] ; s2
    mov     byte [ebp  - 18], 0
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
    mov     byte [ebp  - 18], 1
last_dig_s1_for_substr_start_from_first:
    mov     [ebp  - 12], ebx

    mov     eax, [ebp + 12]
    mov     [ebp - 16], eax ; addr of current byte in result


main_loop:                  ; s1 - eax; s2 - ebx
    mov     eax, [ebp  - 12]
    mov     ebx, [ebp - 4]
    mov     byte [ebp  - 17], 0  ; carry flag
    mov     ecx, [ebp - 8]  ; length of s2

    mov     dh, [eax]
    test    dh, dh
    jz      exit_func
    mov     byte [ebp - 16], '0'

nested_loop:
    mov     dh, [eax] 
    mov     dl, [ebx]
    sub     dh, '0'
    sub     dl, '0'
    cmp     byte [ebp  - 17], 0  ; carry flag
    je      nested_loop_was_not_carry
    test    dh, dh
    jz      nested_loop_can_not_be_carry
    dec     dh
    mov     byte [ebp - 17], 0
    jmp     nested_loop_was_not_carry
nested_loop_can_not_be_carry:
    add     dh, [ebp + 8]       ; base
    dec     dh
nested_loop_was_not_carry:
    cmp     dh, dl
    jae     nested_loop_can_sub
    add     dh, [ebp + 8]       ; base
    mov     byte [ebp - 17], 1  ; carry flag
nested_loop_can_sub:
    sub     dh, dl
    add     dh, '0'
    mov     [eax], dh

    dec     eax
    dec     ebx
    loop    nested_loop


    cmp     byte [ebp - 17], 0  ; carry flag
    je      main_loop
    cmp     byte[ebp - 18], 0   ; left neig flag
    je      nested_loop_uncorrect_sub
    mov     dh, [eax]
    cmp     dh, '0'
    je      nested_loop_uncorrect_sub
    dec     dh
    mov     [eax], dh
    jmp     main_loop

nested_loop_uncorrect_sub:
    mov     eax, [ebp  - 12]
    mov     ebx, [ebp - 4]
    mov     byte [ebp  - 17], 0  ; carry flag
    mov     ecx, [ebp - 8]  ; length of s2
nested_loop_uncorrect_sub_step:
    mov     dh, [eax]
    mov     dl, [ebx]
    sub     dh, '0'
    sub     dl, '0'
    add     dh, dl
    add     dh, [ebp - 17] ; carry
    mov     byte [ebp - 17], 0
    cmp     dh, [ebp + 8] ; base
    jb      nested_loop_uncorrect_sub_without_carry
    mov     byte [ebp - 17], 1
    sub     dh, [ebp + 8]
nested_loop_uncorrect_sub_without_carry:
    add     dh, '0'
    mov     [eax], dh
    dec     eax
    dec     ebx
    loop    nested_loop_uncorrect_sub_step

main_loop_next:
    inc     dword [ebp - 12]
    mov     byte [ebp - 18], 1  ; has digit on left flag
    jmp     main_loop

exit_func:
    mov     eax, [ebp + 16]
    mov     esp, ebp        
    pop     ebp             
    ret 
    

