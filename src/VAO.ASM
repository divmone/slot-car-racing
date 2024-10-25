proc VAO.Init uses edi esi ebx,\
        buffer, mesh
        
        locals
           size    dd  ?
        endl

        mov ebx, [buffer]
        
        invoke glGenVertexArrays, 1, ebx
        
        invoke glBindVertexArray, [ebx]
        
        stdcall  VBO.Init, vertexVBO, Mesh.vertices, [mesh]

        invoke glEnableVertexAttribArray, 0
    
        invoke glVertexAttribPointer, 0, 3, GL_FLOAT, GL_FALSE, 0, 0

        stdcall  VBO.Init, normalsVBO, Mesh.normals, [mesh]

        invoke glEnableVertexAttribArray, 2
    
        invoke glVertexAttribPointer, 2, 3, GL_FLOAT, GL_FALSE, 0, 0
        
        invoke glGenBuffers, 1, colorsVBO

        invoke glBindBuffer, GL_ARRAY_BUFFER, [colorsVBO]

        mov esi , [mesh]
        xor edx, edx
        mov ecx, sizeof.Vertex 
        mov eax, [esi + Mesh.verticesCount]
        mul ecx
        mov [size], eax

        add esi, Mesh.colors

        invoke glBufferData, GL_ARRAY_BUFFER, [size], [esi] , GL_STATIC_DRAW
        
        invoke glEnableVertexAttribArray, 1
    
        invoke glVertexAttribPointer, 1, 3, GL_FLOAT, GL_FALSE, 0, 0

        invoke glBindVertexArray, 0
    ret
endp