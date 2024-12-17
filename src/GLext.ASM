proc Glext.LoadFunctions uses esi edi

        mov     esi, extensionAddresses
        mov     edi, extensionNames

.Scan:
        movzx   eax, byte[edi]
        cmp     eax, ebx
        je      .Return

        invoke  wglGetProcAddress, edi
        mov     [esi], eax
        add     esi, 4

        mov     al, 0
        mov     ecx, 0xFFFFFFFF
        repne   scasb
        jmp     .Scan

.Return:
        ret
endp

proc Glext.CreateShaders

        stdcall Glext.LoadShader, vshaderFile, GL_VERTEX_SHADER
        mov     [vertexShader], eax

        stdcall Log, SHADER_LOADED_SUCCESSFULLY, SHADER_LOADED_SUCCESSFULLY.size 
        cmp     eax, 0
        je      .Error


        stdcall Glext.LoadShader, fshaderFile, GL_FRAGMENT_SHADER
        mov     [fragmentShader], eax

        stdcall Log, SHADER_LOADED_SUCCESSFULLY, SHADER_LOADED_SUCCESSFULLY.size 
        cmp     eax, ebx
        je      .Error

 

        stdcall Glext.CreateProgram,  [vertexShader], [fragmentShader]
        mov     [program], eax

        cmp     eax, ebx
        je      .Error

        invoke   glGetUniformLocation , [program], viewPosName
        mov [viewPosLocation], eax

        invoke   glGetUniformLocation , [program], lightPosName
        mov [lightPosLocation], eax

      
        invoke   glGetUniformLocation , [program], objectColorName
        mov [objectColorLocation], eax


        invoke glGetUniformLocation, [program], lightColorName
        mov [lightColorLocation], eax

        invoke glGetUniformLocation, [program], MVPName
        mov [MVPLocation], eax

        invoke glGetUniformLocation, [program], modelName
        mov [modelLocation], eax

        invoke glGetUniformLocation, [program], lightSpaceMatrixName
        mov [lightSpaceMatrixLocation], eax

        invoke glGetUniformLocation, [program], viewName
        mov [viewLocation], eax

        invoke glGetUniformLocation, [program], projectionName
        mov [projectionLocation], eax

        invoke glGetUniformLocation, [program], useInstancingName
        mov [useInstancingLocation], eax




         ;invoke  glBindAttribLocation, [program], 0, timeName
      ;  mov     [timeLocation], eax
         ;invoke  glBindAttribLocation, [program], 2, sizeName
      ;  mov     [sizeLocation], eax
  

      ;  invoke  WriteConsole, [hStdOut], okMessage, 20, 0, ebx

  
        jmp     .Return


.Error:
        ;stdcall Log, SHADER_LOADED_FAILED, SHADER_LOADED_FAILED.size 
        mov     [program], ebx

.Return:
         
                
        ret
endp

proc Glext.CreateShader, vshaderFile, fshaderFile
        locals
                shader dd ?
                vShader dd ?
                fShader dd ?
        endl

        invoke  glDetachShader, [shader], [fShader]
        invoke  glDeleteShader, [fShader]
        
        invoke  glDetachShader, [shader], [vShader]
        invoke  glDeleteShader, [vShader]
        
        invoke  glDeleteProgram, [shader]

        stdcall Glext.LoadShader, [vshaderFile], GL_VERTEX_SHADER
        mov     [vShader], eax

        stdcall Glext.LoadShader, [fshaderFile], GL_FRAGMENT_SHADER
        mov     [fShader], eax

        stdcall Glext.CreateProgram,  [vShader], [fShader]
        ret
endp
proc Glext.CreateShaders2D
        invoke  glUseProgram, ebx

        cmp     [program2D], ebx
        je      @F

        invoke  glDetachShader, [program2D], [fragmentShader2D]
        invoke  glDeleteShader, [fragmentShader2D]
        
        invoke  glDetachShader, [program2D], [vertexShader2D]
        invoke  glDeleteShader, [vertexShader2D]
        
        invoke  glDeleteProgram, [program2D]

