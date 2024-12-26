proc VBO.Create uses esi edi ebx,\
        buffer, sizeOfType, offset, mesh 
    
    locals
        size    dd  ?
    endl

    mov esi , [mesh]
    xor edx, edx
    mov ecx, [sizeOfType]
    mov eax, [esi + Mesh.verticesCount]
    mul ecx
    mov [size], eax
    
    invoke glGenBuffers, 1, [buffer]
    mov ebx, [buffer]
    mov ebx, [ebx]
    invoke glBindBuffer, GL_ARRAY_BUFFER, ebx

    add esi, [offset]
    invoke glBufferData, GL_ARRAY_BUFFER, [size], [esi], GL_STATIC_DRAW
  
    ret
endp