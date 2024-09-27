        include "OPENGL_DEMO.inc"

        className       db              "OpenGLDemo", 0
        clientRect      RECT            0, 0, 0, 0
        fileName        db              "test.obj",0
        hHeap           dd              ?
        hdcBack         dd              ?
        time            dd              ?
        hdc             dd              ?
        radian          GLfloat         57.32
        angle           GLfloat         0.0
        angleY           GLfloat        0.0
        angleX           GLfloat        0.0
        angleZ           GLfloat        0.0
        step            GLfloat         10.0
        length          GLfloat         5.0
        programTime     dd              ?

        posX            GLfloat         1.0
        posY            GLfloat         10.0
        posZ            GLfloat         1.0
        size            dd             1000
        fileSize        dd             0
        isTransform     dd              0
        buffer          dd              ?
        scaleStep       GLfloat         0.05
        scale           GLfloat         2.0

        cubeMesh        PackedMesh      cubeVertices, cubeColors, cubeIndices, CUBE_TRIANGLES_COUNT
        cube            Mesh            0, 0, 0, 0

        zhMesh          PackedMesh      zhVertices, zhColors, zhIndices, ZH_TRIANGLES_COUNT
        zh              Mesh            0, 0, 0, 0
        plane           Mesh            planeVertices, planeColors, 0, PLANE_VERTICES_COUNT

        cameraPosition1 Vector3         5.0, 5.0, 0.0
        cameraDirPrev1  Vector3         5.0, 5.0, 6.66
        cameraDirNext1  Vector3         5.0, 5.0, -6.66

        cameraPosition2 Vector3         -5.0, 5.0, 0.0
        cameraDirPrev2  Vector3         -5.0, 5.0, -6.66
        cameraDirNext2  Vector3         -5.0, 5.0, 6.66



        cameraPoints:   Spline.Point    cameraPosition1, cameraDirPrev1, cameraDirNext1, 5.0
                        Spline.Point    cameraPosition2, cameraDirPrev2, cameraDirNext2, 5.0

        cameraSpline    Spline          2, cameraPoints, true, 10.0

        fovY            GLfloat         60.0
        zNear           GLfloat         0.001
        zFar            GLfloat         1000.0
        tAngle   dd       180.0
        PI      dd       3.14
        mVector         Vector3         0.1, 0.1, 0.0
        nullVector      Vector3         0.0, 0.0, 0.0
        unitVector      Vector3         10.0, 10.0, 10.0

        cameraPosition  Vector3         0.0, 150.0, 0.0
        targetPosition  Vector3         1.0, 0.0, 0.0
        upVector        Vector3         0.0, 1.0, 0.0

        xAxis           Vector3         0.0, 0.0, 0.0
        yAxis           Vector3         0.0, 0.0, 0.0
        zAxis           Vector3         0.0, 0.0, 0.0

        light0Position  Vector4         5.0, 5.1, 5.0, 1.0
        light0Diffuse   ColorRGBA       1.0, 0.996, 0.839, 1.0

        light1Position  Vector4         4.0, 3.5, 6.0, 1.0
        light1Diffuse   ColorRGBA       1.0, 0.996, 0.839, 1.0

        directionVetcor  Vector4i       0, 0, 0, 0

   prevMouseX      dd      ?
        prevMouseY      dd      ?
        mouseX          dd      ?
        mouseY          dd      ?
        mouseCaptured   dd      0

        okMessage       db      "parsing is ok",0

        include         "Init.asm"
        include         "Mesh.asm"
        include         "Vector.asm"
        include         "Matrix.asm"
        include         "Drawing.asm"
        include         "Spline.asm"

proc WinMain

        locals
                msg     MSG
        endl

        xor     ebx, ebx

        stdcall Init

        lea     esi, [msg]

.cycle:
        invoke  GetMessage, esi, ebx, ebx, ebx
        invoke  DispatchMessage, esi
        jmp     .cycle

endp

proc WindowProc uses ebx,\
     hWnd, uMsg, wParam, lParam

        xor     ebx, ebx

        switch  [uMsg]
        case    .Paint,         WM_PAINT
        case    .Destroy,       WM_DESTROY
        case    .KeyDown,       WM_KEYDOWN
        case    .MouseWheel,    WM_MOUSEWHEEL


        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return

.Paint:

        stdcall Draw,     directionVetcor.x

        jmp     .ReturnZero

