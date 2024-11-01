proc VAO.Init uses edi esi ebx,\
        buffer, mesh, vertexVBO, normalsVBO
        
        locals
           size    dd  ?
        endl

        mov ebx, [buffer]
        
        invoke glGenVertexArrays, 1, ebx
        
        invoke glBindVertexArray, [ebx]
        
        stdcall  VBO.Init, [vertexVBO], Mesh.vertices, [mesh]

        invoke glEnableVertexAttribArray, 0
    
        invoke glVertexAttribPointer, 0, 3, GL_FLOAT, GL_FALSE, 0, 0

        stdcall  VBO.Init, [normalsVBO], Mesh.normals, [mesh]

        invoke glEnableVertexAttribArray, 1
    
        invoke glVertexAttribPointer, 1, 3, GL_FLOAT, GL_FALSE, 0, 0

        invoke glGenBuffers, 1, textVBO
        invoke glBindBuffer, GL_ARRAY_BUFFER, [textVBO]

        mov esi , [mesh]
        xor edx, edx
        mov ecx, sizeof.TextCoord
        mov eax, [esi + Mesh.verticesCount]
        mul ecx
        mov [size], eax
        
        invoke glBufferData, GL_ARRAY_BUFFER, [size] ,[textCoord], GL_STATIC_DRAW

        invoke glEnableVertexAttribArray, 2
    
        invoke glVertexAttribPointer, 2, 2, GL_FLOAT, GL_FALSE, 0, 0
        
        invoke glBindVertexArray, 0
    ret
endp