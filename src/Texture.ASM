proc Texture.Create ,textPath
    locals
        temp dd 0 
        texture GLuint 0  
    endl

    lea eax, [texture]
    invoke glGenTextures, 1, eax
    invoke glBindTexture, GL_TEXTURE_2D, [texture]
    
    stdcall BMP.LoadFromFile, [textPath]
    mov [temp], eax
    invoke glTexImage2D, GL_TEXTURE_2D, 0, GL_RGB,  ecx, edx, 0, GL_BGR, GL_UNSIGNED_BYTE, eax   
    invoke glGenerateMipmap, GL_TEXTURE_2D
        invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT
        invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT
        invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR 
        invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_LINEAR 
    
    invoke HeapFree, [hHeap], 0, [temp]
    invoke glBindTexture, GL_TEXTURE_2D, 0

    mov eax, [texture]
    ret
endp