.KeyDown:
        cmp     [wParam], VK_ESCAPE
        je      .Destroy
        cmp     [wParam], 41h
        je      .MoveLeft
        cmp     [wParam], 44h
        je      .MoveRight
        cmp     [wParam], 51h
        je      .MoveFront
        cmp     [wParam], 45h
        je      .MoveBack
        cmp     [wParam], 57h
        je      .MoveUp
         cmp     [wParam], 53h
        je      .MoveDown
          cmp     [wParam], 58h
          je      .RotateRight

       cmp     [wParam], VK_SPACE
       jne     @F
        stdcall Mesh.Subdivide, cube, cube
@@:
         cmp     [wParam], 5ah
        je      .RotateLeft
        cmp     [wParam], VK_LEFT

        je .RotateLeftC
        cmp     [wParam], VK_RIGHT
          je .RotateRightC
          cmp     [wParam], VK_UP
        je      .RotateUp
        cmp     [wParam], VK_DOWN
         je      .RotateDown
        cmp     [wParam], 45h
        je      .MoveDown

        jmp     .ReturnZero
.MoveUp:
        fld     [posX]
        fsub   [step]
        fstp    [posX]
        mov      [isTransform], true
        jmp     .ReturnZero
.MoveDown:
        fld     [posX]
        fadd  [step]
        fstp    [posX]
        mov      [isTransform], true
        jmp     .ReturnZero
.MoveLeft:
        fld     [posZ]
        fsub    [step]
        fstp    [posZ]
        mov      [isTransform], true
        jmp     .ReturnZero

.MoveRight:
        fld     [posZ]
        fadd    [step]
        fstp    [posZ]
        mov      [isTransform], true
        jmp     .ReturnZero

.MoveFront:
        fld     [posY]
        fsub    [step]
        fstp    [posY]
        mov      [isTransform], true
        jmp     .ReturnZero

.MoveBack:
        fld     [posY]
        fadd    [step]
        fstp    [posY]
        mov      [isTransform], true
        jmp     .ReturnZero

.RotateLeft:
        fld     [angleY]
        fadd    [step]
        fstp    [angleY]
        jmp     .ReturnZero


.RotateRight:
        fld     [angleY]
        fsub    [step]
        fstp    [angleY]
        jmp     .ReturnZero

.RotateRightC:
        fld     [angleZ]
        fsub    [step]
        fstp    [angleZ]
        mov      [isTransform], false
        jmp     .ReturnZero
.RotateLeftC:
        fld     [angleZ]
        fadd    [step]
        fstp    [angleZ]
        mov      [isTransform], false
        jmp     .ReturnZero




.RotateUp:
        fld     [angleX]
        fadd    [step]
        fstp    [angleX]
        jmp     .ReturnZero
.RotateDown:
        fld     [angleX]
        fsub    [step]
        fstp    [angleX]
        jmp     .ReturnZero


 .MouseWheel:
        mov     eax, [wParam]
        test    eax, 0x80000000
        jne     .Negative
        fld [scale]
        fadd [scaleStep]
        fstp [scale]
        jmp     .ReturnZero

.Negative:
         fld [scale]
        fsub [scaleStep]
        fstp [scale]
        jmp     .ReturnZero

.Destroy:
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp

proc File.LoadContent uses edi,\
     fileName;, fileLength

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], ebx
        inc     eax
        mov     [length], eax
        invoke  HeapAlloc, [hHeap], 8, [length]
        mov     [pBuffer], eax

        lea     edi, [read]
        invoke  ReadFile, [hFile], [pBuffer], [length], edi, ebx

        invoke  CloseHandle, [hFile]

        mov     eax, [pBuffer]
       ;  stdcall  PrintToConsole, [pBuffer], [length]

        ret
endp




proc File.GetSize uses edi,\
     fileName
      locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
       endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], ebx
        inc     eax

    ret
endp

proc PrintToConsole uses esi, buffer, length

        locals
                hStdOut dd ?
                written dd ?
        endl
        invoke  AllocConsole
        invoke  GetStdHandle, STD_OUTPUT_HANDLE
        mov     [hStdOut], eax

        invoke  WriteConsole, [hStdOut], [buffer], [length], [written], ebx

        ret
endp

