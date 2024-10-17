proc VAO.Init uses edi esi ebx,\
        buffer, mesh
        
        locals
           size    dd  ?
        endl


        mov ebx, [buffer]
        invoke glGenVertexArrays, 1, ebx
        
        invoke glBindVertexArray, [ebx]
        
        stdcall  VBO.Init, vertexVBO, Mesh.vertices, [mesh]

        
        ;invoke glGenBuffers, 1, vertexVBO

        ;invoke glBindBuffer, GL_ARRAY_BUFFER, [vertexVBO]

        ;invoke glBufferData, GL_ARRAY_BUFFER, 32, rectVertices, GL_STATIC_DRAW
        
        invoke glEnableVertexAttribArray, 0
    
        invoke glVertexAttribPointer, 0, 3, GL_FLOAT, GL_FALSE, 0, 0

        ;stdcall  VBO.Init, colorsVBO, Mesh.colors, [mesh]

        ;invoke glGenBuffers, 1, vertexVBO

        ;invoke glBindBuffer, GL_ARRAY_BUFFER, [vertexVBO]

        ;invoke glBufferData, GL_ARRAY_BUFFER, 32, rectVertices, GL_STATIC_DRAW
        
        invoke glGenBuffers, 1, colorsVBO

        invoke glBindBuffer, GL_ARRAY_BUFFER, [colorsVBO]

        mov esi, [mesh]

        invoke glBufferData, GL_ARRAY_BUFFER, 20000, zhColors , GL_STATIC_DRAW
        
        invoke glEnableVertexAttribArray, 1
    
        invoke glVertexAttribPointer, 1, 3, GL_FLOAT, GL_FALSE, 0, 0

                 

        ;invoke glGenVertexArrays, 1, containerVAO
        invoke glBindVertexArray, 0

        ;invoke glGenBuffers, 1, vertexVBO
        ;invoke glBindBuffer, GL_ARRAY_BUFFER, [vertexVBO]
        ;invoke glBufferData, GL_ARRAY_BUFFER, 32, rectVertices , GL_STATIC_DRAW

        ;invoke glEnableVertexAttribArray, 0
        ;invoke glVertexAttribPointer, 0, 2, GL_FLOAT, GL_FALSE, 0, 0

        ;invoke glGenBuffers, 1, colorsVBO
        ;invoke glBindBuffer, GL_ARRAY_BUFFER, [colorsVBO]
        ;invoke glBufferData, GL_ARRAY_BUFFER, 100, rectColors , GL_STATIC_DRAW

        ;invoke glEnableVertexAttribArray, 1
        ;invoke glVertexAttribPointer, 1, 3, GL_FLOAT, GL_FALSE, 0, 0
          

    ret
endp