        include "../include/Main.inc"

        className       db              "Slot car racing", 0
        clientRect      RECT            0, 0, 0, 0
        hHeap           dd              ?
        hdcBack         dd              ?
        hConsole        dd              ?
        time            dd              ?
        hdc             dd              ?
        radian          GLfloat         57.32
        
        circleD         GLfloat         10.0
        
        tempAngle       GLfloat         0.0
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
        pi              dd              3.14159
        step           GLfloat           5.0
        stepp           GLfloat         0.005
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
        fovY            GLfloat         70.0
        zNear           GLfloat         0.1
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
        aspect1     dd  ?

        nPos Vector3
        negPosition Matrix4x4
        backPosition Matrix4x4

        menuPosition    Vector3         200.0, 100.0, 100.0
        menuTargetPosition  Vector3     0.0, 0.0, 0.0

        lightPosition  Vector4         5.0, 5.1, 5.0, 1.0
        lightColor     Vector4         0.9, 0.9, 0.9, 1.0
        
        trackPointPosition1 Vector3 0.0, 0.0, 0.0
        trackPointPosition2 Vector3 0.0, 0.0, 0.0
        trackPointPosition3 Vector3 0.0, 0.0, 0.0
        trackPointPosition4 Vector3 0.0, 0.0, 0.0

cameraPosition1 Vector3         0.0, 0.0, 90.0
cameraDirPrev1  Vector3         60.66, 0.0, 90.0
cameraDirNext1  Vector3        -60.66, 0.0, 90.0

cameraPosition2 Vector3         0.0, 0.0, -10.0
cameraDirPrev2  Vector3        -60.66, 0.0, -10.0
cameraDirNext2  Vector3         60.66, 0.0, -10.0  

cameraPosition3 Vector3          0.0, 0.0, -110.0
cameraDirPrev3  Vector3          60.66, 0.0, -110.0
cameraDirNext3  Vector3         -60.66, 0.0, -110.0  

cameraPosition4 Vector3         0.0, 0.0, -10.0
cameraDirPrev4  Vector3        -60.66, 0.0, -10.0  
cameraDirNext4  Vector3         60.66, 0.0, -10.0

;  cameraPosition1 Vector3        45.0, 0.0, 90.0
;         cameraDirPrev1  Vector3         0.0, 0.0, 90.0
;         cameraDirNext1  Vector3         45.0, 0.0, 0.0

;         cameraPosition2 Vector3         45.0, 0.0, -90.0
;         cameraDirPrev2  Vector3         45.0, 0.0,  0.0
;         cameraDirNext2  Vector3         0.0, 0.0, -90.0 

;         cameraPosition3 Vector3         -45.0, 0.0, -90.0
;         cameraDirPrev3  Vector3          0.0, 0.0, -90.0 
;         cameraDirNext3  Vector3          -45.0, 0.0, 0.0

;         cameraPosition4 Vector3         -45.0, 0.0, 90.0
;         cameraDirPrev4  Vector3          -45.0, 0.0, 0.0
;         cameraDirNext4  Vector3          0.0, 0.0, 90.0

Position1 Vector3         0.0, 0.0, 90.0
DirPrev1  Vector3         60.66, 0.0, 90.0
DirNext1  Vector3        -60.66, 0.0, 90.0

Position2 Vector3         0.0, 0.0, -10.0
DirPrev2  Vector3        -60.66, 0.0, -10.0
DirNext2  Vector3         60.66, 0.0, -10.0  

Position3 Vector3          0.0, 0.0, -110.0
DirPrev3  Vector3          60.66, 0.0, -110.0
DirNext3  Vector3         -60.66, 0.0, -110.0  

Position4 Vector3         0.0, 0.0, -10.0
DirPrev4  Vector3        -60.66, 0.0, -10.0  
DirNext4  Vector3         60.66, 0.0, -10.0

tempVector Vector3

rotationPoint1 Vector4     0.0, 1.0, 0.0, 0.0
rotationPoint1Prev Vector4 0.0, 1.0, 0.0, 0.0
rotationPoint1Next Vector4 0.0, 1.0, 0.0, 20.0

rotationPoint2 Vector4     0.0, 1.0, 0.0, 90.0
rotationPoint2Prev Vector4 0.0, 1.0, 0.0, 40.0
rotationPoint2Next Vector4 0.0, 1.0, 0.0, 0.0

rotationPoints : Spline.Point rotationPoint1, rotationPoint1Prev, rotationPoint1Next, 1.0
                 Spline.Point rotationPoint2, rotationPoint2Prev, rotationPoint2Next, 1.0