proc ParseOBJ uses edi esi,\
    buffer, length;, verticesBuff, indicesBuff

        locals
            index dd 0
            sign db 0
            number dd 0
            buff dd 0
            vertexX dd 0
            vertexY dd 0
            vertexZ dd 0
            tmpVertex dd 0
            verticesCount dd 0
            indicesCount dd 0
            resultVertices dd 0
            resultIndices dd 0
            vertex dd 0.0
            vertexY dd 0.0
            vertexZ dd 0.0

        endl

        mov esi, [buffer]
        mov ecx, [length]
        mov dx, 10

.countCycle:
        cmp byte[esi], 'v'
        jne @F
        inc [verticesCount]
        jmp .newLine

@@:
        cmp byte[esi], 'f'
        jne .newLine
        inc [indicesCount]
        jmp .newLine

.newLine:

        cmp byte [esi], 10
        je @F
        cmp byte[esi], 0
        je .endl
        inc esi
        dec ecx
        jmp .newLine
@@:
        inc esi
        loop .countCycle
.endl:
        mov eax, [verticesCount]
        imul eax, 3
        invoke  HeapAlloc, [hHeap], 8, eax    ; eax
        mov     [objVertices], eax

        mov eax, [indicesCount]
        imul eax, 3
        invoke  HeapAlloc, [hHeap], 8, eax    ; eax
        mov     [objIndices], eax



        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [objVertices]
.cycle:
        cmp byte[esi], 'v'
        jne .skipLine


        cmp byte [esi + 1], ' '
        jne .skipLine

        add esi, 2

        stdcall StrToFloat, esi
        mov [edi], eax
        add edi, 2

        add esi, 2

        stdcall StrToFloat, esi
        mov [edi], eax
        add edi, 2

        stdcall StrToFloat, esi
        mov [edi], eax
        add edi, 2

        jmp .skipLine

.skipLine:

        cmp byte [esi], 10
        je @F
         inc esi
         dec ecx
        jmp .skipLine


@@:
         inc esi
        loop .cycle

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [objIndices]

.cycle2:
        cmp byte[esi], 'f'
        jne .skipLine2

        cmp byte[esi], ' '
        jne .skipLine2

        add esi, 2

        stdcall StrToInt, esi
        mov [edi], eax
        add edi,  sizeof.Vertex

        add esi, 2

        stdcall StrToInt, esi
        mov [edi], eax
        add edi, sizeof.Vertex

        add esi, 2

        stdcall StrToInt, esi
        mov [edi], eax
        add edi,  sizeof.Vertex

.skipLine2:

        cmp byte [esi], 10
        je @F
         inc esi
        jmp .skipLine2


@@:

        loop .cycle2


        mov eax, [resultVertices]
        mov [objVertices], eax
        mov eax, [resultIndices]
        mov [objVertices], eax

    ret
endp

proc StrToInt uses ecx edi esi,\
     pointer

    locals
            number dd 0.0
            buffer dd 0.0
            buff dd 0
            precision dd 0
            sign db 0

        endl

        mov esi, [pointer]

        xor eax, eax
 @@:
        inc esi
        cmp byte[esi], '\'
        je @F
        cmp byte[esi], 10
        je @F
        mov ebx, [esi]
        sub ebx, '0'
        dec ebx
        imul eax, 10
        add eax, ebx
        jmp @B

@@:

    ret
endp

proc StrToFloat uses ecx edi,\
      pointer

        locals
            number dd 0.0
            buffer dd 0.0
            buff dd 0
            precision dd 0
            sign db 0

        endl

        mov esi, [pointer]

        cmp byte[esi], '-'
        jne @F
        mov [sign], 1
        xor eax, eax
        inc esi

@@:
        xor ebx, ebx
        cmp byte[esi], '.'
        je @F
        mov bl, byte[esi]  ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        sub ebx, '0'
        imul eax, eax, 10
        add eax, ebx
        jmp @B

@@:
        add eax, ebx

@@:
        inc esi
        xor ebx, ebx
        cmp byte[esi], ' '
        je @F
        cmp byte[esi], 10
        je @F
        mov bl, byte[esi]
        sub ebx, '0'
        imul eax, eax, 10
        add eax, ebx
        inc [precision]
        jmp @B

@@:
        mov [number], eax
        mov eax, 10

        mov ecx,  [precision]
.cycle:
        imul eax, eax, 10

        loop .cycle


        mov [buff], eax

        fld [number]
        fdiv [buff]
        cmp [sign], 1
        jne @F
        fchs
@@:
        fstp [buffer]

        mov eax, [buffer]

    ret
endp