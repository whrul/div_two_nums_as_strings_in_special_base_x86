    section .text
    global sdiv
sdiv:
    push    ebx
    push    ebp             
    mov     ebp, esp        
    sub     esp, 12         
                            ; for length of s2 for ecx loop - 4 bytes (ebp - 4)
                            ; for addr of byte of result for wiriting new digit - 4 bytes (ebp - 8)
                            ; carry flag - 1 byte (ebp  - 9)
                            ; has digit on left flag - 1 byte (ebp  - 10)
                            ; length(s1) == length(s2) flag - 1 byte (ebp - 11)
                            
                            ; for addr of current byte in s1, which is last in substraction - 4 bytes (esi)
                            ; for addr of last digit in s2 - 4 bytes (edi)


; --------------------- check input lengthes for detecting s1 < s2 situation  BEGIN -------------------------------------------

    mov     byte [ebp - 11], 0              ; length(s1) == length(s2) flag    
    mov     ebx, [ebp + 20]                 ; s1
divident_length_step:
    mov     dl, [ebx]
    inc     ebx
    test    dl, dl
    jnz     divident_length_step
    sub     ebx, 2                          ; ebx contains addr of byte with last digit in s1
    sub     ebx, [ebp + 20]                 ; ebx contains length-1 of s1
    
    mov     eax, [ebp + 24]                 ; s2
    mov     ecx, eax
divisor_length_step:
    mov     dl, [eax]
    inc     eax
    test    dl, dl
    jnz     divisor_length_step
    sub     eax, 2                          ; eax contains addr of byte with last digit in s2
    mov     edi, eax  
    sub     eax, [ebp + 24]                 ; eax contains length-1 of s2 

divisor_zeros_at_beg_length_to_ignore_step:
    mov     dl, [ecx]
    inc     ecx
    test    dl, dl
    jz      exit_func_div_by_zero
    cmp     dl, '0'                
    je      divisor_zeros_at_beg_length_to_ignore_step
    dec     ecx                             ; ecx contains addr of first not '0' byte in s2
    sub     ecx, [ebp + 24]                 ; ecx contains number of '0' at the beginning of s2
    sub     eax, ecx
    inc     eax
    mov     [ebp - 4], eax
    dec     eax

    mov     edx, [ebp + 16]
    mov     [ebp - 8], edx                 ; addr of current byte in result
    mov     byte [edx], '0'

    cmp     ebx, eax                        ; ebx - s1, eax - s2
    ja      correct_length_of_arg
    jb      exit_func_with_moving_for_zero
    mov     byte [ebp - 11], 1

; --------------------- check input lengthes for detecting s1 < s2 situation END -------------------------------------------


;---------------------- set start parametrs BEGIN ----------------------------------

correct_length_of_arg:
    mov     ebx, [ebp + 20]                 ; s1
    mov     ecx, [ebp + 24]                 ; s2
    mov     byte [ebp  - 10], 0
    jmp     last_dig_s1_for_substr_start
last_dig_s1_for_substr_step:
    inc     ebx
    inc     ecx
last_dig_s1_for_substr_start:
    mov     dh, [ebx]
    mov     dl, [ecx]
;------------------------additional corrections for systems with base > 10 BEGIN----------------------------
    cmp     dh, 'a'
    jb      last_dig_s1_for_substr_s1_not_low_case_let
    sub     dh, 'a'
    add     dh, 'A'
last_dig_s1_for_substr_s1_not_low_case_let:

    cmp     dl, 'a'
    jb      last_dig_s1_for_substr_s2_not_low_case_let
    sub     dl, 'a'
    add     dl, 'A'
last_dig_s1_for_substr_s2_not_low_case_let:
;------------------------additional corrections for systems with base > 10 END------------------------------
    test    dh, dh
    jz      last_dig_s1_for_substr_last_byte
    cmp     dh, dl
    je      last_dig_s1_for_substr_step
last_dig_s1_for_substr_last_byte:
    mov     ebx, [ebp + 20]                 ; s1, flags affected: none
    add     ebx, eax                        ; OF, SF, ZF, AF, CF, and PF flags affected
    cmp     dh, dl                          ; set flags one more time before checking it
    jae     last_dig_s1_for_substr_start_from_first
    
    cmp     byte [ebp - 11], 1              ; s1 length = s2 length flag
    je      exit_func_with_moving_for_zero

    inc     ebx
    mov     byte [ebp  - 10], 1
last_dig_s1_for_substr_start_from_first:
    mov     esi, ebx

;---------------------- set start parametrs END ------------------------------------


;---------------------- main logic BEGIN -------------------------------------------

    jmp     main_loop
main_loop_next:
    mov     eax, esi
    mov     dh, [eax]
    test    dh, dh
    jz      exit_func_without_moving_for_zero
    mov     edx, [ebp - 8]                  ; addr of byte for writing into result
    mov     byte [edx], '0'
main_loop:                                  ; s1 - eax; s2 - ebx
    mov     eax, esi
    mov     ebx, edi
    mov     byte [ebp  - 9], 0              ; carry flag
    mov     ecx, [ebp - 4]                  ; length of s2
nested_loop:
    mov     dh, [eax] 
    mov     dl, [ebx]
;------------------------additional corrections for systems with base > 10 BEGIN----------------------------
    cmp     dh, 'a'
    jb      nested_loop_s1_not_low_case_let
    sub     dh, 'a'
    add     dh, 'A'
nested_loop_s1_not_low_case_let:
    cmp     dh, 'A'
    jb      nested_loop_s1_not_let
    sub     dh, 7                                                           ; 'A' - '9' + 1
