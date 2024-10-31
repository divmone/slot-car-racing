proc BMP.LoadFromFile uses edi esi ebx,\
            fileName
    locals 
        buffer dd 0 
        BMPBuffer dd 0
        BMPBufferSize dd 0
        h dd ?
        w dd ?
    endl
    
    stdcall File.LoadContent, [fileName]
    mov ebx, eax

    ;mov ebx, [buffer]

   

    mov eax, [ebx + BMP.biHeight]
    mov ecx, [ebx + BMP.biWidth]
    mov [h], eax
    mov [w], ecx
    xor edx, edx
    mul ecx

    xor edx, edx
    mov ecx, 3
    mul ecx

    mov [BMPBufferSize], eax
    malloc eax

    mov [BMPBuffer], eax

    mov eax, [ebx + BMP.bfOffBits]
    add ebx, eax

    memcpy [BMPBuffer], ebx, [BMPBufferSize]
    
    stdcall Log, BMP_LOADED_SUCCESSFULLY, BMP_LOADED_SUCCESSFULLY.size
    mov eax, [BMPBuffer]
    mov ecx, [h]
    mov edx, [w]
    ret
endp