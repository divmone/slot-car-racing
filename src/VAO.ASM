proc VAO.Init uses edi esi ebx,\
        buffer, mesh
        
        locals
           size         dd      ?
           vertexVBO    GLuint  ?
           normalsVBO   GLuint  ?
           textVBO      GLuint  ?
        endl

        mov ebx, [buffer]
        
        invoke glGenVertexArrays, 1, ebx
        
        invoke glBindVertexArray, [ebx]
        
        lea eax, [vertexVBO]
        stdcall  VBO.Create, eax, sizeof.Vertex, Mesh.vertices, [mesh]

        invoke glEnableVertexAttribArray, 0
    
        invoke glVertexAttribPointer, 0, 3, GL_FLOAT, GL_FALSE, 0, 0

        lea eax, [normalsVBO]

        stdcall  VBO.Create, eax, sizeof.Vertex , Mesh.normals, [mesh]

        invoke glEnableVertexAttribArray, 1
    
        invoke glVertexAttribPointer, 1, 3, GL_FLOAT, GL_FALSE, 0, 0

        lea eax, [textCoord]
        
        stdcall  VBO.Create, eax, sizeof.TextCoord, Mesh.texCoords, [mesh]

        invoke glEnableVertexAttribArray, 2
    
        invoke glVertexAttribPointer, 2, 2, GL_FLOAT, GL_FALSE, 0, 0
        
        invoke glBindVertexArray, 0
    ret
endp