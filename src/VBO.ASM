proc VBO.Init 
    
     mov esi , car

    xor edx, edx
    mov ecx, sizeof.Vertex
    mov eax, [esi + Mesh.verticesCount]
    mul ecx
    mov [vCount], eax
    
    invoke glGenBuffers, 1, vertexVBO
    invoke glBindBuffer, GL_ARRAY_BUFFER, [vertexVBO]
    invoke glBufferData, GL_ARRAY_BUFFER, [vCount], [esi + Mesh.vertices], GL_STATIC_DRAW
    invoke glBindBuffer, GL_ARRAY_BUFFER, 0

    

    ret
endp