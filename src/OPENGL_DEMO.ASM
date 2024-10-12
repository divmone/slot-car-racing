        include "../include/OPENGL_DEMO.inc"

        className       db              "OpenGLDemo", 0
        clientRect      RECT            0, 0, 0, 0
        fileName        db              "..\models\car.obj",0
        akFileName      db              "..\models\skull.obj", 0
        hHeap           dd              ?
        hdcBack         dd              ?
        hConsole        dd              ?
        time            dd              ?
        hdc             dd              ?
        radian          GLfloat         57.32

        angle           GLfloat         0.0
;transform
        angleY          GLfloat         0.0
        angleX          GLfloat         0.0
        angleZ          GLfloat         0.0

        posX            GLfloat         0.0
        posY            GLfloat         0.0
        posZ            GLfloat         0.0

        velocity        GLfloat         2.0



; 
; fpu
        toRadian        GLfloat         180.0

        step            GLfloat         5.0
        length          GLfloat         5.0
        pVector         Vector3         0.0, 0.0, 0.0
        programTime     dd              ?
        bufferLength    dd              0
        two             dd              1.5

        vCount          dd              0
        iCount          dd              0

        matrixT         Matrix4x4       ?

  
        size            dd             1000
        fileSize        dd             0
        isTransform     dd              0
        buffer          dd              0.0
        scaleStep       GLfloat         0.05
        scale           GLfloat         2.0

        drawingMode      dd              1

        addressV         dd              0
        addressI         dd              0

      ;  cubeMesh        PackedMesh      cubeVertices, cubeColors, cubeIndices, CUBE_TRIANGLES_COUNT
        cube            Mesh            0, 0, 0, 0

        akMesh          PackedMesh       0, 0, 0, 0
        ak              Mesh            0, 0, 0, 0

        carMesh          PackedMesh      0, zhColors, 0, 0
        car              Mesh            0, 0, 0, 0

        plane           Mesh            planeVertices, planeColors, 0, PLANE_VERTICES_COUNT


        fovY            GLfloat         60.0
        zNear           GLfloat         0.001
        zFar            GLfloat         1000.0
        tAngle   dd       180.0
        PI      dd       3.14
        mVector         Vector3         0.1, 0.1, 0.0
        nullVector      Vector3         0.0, 0.0, 0.0
        unitVector      Vector3         1.0, 1.0, 1.0
        tPosition       Vector3         0,   0,    0
        cPosition       Vector3         150.0, 150.0, 150.0

        cameraPosition  Vector3         0.0, 110.0, 0.0
        targetPosition  Vector3         1.0, 0.0, 0.0
        upVector        Vector3         0.0, 1.0, 0.0

        xAxis           Vector3         0.0, 0.0, 0.0
        yAxis           Vector3         0.0, 0.0, 0.0
        zAxis           Vector3         0.0, 0.0, 0.0

        light0Position  Vector4         5.0, 5.1, 5.0, 1.0
        light0Diffuse   ColorRGBA       1.0, 0.996, 0.839, 1.0

        light1Position  Vector4         10.0, 10.5, 10.0, 1.0
        light1Diffuse   ColorRGBA       1.0, 0.996, 0.839, 1.0

        directionVetcor  Vector4i       0, 0, 0, 0

        

        timeLocation    GLint           0
        sizeLocation    GLint           0
        oneSecond       GLfloat         1000.0  
        startTime       dd              ?      

       
        fragmentShader  GLuint          0
        fshaderFile      db              "../shaders/fragment.glsl", 0

        vertexShader    GLuint          0
        vshaderFile      db              "../shaders/vertex.glsl", 0
       
        program         GLint           0
        
        timeName        db              "time", 0
        sizeName        db              "size", 0

        prevMouseX      dd      ?
        prevMouseY      dd      ?
        mouseX          dd      ?
        mouseY          dd      ?
        mouseCaptured   dd      0

        okMessage  String 'OK'
        
        successMessage db       'shaders loaded successfully', 0


        include         "Init.asm"
        include         "Mesh.asm"
        include         "Vector.asm"
        include         "Matrix.asm"
        include         "Drawing.asm"
        include         "Spline.asm"
        include         "File.asm"
        include         "GLext.asm"
        include         "Utils.asm"
        include         "Logger.asm"

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
        cmp  [wParam], 31h
        je .selectMode


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
      
        fldpi
        fdiv [toRadian]
        fmul [angleY]
        fcos
        fmul [velocity]
        fadd [posX]
        fstp [posX]

        fldpi
        fdiv [toRadian]
        fmul [angleY]
        fsin
        fmul [velocity]
        fadd [posZ]
        fstp [posZ]

        jmp     .ReturnZero
