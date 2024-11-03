        include "../include/OPENGL_DEMO.inc"

        className       db              "OpenGLDemo", 0
        clientRect      RECT            0, 0, 0, 0
        hHeap           dd              ?
        hdcBack         dd              ?
        hConsole        dd              ?
        time            dd              ?
        hdc             dd              ?
        radian          GLfloat         57.32
        
        circleD         GLfloat         10.0
        lightAngle      GLfloat         1.0
        angle           GLfloat         0.0
;transform
        
        angleY          GLfloat         0.0
        angleX          GLfloat         0.0
        angleZ          GLfloat         0.0

        posX            GLfloat         0.0
        posY            GLfloat         0.0
        posZ            GLfloat         0.0

        velocity        GLfloat         2.0


; fpu
        toRadian        GLfloat         180.0

        step           GLfloat           5.0
        stepp           GLfloat         0.01
        length          GLfloat         5.0
        pVector         Vector3         0.0, 0.0, 0.0
        programTime     dd              ?
        bufferLength    dd              0
        two             dd              1.5

        matrixT         Matrix4x4       ?
  
        size            dd             1000
        fileSize        dd             0
        isTransform     dd              0
        buffer          dd              0.0
        scaleStep       GLfloat         0.05
        scaleC          GLfloat         2.0

        drawingMode      dd              1

        plane           Mesh            planeVertices, 0, 0, PLANE_VERTICES_COUNT


        zero            GLfloat         0.0
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

        oPos            Vector3         0.0,  0.0,  0.0
        oTurn           Vector3         0.0,  0.0,  0.0

        oScale          Vector3         2.0,  2.0,  2.0

        
        objectColor     Vector3         1.0, 0.0, 0.0

        cameraPosition  Vector3         2.0, 5.0, 2.0
        targetPosition  Vector3         1.0, 0.0, 1.0
        upVector        Vector3         0.0, 1.0, 0.0

        lightPosition  Vector4         5.0, 5.1, 5.0, 1.0
        lightColor     Vector3         1.0, 0.0, 0.0


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
        include         "VBO.asm"
        include         "VAO.asm"
        include         "Texture.asm"
        include         "BMP.asm"
        include         "OBJ.asm"
        include         "Object.asm"

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

        stdcall Draw

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
        stdcall Mesh.Subdivide, car, car
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
        fld     [oPos + Vector3.x]
        fsub    [step]
        fstp    [oPos + Vector3.x]
        
        jmp     .ReturnZero

.MoveRight:
        fld     [oPos + Vector3.x]
        fadd    [step]
        fstp    [oPos + Vector3.x]
 
        jmp     .ReturnZero

.MoveFront:
        fld     [oPos + Vector3.y]
        fsub    [step]
        fstp    [oPos + Vector3.y]

        jmp     .ReturnZero

.MoveBack:
        fld     [oPos + Vector3.y]
        fadd    [step]
        fstp    [oPos + Vector3.y]

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
        fld [scaleC]
        fadd [scaleStep]
        fstp [scaleC]
        jmp     .ReturnZero

.Negative:
         fld [scaleC]
        fsub [scaleStep]
        fstp [scaleC]
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
        invoke HeapFree, [hHeap]
        invoke CloseHandle, [logFile]
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp
;3 479