nested_loop_s1_not_let:

    cmp     dl, 'a'
    jb      nested_loop_s2_not_low_case_let
    sub     dl, 'a'
    add     dl, 'A'
nested_loop_s2_not_low_case_let:
    cmp     dl, 'A'
    jb      nested_loop_s2_not_let
    sub     dl, 7                                                           ; 'A' - '9' + 1
nested_loop_s2_not_let:
;------------------------additional corrections for systems with base > 10 END------------------------------
    sub     dh, '0' 
    sub     dl, '0'
    cmp     byte [ebp  - 9], 0              ; carry flag
    je      nested_loop_was_not_carry
    test    dh, dh
    jz      nested_loop_can_not_be_carry
    dec     dh
    mov     byte [ebp - 9], 0
    jmp     nested_loop_was_not_carry
nested_loop_can_not_be_carry:
    add     dh, [ebp + 12]                   ; base
    dec     dh
nested_loop_was_not_carry:
    cmp     dh, dl
    jae     nested_loop_can_sub
    add     dh, [ebp + 12]                   ; base
    mov     byte [ebp - 9], 1               ; carry flag
nested_loop_can_sub:
    sub     dh, dl
;------------------------additional corrections for systems with base > 10 BEGIN----------------------------
    cmp     dh, 10
    jb      nested_loop_not_let
    add     byte dh, 7                                                            ; 'A' - '9' + 1
;------------------------additional corrections for systems with base > 10 END------------------------------
nested_loop_not_let:
    add     dh, '0'
    mov     [eax], dh

    dec     eax
    dec     ebx
    loop    nested_loop

    mov     ecx, [ebp - 8]                 ; current byte of result (addr)
    mov     dl, [ecx]
    inc     dl   
    mov     [ecx], dl


    cmp     byte [ebp - 9], 0              ; carry flag
    je      main_loop
    cmp     byte[ebp - 10], 0               ; left neig flag
    je      nested_loop_uncorrect_sub
    mov     dh, [eax]
    cmp     dh, '0'
    je      nested_loop_uncorrect_sub
    dec     dh
    mov     [eax], dh
    jmp     main_loop

nested_loop_uncorrect_sub:
    mov     ecx, [ebp - 8]                 ; current byte of result (addr)
    mov     dl, [ecx]
    dec     dl
    mov     [ecx], dl

    mov     eax, esi
    mov     ebx, edi
    mov     byte [ebp  - 9], 0              ; carry flag
    mov     ecx, [ebp - 4]                  ; length of s2
nested_loop_uncorrect_sub_step:
    mov     dh, [eax]
    mov     dl, [ebx]
;------------------------additional corrections for systems with base > 10 BEGIN----------------------------
    cmp     dh, 'a'
    jb      nested_loop_uncorrect_sub_s1_not_low_case_let
    sub     dh, 'a'
    add     dh, 'A'
nested_loop_uncorrect_sub_s1_not_low_case_let:
    cmp     dh, 'A'
    jb      nested_loop_uncorrect_sub_s1_not_let
    sub     dh, 7                                                           ; 'A' - '9' + 1
nested_loop_uncorrect_sub_s1_not_let:

    cmp     dl, 'a'
    jb      nested_loop_uncorrect_sub_s2_not_low_case_let
    sub     dl, 'a'
    add     dl, 'A'
nested_loop_uncorrect_sub_s2_not_low_case_let:
    cmp     dl, 'A'
    jb      nested_loop_uncorrect_sub_s2_not_let
    sub     dl, 7                                                           ; 'A' - '9' + 1
nested_loop_uncorrect_sub_s2_not_let:
;------------------------additional corrections for systems with base > 10 END------------------------------
    sub     dh, '0'
    sub     dl, '0'
    add     dh, dl
    add     dh, [ebp - 9]                   ; carry
    mov     byte [ebp - 9], 0
    cmp     dh, [ebp + 12]                   ; base
    jb      nested_loop_uncorrect_sub_without_carry
    mov     byte [ebp - 9], 1
    sub     dh, [ebp + 12]
nested_loop_uncorrect_sub_without_carry:
;------------------------additional corrections for systems with base > 10 BEGIN----------------------------
    cmp     dh, 10
    jb      nested_loop_uncorrect_sub_not_let
    add     byte dh, 7                                                            ; 'A' - '9' + 1
;------------------------additional corrections for systems with base > 10 END------------------------------
nested_loop_uncorrect_sub_not_let:
    add     dh, '0'
    mov     [eax], dh
    dec     eax
    dec     ebx
    loop    nested_loop_uncorrect_sub_step

    inc     esi
;------------------------additional corrections for systems with base > 10 BEGIN----------------------------
    mov     eax, [ebp - 8]
    mov     dl, [eax]
    cmp     dl, '9'
    jbe     is_smaller_than_ten
    add     dl, 7                                                                   ; 'A' - '9' + 1
is_smaller_than_ten:
    mov     [eax], dl
;------------------------additional corrections for systems with base > 10 END------------------------------
    inc     dword [ebp - 8]
    mov     byte [ebp - 10], 1              ; has digit on left flag
    jmp     main_loop_next

;---------------------- main logic END ---------------------------------------------

exit_func_div_by_zero:
    mov     eax, [ebp + 16]                 ; result
    mov     [ebp - 8], eax
    jmp     exit_func_without_moving_for_zero
exit_func_with_moving_for_zero:
    inc     dword [ebp - 8]
exit_func_without_moving_for_zero:
    mov     eax, [ebp - 8]
    mov     byte [eax], 0
    mov     eax, [ebp + 16]                 ; result
    mov     esp, ebp        
    pop     ebp 
    pop     ebx            
    ret 

