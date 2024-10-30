proc BMP.LoadFromFile uses edi esi ebx,\
            fileName
    locals 
        buffer dd 0 
        BMPBuffer dd 0
        BMPBufferSize dd 0
        n dd 0
        number dd 0
    endl
    
    stdcall File.LoadContent, [fileName]
    mov [buffer], eax

    mov ebx, [buffer]

    mov eax, [ebx + BMPHeader.bfOffBits]

    mov eax, [ebx + BMP.biHeight]
    mov ecx, [ebx + BMP.biWidth]
    xor edx, edx
    mul ecx

    xor edx, edx
    mov ecx, 3
    mul ecx

    mov [BMPBufferSize], eax
    malloc eax

    mov [BMPBuffer], eax

    add ebx, BMPHeader.bfOffBits

    memcpy [BMPBuffer], ebx, [BMPBufferSize]
    
    mov eax, [BMPBuffer]
    ret
endp