rotationSpline   Spline          2, rotationPoints, 0, 2.0

        lightPosition1 Vector3     0.0, 50.0, 0.0
        lightPosition2 Vector3     0.0, 0.0, 0.0
        cubePoints:     Spline.Point    cameraPosition1, cameraDirPrev1, cameraDirNext1, 1.0
                        Spline.Point    cameraPosition2, cameraDirPrev2, cameraDirNext2, 1.0
                        Spline.Point    cameraPosition3, cameraDirPrev3, cameraDirNext3, 1.0
                        Spline.Point    cameraPosition4, cameraDirPrev4, cameraDirNext4, 1.0

        cubeSpline      Spline          4, cubePoints, 1, 4.0

        startTime       dd              0.0
        programTime     dd              ?   
        nprogramTime    dd              ?   

        oneSecond       GLfloat         1000.0   
        ten             dd              10.0
        cosAngle             dd                ?
        tempPosition     Vector3         0.0, 0.0, 0.0
        tempPosition1    Vector3         0.0, 0.0, 0.0 
        tempPosition2    Vector3         0.0, 0.0, 0.0      
        directionVector Vector3         
        rAngle          dd              0.0  
        v1Length         dd              0.0
        v2Length         dd              0.0
        productLenght    dd              0.0
        oneF            dd              1.0
        tempV           dd              0.0
        tempAngle2 dd 0.0
        tempAngle3 dd 0.0
        tempAngle4 dd 0.0

        tempPositionOnSpline dd ?
        tempValue       dd              ?
        one             dd              0.2     
        rVector         Vector3         0.0, 1.0, 0.0                                                     
        ninety          GLfloat         90.0
        null            dd              0.0
        epsilon         dd              0.0
        mepsilon         dd              -0.8
        tangentVector   Vector3         
        vec1 Vector3
        vec2 Vector3
        tempTime dd 0.0
        ;content db 108 dup(0) 
        temp dd ?
        GAME_MODE dd 0
        five dd 1.0
        KEY_PRESSED dd -1
        START_CRASH dd 0
        seed dd 0
        astep dd 20.0
        aastep dd 0.0
        direction dd 0.0
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
        include         "Game.asm"
        include         "TimeManager.asm"
        include         "Quaternion.asm"
        include         "UI.asm"
        include         "Camera.asm"
        include         "Light.asm"
        include         "Physics.asm"

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
        case    .KeyUp,         WM_KEYUP
        case    .MouseWheel,    WM_MOUSEWHEEL

        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return

.KeyUp:
    mov [KEY_PRESSED], 0
    ;cmp [wParam], VK_SPACE
    je .ResetAcceleration
    jmp .ReturnZero

.ResetAcceleration:
    fldz
    fstp [car.acceleration]
    jmp .ReturnZero

.Paint:

        cmp [GAME_MODE], 1
        je @F
        stdcall Draw
        jmp     .ReturnZero
@@:
        stdcall DrawMenu
        jmp     .ReturnZero

.KeyDown:
        switch [wParam]
        case .Destroy, 'P'
        case .GoToMenu, VK_ESCAPE
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
        case .Speed, VK_SPACE
        case .Speed2, VK_CONTROL
        case .Respawn, 'R'
        jmp     .ReturnZero
.Respawn:
        mov [PHYSICS_MODE], 0
        mov [START_CRASH], 0

        mov [car.acceleration], 0
        mov [car.speed], 0
        mov [speed2], 20.0
        
        stdcall	 GetRandomNumber, 10, 40
        mov [astep], eax
        fild [astep]
        fstp [astep]


        jmp .ReturnZero
.Speed2:
  
    jmp     .ReturnZero
.Speed:
    mov [KEY_PRESSED], 1
    fld [car.acceleration]
    fld [maxForce]
    fdiv [car.mass]
    faddp st1, st0
    fstp [car.acceleration]

    jmp     .ReturnZero
.GoToMenu:
        stdcall UI.Pause
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
        stdcall Vector3.Cross, cameraFront, upVector, tempCameraVector
        stdcall Vector3.Normalize, tempCameraVector
        stdcall Vector3.CrossValue, tempCameraVector, [cameraSpeed]

        stdcall Vector3.Sub, cameraPosition, tempCameraVector
        
        jmp     .ReturnZero

.MoveRight:
        stdcall Vector3.Cross, cameraFront, upVector, tempCameraVector
        stdcall Vector3.Normalize, tempCameraVector
        stdcall Vector3.CrossValue, tempCameraVector, [cameraSpeed]

        stdcall Vector3.Add, cameraPosition, tempCameraVector
        
        jmp     .ReturnZero

.MoveFront:  ;W

        ;cameraPos += cameraSpeed * cameraFront;

        stdcall Vector3.Copy, tempCameraVector, cameraFront
        stdcall Vector3.CrossValue, tempCameraVector, [cameraSpeed]
        stdcall Vector3.Add, cameraPosition, tempCameraVector


        ;stdcall Float.AddValue, car.transform.position.z, [stepp]
        jmp     .ReturnZero

.MoveBack:   ;S
        stdcall Vector3.Copy, tempCameraVector, cameraFront
        stdcall Vector3.CrossValue, tempCameraVector, [cameraSpeed]
        stdcall Vector3.Sub, cameraPosition, tempCameraVector

        ;stdcall Float.SubValue, car.transform.position.z, [stepp]
        jmp     .ReturnZero

.RotateLeft:
        ;cameraPos -= glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;

      jmp     .ReturnZero


.RotateRight:
        stdcall Float.SubValue, angleX, [step]
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
       stdcall Float.SubValue, car.transform.position.x, 5.0
       jmp     .ReturnZero
.RotateDown:
       stdcall Float.AddValue, car.transform.position.x, 5.0
       jmp     .ReturnZero


 .MouseWheel:
        mov     eax, [wParam]
        test    eax, 0x80000000
        jne     .Negative
        stdcall Vector3.AddValue, car.transform.scale, [scaleStep]
        jmp     .ReturnZero

.Negative:
        stdcall Vector3.SubValue, car.transform.scale, [scaleStep]
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
        invoke HeapDestroy, [hHeap]
        invoke CloseHandle, [logFile]
        invoke ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp
;3 479