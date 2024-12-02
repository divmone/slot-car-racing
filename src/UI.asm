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
         stdcall Object.SetScale, R1, 0.2, 0.2, 0.2 
         stdcall Rectangle.CreateText, R1, r1Message, 0.0, 0.0, 4.0, 6.0
         ;stdcall Rectangle.CreateText, R1, r1Message, 0.0, 0.0, 0.4, 0.2
         ;stdcall Rectangle.CreateText, R1, r1Message, 0.0, -0.3, 0.4, 0.2

        ; stdcall Sprite.Draw, R1
        ; stdcall Sprite.Draw, R2
        ; stdcall Sprite.Draw, R3
    invoke  SwapBuffers, [hdc]
    ret
endp

proc Rectangle.Create uses esi ,\
                    objPtr, x, y, width, heigth

    locals
      vao dd ?
      vbo dd ?
      tao dd ?
      buffer dd ?
      char db 0
      charSize dd 0.0625
      sixteen dd 16.0
      x1 dd 0
      y1 dd 4
      left dd ?
      right dd ?
      top dd ?
      bottom dd ?
    endl
    
    mov [char], '2'
    xor eax, eax
    mov al, [char]
    shr eax, 4
    mov [y1], eax

    xor eax, eax
    mov al, [char]
    and eax, 1111b
    mov [x1], eax


    fild [x1]
    fmul [charSize]
    fst [left]

    fadd [charSize]

    fstp [right]

    fild [y1]
    fmul [charSize]
    fst [top]
    fadd [charSize]
    fstp [bottom]

;0
   

    mov esi , textCoords
    mov eax, [left]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi, 4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi ,4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

    add esi, 4
    mov eax, [left]
    
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

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

    lea eax, [tao]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [tao]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, textCoords, GL_STATIC_DRAW


    invoke glEnableVertexAttribArray, 1
    
    invoke glVertexAttribPointer, 1, 2, GL_FLOAT, GL_FALSE, 0, 0
        
    invoke glBindVertexArray, 0


    mov esi, [objPtr]
    mov eax, [vao]
    mov [esi + Object.VAO], eax

    mov esi, [objPtr]
    ;add esi, Object.transform
    mov [esi + Object.transform.position.x], 0.0
    mov [esi + Object.transform.position.y], 0.0
    mov [esi + Object.transform.position.z], 0.0

    mov [esi + Object.transform.rotation.x], 0.0
    mov [esi + Object.transform.rotation.y], 0.0
    mov [esi + Object.transform.rotation.z], 0.0

    mov [esi + Object.transform.scale.x], 1.0
    mov [esi + Object.transform.scale.y], 1.0
    mov [esi + Object.transform.scale.z], 1.0

    mov [esi + Object.q.x], 0.0
    mov [esi + Object.q.y], 0.0
    mov [esi + Object.q.z], 0.0
    mov [esi + Object.q.w], 0.0
    ret
endp

proc Rectangle.CreateText uses esi edi,\
                    objPtr, text, x, y, width, heigth

    locals
      vao dd ?
      vbo dd ?
      tao dd ?
      buffer dd ?
      char db 0
      charSize dd 0.0625
      sixteen dd 16.0
      x1 dd 0
      y1 dd 4
      left dd ?
      right dd ?
      top dd ?
      bottom dd ?
      xpos dd 0.0
      step dd 2.0
    endl
    
    mov edi, [text]

.loop:
    cmp byte[edi], 0
    je .endl
  
    xor eax, eax
    mov al, byte[edi]
    shr eax, 4
    mov [y1], eax

    xor eax, eax
    mov al, byte[edi]
    and eax, 1111b
    mov [x1], eax


    fild [x1]
    fmul [charSize]
    fst [left]

    fadd [charSize]

    fstp [right]

    fild [y1]
    fmul [charSize]
    fst [top]
    fadd [charSize]
    fstp [bottom]

;0
   

    mov esi , textCoords
    mov eax, [left]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi, 4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi ,4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

    add esi, 4
    mov eax, [left]
    
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

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

    mov esi, [objPtr]
    add esi, Object.VAO

    invoke glBindVertexArray, [esi] 
    lea eax, [tao]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [tao]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, textCoords, GL_STATIC_DRAW


    invoke glEnableVertexAttribArray, 1
    
    invoke glVertexAttribPointer, 1, 2, GL_FLOAT, GL_FALSE, 0, 0
        
        stdcall Object.SetPosition, [objPtr], [xpos], 0.0, 0.0

        stdcall Matrix.CreateModel, [objPtr]
        invoke glUseProgram, [program2D]
        invoke glUniformMatrix4fv, [modelLocation2D], 1, GL_FALSE, model
        invoke glUniformMatrix4fv, [projectionLocation], 1, GL_FALSE, projection2D
        mov esi, [objPtr]
        invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
        invoke glBindVertexArray, [esi + Object.VAO] 
                invoke  glDrawArrays, 6, 0, 4
        invoke glBindVertexArray, 0
        invoke glBindTexture, GL_TEXTURE_2D, 0
        
        invoke glUseProgram, 0

    inc edi
    fld [xpos]
    fadd [step]
    fstp [xpos]
    
    jmp .loop
.endl:
    ret
endp

proc Text.Render uses esi edi,\
                    text, vao, x, y, width, heigth

    locals
      tao dd ?
      buffer dd ?
      char dd 0
      charSize dd 0.0625
      sixteen dd 16.0

      x1 dd 0
      y1 dd 4
      left dd ?
      right dd ?
      top dd ?
      bottom dd ?
    endl
    
    mov edi, [text]


    cmp [edi], 0
    je .endl


    mov eax, [edi]
    shr eax, 4
    mov [y1], eax

    mov eax, [edi]
    and eax, 1111b
    mov [x1], eax


    fild [x1]
    fmul [charSize]
    fst [left]

    fadd [charSize]

    fstp [right]

    fild [y1]
    fmul [charSize]
    fst [top]
    fadd [charSize]
    fstp [bottom]

;0
   

    mov esi , textCoords
    mov eax, [left]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi, 4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi ,4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

    add esi, 4
    mov eax, [left]
    
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

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

    invoke glBindVertexArray, [vao]

    lea eax, [tao]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [tao]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, textCoords, GL_STATIC_DRAW


    invoke glEnableVertexAttribArray, 1
    
    invoke glVertexAttribPointer, 1, 2, GL_FLOAT, GL_FALSE, 0, 0
        
    invoke glBindVertexArray, 0


    invoke glBindVertexArray, [R2.VAO]
      invoke  glDrawArrays, 6, 0, 4
    invoke glBindVertexArray, 0

.endl:

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