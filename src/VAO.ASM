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
        
        invoke glBindVertexArray, 0
    ret
endp