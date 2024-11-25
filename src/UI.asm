proc UI.StartRender
   
  ;stdcall Matrix.LookAt, menuPosition, menuTargetPosition, upVector 
  memcpy tempMatrix2, projection,  sizeof.Matrix4x4
  memcpy tempMatrix3, model,  sizeof.Matrix4x4
  memcpy tempMatrix4, view, sizeof.Matrix4x4      
  memcpy tempMatrix, MVP, sizeof.Matrix4x4     
  

  ret
endp   

proc UI.EndRender
  
  memcpy projection, tempMatrix2, sizeof.Matrix4x4
  memcpy model, tempMatrix3, sizeof.Matrix4x4
  memcpy view, tempMatrix4, sizeof.Matrix4x4      
  memcpy MVP, tempMatrix, sizeof.Matrix4x4
  
  ret
endp   


proc Rectangle.Init uses esi, objPtr
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
  invoke glBufferData, GL_ARRAY_BUFFER, 32, rectangleV, GL_STATIC_DRAW

  invoke glEnableVertexAttribArray, 0
    
  invoke glVertexAttribPointer, 0, 2, GL_FLOAT, GL_FALSE, 0, 0

  invoke glBindVertexArray, 0
  ret
endp

proc DrawMenu
     
    ret
endp

proc UI.Pause
      cmp [GAME_MODE], 0
      je @F
      mov [GAME_MODE], 0
      
      ret
@@:
      mov [GAME_MODE], 1
    ret
endp

proc UI.Unpause

  ret
endp