proc UI.StartRender
   
  ;stdcall Matrix.LookAt, menuPosition, menuTargetPosition, upVector 
  memcpy tempMatrix, view, sizeof.Matrix4x4
  invoke  glDisable, GL_DEPTH_TEST
  invoke  glMatrixMode, GL_MODELVIEW
  invoke  glLoadIdentity 
  invoke  glMatrixMode, GL_PROJECTION
  invoke  glLoadIdentity 
   
  invoke glUseProgram, 0  

  ret
endp   

proc UI.EndRender
  
  invoke  glEnable, GL_DEPTH_TEST
  invoke glUseProgram, [program]
  
 
  invoke  glMatrixMode, GL_MODELVIEW 
  invoke  glLoadMatrixf, view
  
  ;memcpy MVP, tempMatrix, sizeof.Matrix4x4      
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
        invoke  glClearColor, 0.3, 0.3, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT
        
        invoke glColor3f, 0.0, 0.0, 1.0
        invoke glBindVertexArray, [R1.VAO]
                invoke  glDrawArrays, 6, 0, 4
        invoke glBindVertexArray, 0

        invoke glColor3f, 0.0, 0.0, 1.0
        invoke glBindVertexArray, [R2.VAO]
                invoke  glDrawArrays, 6, 0, 4
        invoke glBindVertexArray, 0

        invoke glColor3f, 0.0, 0.0, 1.0
        invoke glBindVertexArray, [R3.VAO]
                invoke  glDrawArrays, 6, 0, 4
        invoke glBindVertexArray, 0

        invoke  SwapBuffers, [hdc]


    ret
endp

proc Rectangle.Create uses esi ,\
                    x, y, width, heigth

    locals
      vao dd ?
      vbo dd ?
      buffer dd ?

    endl

    malloc 32
    mov [buffer], eax
    mov esi, eax

   
    mov eax, [x]
    mov dword[esi], eax

    mov eax, [y]
    mov dword[esi + 4], eax

    add esi, 8
    fld [x]
    fadd [width]
    fstp dword[esi]

    add esi, 4
    mov eax, [y]
    mov dword[esi], eax

    add esi, 4
    fld [x]
    fadd [width]
    fstp dword[esi]

    add esi, 4
    fld [y]
    fadd [heigth]
    fstp dword[esi]
    
    add esi, 4
    mov eax, [x]
    mov dword[esi], eax

    add esi, 4
    fld [y]
    fadd [heigth]
    fstp dword[esi]

    lea eax, [vao]
    invoke glGenVertexArrays, 1, eax   
    invoke glBindVertexArray, [vao]

    lea eax, [vbo]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [vbo]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, [buffer], GL_STATIC_DRAW

    invoke glEnableVertexAttribArray, 0
    
    invoke glVertexAttribPointer, 0, 2, GL_FLOAT, GL_FALSE, 0, 0

    invoke glBindVertexArray, 0


    mov eax, [vao]
    ret
endp

proc UI.Pause
      cmp [GAME_MODE], 0
      je @F
      mov [GAME_MODE], 0
      stdcall UI.EndRender
      
      ret
@@:
      mov [GAME_MODE], 1
      stdcall UI.StartRender
    ret
endp

proc UI.Unpause

  ret
endp