proc Interface.CreateRectangle, objPtr
     locals
          vao dd ?
          vbo dd ?
     endl

     mov esi, [objPtr]
     add esi, Object.VAO

     invoke glGenVertexArrays, 1, esi      
     invoke glBindVertexArray, [esi]

     lea eax, [vbo]
     invoke glGenBuffers, 1, eax
     invoke glBindBuffer, GL_ARRAY_BUFFER, [vbo]
     invoke glBufferData, GL_ARRAY_BUFFER, 48, rectangleV, GL_STATIC_DRAW

     invoke glEnableVertexAttribArray, 0
    
     invoke glVertexAttribPointer, 0, 2, GL_FLOAT, GL_FALSE, 0, 0

     invoke glBindVertexArray, 0

     ret
endp