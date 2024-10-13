proc Init uses esi

        locals
                hMainWindow     dd              ?
                aspect          dd              ?
        endl

   
        invoke  GetProcessHeap
        mov     [hHeap], eax

        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, POP_IT,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax

        invoke  GetClientRect, eax, clientRect
        invoke  ShowCursor, ebx
        invoke  GetTickCount
        mov     [time], eax

        invoke  GetDC, [hMainWindow]
        mov     [hdc], eax
 
        stdcall Log.Create
        ;stdcall  PrintToConsole, okMessage + 1, okMessage.size - 1
  
        invoke  ChoosePixelFormat, [hdc], pfd
        invoke  SetPixelFormat, [hdc], eax, pfd

        invoke  wglCreateContext, [hdc]
        invoke  wglMakeCurrent, [hdc], eax

        invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]

        fild    [clientRect.right]      ; width
        fidiv   [clientRect.bottom]     ; width / height
        fstp    [aspect]

        stdcall Glext.LoadFunctions
   
        stdcall File.LoadContent, fileName;, size
        mov [buffer], eax
        stdcall File.GetSize, fileName
        mov [bufferLength], eax
        ; stdcall  PrintToConsole, [buffer] , eax
        stdcall CountVerticesOBJ,  [buffer], [bufferLength]
        mov [vCount], eax
       ; mov [objTrianglesCount], eax
        mov [iCount], ecx

        stdcall ParseVerticesOBJ, [buffer],  [bufferLength], [vCount];, [objVertices], [objIndices]
        mov [addressV], eax

        stdcall ParseIndicesOBJ, [buffer],  [bufferLength], [iCount] ;, [objVertices], [objIndices]
        mov [addressI], eax
        stdcall Mesh.Generate, carMesh, car, true, [addressV], [addressI], [iCount]
      
    ;    stdcall Mesh.Generate, akMesh, ak, false, [addressV], [addressI], [iCount]
      
       ; mov eax, zhIndices

        invoke  glMatrixMode, GL_PROJECTION
        invoke  glLoadIdentity

        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar]

        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
        invoke  glEnable, GL_DEPTH_TEST
        invoke  glEnable, GL_COLOR_MATERIAL

        invoke  HeapAlloc, [hHeap], ebx, sizeof.Vertex * 6
        mov     [plane.normals], eax
        
        stdcall Mesh.CalculateNormals, car
        stdcall Mesh.CalculateNormals, plane

        stdcall Glext.InitShaders  
 
        stdcall VBO.Init


        ret
endp