@@:

        stdcall Glext.LoadShader, vshaderFile2D, GL_VERTEX_SHADER
        mov     [vertexShader2D], eax

        cmp     eax, 0
        je      .Error


        stdcall Glext.LoadShader, fshaderFile2D, GL_FRAGMENT_SHADER
        mov     [fragmentShader2D], eax
        cmp     eax, ebx
        je      .Error

 

        stdcall Glext.CreateProgram2D,  [vertexShader2D], [fragmentShader2D]
        mov     [program2D], eax

        cmp     eax, ebx
        je      .Error

      

        jmp     .Return


.Error:
        ;stdcall Log, SHADER_LOADED_FAILED, SHADER_LOADED_FAILED.size 
        mov     [program2D], ebx

.Return:
         
                
        ret
endp


proc Glext.CreateProgram,\
     vertexShader, fragmentShader

        locals
                progam  dd      ?
                linked  dd      ?
        endl

        invoke  glCreateProgram
        mov     [program], eax

        cmp     [vertexShader], ebx
        je      @F

        invoke  glAttachShader, [program], [vertexShader]

@@:
        cmp     [fragmentShader], ebx
        je      @F

        invoke  glAttachShader, [program], [fragmentShader]

@@:
        invoke  glLinkProgram, [program]

        lea     eax, [linked]
        invoke  glGetProgramiv, [program], GL_LINK_STATUS, eax

        cmp     [linked], ebx
        je      @F

        mov     eax, [program]
        jmp     .Return

@@:
        cmp     [vertexShader], ebx
        je      @F

        invoke  glDetachShader, [program], [vertexShader]

@@:
        cmp     [fragmentShader], ebx
        je      @F

        invoke  glDetachShader, [program], [fragmentShader]

@@:
        invoke  glDeleteProgram, [program]

.Return:
        ret
endp


proc Glext.CreateProgram2D,\
     vertexShader, fragmentShader

        locals
                progam  dd      ?
                linked  dd      ?
        endl

        invoke  glCreateProgram
        mov     [program2D], eax

        cmp     [vertexShader], ebx
        je      @F

        invoke  glAttachShader, [program2D], [vertexShader]

@@:
        cmp     [fragmentShader], ebx
        je      @F

        invoke  glAttachShader, [program2D], [fragmentShader]

@@:
        invoke  glLinkProgram, [program2D]

        lea     eax, [linked]
        invoke  glGetProgramiv, [program2D], GL_LINK_STATUS, eax

        cmp     [linked], ebx
        je      @F

        mov     eax, [program2D]
        jmp     .Return

@@:
        cmp     [vertexShader], ebx
        je      @F

        invoke  glDetachShader, [program2D], [vertexShader]

@@:
        cmp     [fragmentShader], ebx
        je      @F

        invoke  glDetachShader, [program2D], [fragmentShader]

@@:
        invoke  glDeleteProgram, [program2D]

.Return:
        ret
endp


proc Glext.LoadShader,\
     fileName, shaderType

        locals
                buffer          dd      ?
                shader          dd      ?
                compiled        dd      ?
        endl

        stdcall File.LoadContent, [fileName]
        mov     [buffer], eax

        invoke  glCreateShader, [shaderType]
        mov     [shader], eax
        lea     eax, [buffer]
        invoke  glShaderSource, [shader], 1, eax, ebx
        invoke  glCompileShader, [shader]

        invoke  HeapFree, [hHeap], ebx, [buffer]

        lea     eax, [compiled]
        invoke  glGetShaderiv, [shader], GL_COMPILE_STATUS, eax

        cmp     [compiled], ebx
        je      @F

        mov     eax, [shader]
        jmp     .Return

@@:
        mov     eax, ebx

.Return:
        ret
endp

proc CreateShader\
     shaderTextPtr, shaderType

        locals
                shader  dd      ?
        endl

        invoke  glCreateShader, [shaderType]
        mov     [shader], eax
        invoke  glShaderSource, [shader], 1, [shaderTextPtr], ebx
        invoke  glCompileShader, [shader]

        mov     eax, [shader]

        ret
endp