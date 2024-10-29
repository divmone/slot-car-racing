proc BMP.LoadFromFile uses edi esi ebx,\
            fileName
    locals 
        buffer BMP 
        n dd 0
    endl
    
    stdcall File.LoadContent, [fileName]
    mov [buffer], eax

    mov ebx, [buffer]

    mov eax, [ebx + BMPHeader.bfOffBits]

    mov eax, [ebx + BMP.biHeight]
    mov [buffer + BMP.biHeight], eax
    stdcall IntToStr, [buffer + BMP.biHeight]
    mov [n], eax
    stdcall GetNumberLength, eax

    stdcall Log, [n], eax 

    
 
    ret
endp