.MoveDown:

        fldpi
        fidiv [toRadian]
        fmul [angleY]
        fcos
        fmul [velocity]
        fsubr [posX]
        fstp [posX]

        fldpi
        fidiv [toRadian]
        fmul [angleY]
        fsin
        fmul [velocity]
        fsubr[posZ]
        fstp [posZ]

        jmp     .ReturnZero
.MoveLeft:
        fld     [posZ]
        fsub    [step]
        fstp    [posZ]
        
        fld [cPosition + Vector3.z]
        fsub    [step]
        fstp [cPosition + Vector3.z]
        jmp     .ReturnZero

.MoveRight:
        fld     [posZ]
        fadd    [step]
        fstp    [posZ]
 
        jmp     .ReturnZero

.MoveFront:
        fld     [posY]
        fsub    [step]
        fstp    [posY]

        jmp     .ReturnZero

.MoveBack:
        fld     [posY]
        fadd    [step]
        fstp    [posY]

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

        jmp     .ReturnZero
.RotateLeftC:
        fld     [angleZ]
        fadd    [step]
        fstp    [angleZ]

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

.selectMode:
        cmp [drawingMode], 1
        je  .setFour
        mov [drawingMode], 1
        jmp @F

.setFour:
        mov [drawingMode], 4

@@:
        jmp .ReturnZero

.Destroy:
        invoke CloseHandle, [logFile]
        
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp

proc ParseVerticesOBJ uses edi esi,\
    buffer, length, verticesCount;, verticesBuff, indicesBuff

        locals
            resultVertices dd 0

        endl


        xor edx, edx
        mov ecx, 12
        mov eax, [verticesCount]
        mul ecx
        invoke  HeapAlloc, [hHeap], HEAP_ZERO_MEMORY, eax   ; eax
        mov     [resultVertices], eax

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [resultVertices]
.cycle:
        cmp byte[esi], 'v'
        jne .skipLine

        cmp byte [esi + 1], ' '
        jne .skipLine

        add esi, 2
        sub ecx, 2
        stdcall StrToFloat, esi
        mov [edi], eax
        add esi, 1
        dec ecx
        stdcall StrToFloat, esi
        mov [edi + 4], eax

        add esi, 1
        dec ecx
        stdcall StrToFloat, esi
        mov [edi + 8], eax

        add edi, 12
        add esi, 1
        dec ecx
        loop .cycle

.skipLine:

        cmp byte [esi], 10
        je @F
        cmp byte [esi], 0
        je @F
         dec ecx
         jz .end
        inc esi
        jmp .skipLine

@@:
        inc esi
        loop .cycle

.end:

       mov eax, [resultVertices]
    ret
endp


proc ParseIndicesOBJ uses ebx edi esi ,\
    buffer, length, indicesCount

        locals
            resultIndices dd 0
            iCount        dd 0
        endl

        xor edx, edx
        mov ecx, 20
        mov eax, [indicesCount]
        mul ecx

        invoke  HeapAlloc, [hHeap], HEAP_ZERO_MEMORY, eax  ; eax
        mov     [resultIndices], eax

        mov eax, [indicesCount]
        imul eax, eax, 3
        mov [iCount], eax

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [resultIndices]
.cycle:
        cmp byte[esi], 'f'
        jne .skipLine

        cmp byte [esi + 1], ' '
        jne .skipLine


        add esi, 2
        dec ecx
        dec ecx
        stdcall StrToInt, esi
        mov [edi], eax

        dec[iCount]

        stdcall SkipToSpace, esi

        inc esi
        dec ecx


        stdcall StrToInt, esi

        mov [edi +  4], eax

        dec[iCount]


        stdcall SkipToSpace, esi

        inc esi
        dec ecx

        stdcall StrToInt, esi
        mov [edi + 8], eax
        dec[iCount]
        add edi, 12

       jmp .ccc

.skipLine:

        cmp byte [esi], 10
        je @F
        cmp byte [esi], 0
        je @F
        dec ecx
        jz .end
        inc esi
        jmp .skipLine

@@:
        inc esi



.ccc:
        cmp [iCount], 0
        je .end
        loop .cycle

.end:
       mov eax, [resultIndices]

    ret
endp

proc SkipToSpace  pointer

        mov esi, [pointer]
.cycle:
        cmp byte[esi], ' '
        je @F
        inc esi
        dec ecx
        jmp .cycle

@@:
        ret
endp

proc CountVerticesOBJ uses esi,\
    buffer, length;, verticesBuff, indicesBuff

        locals
            verticesCount dd 0
            indicesCount dd 0
        endl

        mov esi, [buffer]
        mov ecx, [length]

.countCycle:
        cmp byte[esi], 'v'
        jne @F
        cmp byte[esi + 1], ' '
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
       mov ecx, [indicesCount]
    ret
endp



