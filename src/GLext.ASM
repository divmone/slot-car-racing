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

proc Glext.InitShaders

        invoke  glUseProgram, ebx

        cmp     [program], ebx
        je      @F

        invoke  glDetachShader, [program], [fragmentShader]
        invoke  glDeleteShader, [fragmentShader]
        
        invoke  glDetachShader, [program], [vertexShader]
        invoke  glDeleteShader, [vertexShader]
        
        invoke  glDeleteProgram, [program]

@@:

        ;stdcall Glext.LoadShader, vshaderFile, GL_FRAGMENT_SHADER
        mov     [vertexShader], eax

        cmp     eax, 0
        je      .Error


        stdcall Glext.LoadShader, fshaderFile, GL_FRAGMENT_SHADER
        mov     [fragmentShader], eax

        cmp     eax, ebx
        je      .Error

        stdcall Glext.CreateProgram,  [vertexShader], [fragmentShader]
        mov     [program], eax

        cmp     eax, ebx
        je      .Error

        invoke  glGetUniformLocation, [program], timeName
        mov     [timeLocation], eax
        invoke  glGetUniformLocation, [program], sizeName
        mov     [sizeLocation], eax
  
              
      
      ;  invoke  WriteConsole, [hStdOut], okMessage, 20, 0, ebx

  
        jmp     .Return


.Error:
        mov     [program], ebx

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