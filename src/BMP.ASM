proc BMP.LoadFromFile uses edi esi ebx,\
            fileName
    locals 
        buffer BMP ?
    endl
    
    stdcall File.LoadContent, [fileName]
    mov [buffer], eax

    mov ebx, [buffer]
    stdcall  Log, [buffer], ebx

    ret
endp