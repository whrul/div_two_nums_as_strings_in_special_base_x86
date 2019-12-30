    section .text
    global sdiv
sdiv:
    push    ebp             
    mov     ebp, esp        
    

exit_func:
    mov     eax, [ebp + 16]
    mov     esp, ebp        
    pop     ebp             
    ret 
    

