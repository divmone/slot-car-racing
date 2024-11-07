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
        stepp           GLfloat         1.0
        steppp          GLfloat         0.05
        length          GLfloat         5.0
        pVector         Vector3         0.0, 0.0, 0.0
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
        oScale          Vector3         1.0,  1.0,  1.0

        oTurn2           Vector3         0.0,  0.0,  0.0
        oPos2            Vector3         0.0,  0.0,  0.0
        objectColor     Vector3          1.0, 0.0, 0.0


        nPos Vector3
        negPosition Matrix4x4
        backPosition Matrix4x4

        cameraPosition  Vector3         100.0, 100.0, 100.0
        targetPosition  Vector3         0.0, 0.0, 0.0
        upVector        Vector3         0.0, 1.0, 0.0

        lightPosition  Vector4         5.0, 5.1, 5.0, 1.0
        lightColor     Vector3         1.0, 0.0, 0.0
        
        trackPointPosition1 Vector3 0.0, 0.0, 0.0
        trackPointPosition2 Vector3 0.0, 0.0, 0.0
        trackPointPosition3 Vector3 0.0, 0.0, 0.0
        trackPointPosition4 Vector3 0.0, 0.0, 0.0

        cameraPosition1 Vector3         45.0, 0.0, 90.0
        cameraDirPrev1  Vector3         0.0, 0.0, 90.0
        cameraDirNext1  Vector3         45.0, 0.0, 0.0

        cameraPosition2 Vector3         45.0, 0.0, -90.0
        cameraDirPrev2  Vector3         45.0, 0.0,  0.0
        cameraDirNext2  Vector3         0.0, 0.0, -90.0 

        cameraPosition3 Vector3         -45.0, 0.0, -90.0
        cameraDirPrev3  Vector3          0.0, 0.0, -90.0 
        cameraDirNext3  Vector3          -45.0, 0.0, 0.0

        cameraPosition4 Vector3         -45.0, 0.0, 90.0
        cameraDirPrev4  Vector3          -45.0, 0.0, 0.0
        cameraDirNext4  Vector3          0.0, 0.0, 90.0

        cubePoints:     Spline.Point    cameraPosition1, cameraDirPrev1, cameraDirNext1, 2.0
                        Spline.Point    cameraPosition2, cameraDirPrev2, cameraDirNext2, 1.0
                        Spline.Point    cameraPosition3, cameraDirPrev3, cameraDirNext3, 2.0
                        Spline.Point    cameraPosition4, cameraDirPrev4, cameraDirNext4, 1.0

        cubeSpline      Spline          4, cubePoints, 1, 6.0

        startTime       dd              ?
        lastTime        dd              ?
        currentTime     dd              ?
        programTime     dd              ?   
        oneSecond       GLfloat         1000.0      

        rVector         Vector3         0.0, 1.0, 0.0                                                     
        ninety          GLfloat         90.0

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
        switch [wParam]
        case .Destroy, VK_ESCAPE
        case .MoveLeft, VK_A   
        case .MoveRight, VK_D
        case .MoveFront, VK_W
        case .MoveBack, VK_S
        case .MoveUp, VK_E
        case .MoveDown,VK_Q
        case .RotateRight, 58h
        case .selectMode, 31h
        case .RotateLeft, 5Ah
        case .RotateLeftC, VK_LEFT
        case .RotateRightC, VK_RIGHT
        case .RotateUp, VK_UP
        case .RotateDown, VK_DOWN
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
        stdcall Float.AddValue, car.transform.position.x, [stepp]
        jmp     .ReturnZero

.MoveRight:
        stdcall Float.SubValue, car.transform.position.x, [stepp]
 
        jmp     .ReturnZero

.MoveFront:
        stdcall Float.AddValue, car.transform.position.z, [stepp]
        jmp     .ReturnZero

.MoveBack:
        stdcall Float.SubValue, car.transform.position.z, [stepp]
        jmp     .ReturnZero

.RotateLeft:
        stdcall Float.AddValue, car.transform.rotation.y, [step]
        jmp     .ReturnZero


.RotateRight:
        stdcall Float.SubValue, car.transform.rotation.y, [step]
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
        fadd    [steppp]
        fstp    [angleX]
        jmp     .ReturnZero
.RotateDown:
        fld     [angleX]
        fsub    [steppp]
        fstp    [angleX]
        jmp     .ReturnZero


 .MouseWheel:
        mov     eax, [wParam]
        test    eax, 0x80000000
        jne     .Negative
        stdcall Vector3.AddValue, oScale, [scaleStep]
        jmp     .ReturnZero

.Negative:
        stdcall Vector3.SubValue, oScale, [scaleStep]
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