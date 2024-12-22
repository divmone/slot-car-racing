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

        drawingMode      dd              4

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

Position1 Vector3         -1.65, 0.0,  91.11 
DirPrev1  Vector3         59.00, 0.0, 91.11
DirNext1  Vector3        -62.31, 0.000, 88.88

Position2 Vector3         0.325, 0.0, -11.97
DirPrev2  Vector3        -60.33, 0.0, -11.97
DirNext2  Vector3         60.98, 0.0, -8.02

Position3 Vector3         1.75, 0.0, -109.034
DirPrev3  Vector3          62.41, 0.0, -109.034
DirNext3  Vector3         -58.90, 0.0, -110.96

Position4 Vector3         0.32, 0.0, -11.97
DirPrev4  Vector3        -60.33, 0.0, -11.97
DirNext4  Vector3         60.98, 0.0, -8.027

Position12 Vector3        -3.317, 0.000, 92.236
DirPrev12  Vector3        57.343, 0.000, 92.236
DirNext12  Vector3        -63.977, 0.000, 87.764

Position22 Vector3         0.651, 0.000, -13.947
DirPrev22  Vector3        -60.009, 0.000, -13.947   
DirNext22  Vector3         61.311, 0.000, -6.053

Position32 Vector3         3.503, 0.000, -108.068
DirPrev32  Vector3          64.163, 0.000, -108.068
DirNext32  Vector3         -57.157, 0.000, -111.932

Position42 Vector3        0.651, 0.000, -13.947
DirPrev42  Vector3        -60.009, 0.000, -13.947
DirNext42  Vector3         61.311, 0.000, -6.053


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
threadId dd ?
mutex dd ?

tempVector Vector3

rotationPoint1 Vector4     0.0, 1.0, 0.0, 0.0
rotationPoint1Prev Vector4 0.0, 1.0, 0.0, 0.0
rotationPoint1Next Vector4 0.0, 1.0, 0.0, 20.0

rotationPoint2 Vector4     0.0, 1.0, 0.0, 90.0
rotationPoint2Prev Vector4 0.0, 1.0, 0.0, 40.0
rotationPoint2Next Vector4 0.0, 1.0, 0.0, 0.0

        cubePoints:     Spline.Point    cameraPosition1, cameraDirPrev1, cameraDirNext1, 1.0
                        Spline.Point    cameraPosition2, cameraDirPrev2, cameraDirNext2, 1.0
                        Spline.Point    cameraPosition3, cameraDirPrev3, cameraDirNext3, 1.0
                        Spline.Point    cameraPosition4, cameraDirPrev4, cameraDirNext4, 1.0

        cubeSpline      Spline          4, cubePoints, 1, 4.0

        tracePoints1:   Spline.Point    Position1, DirPrev1, DirNext1, 1.0
                        Spline.Point    Position2, DirPrev2, DirNext2, 1.0
                        Spline.Point    Position3, DirPrev3, DirNext3, 1.0
                        Spline.Point    Position4, DirPrev4, DirNext4, 1.0

        traceSpline1      Spline          4, tracePoints1, 1, 4.0

        tracePoints2:   Spline.Point    Position12, DirPrev12, DirNext22, 1.0
                        Spline.Point    Position22, DirPrev22, DirNext22, 1.0
                        Spline.Point    Position32, DirPrev32, DirNext32, 1.0
                        Spline.Point    Position42, DirPrev42, DirNext42, 1.0

        traceSpline2      Spline          4, tracePoints1, 1, 4.0

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
        GAME_MODE dd SPLASHSCREEN
        five dd 1.0
        KEY_PRESSED dd -1
        START_CRASH dd 0
        seed dd 0
        astep dd 20.0
        aastep dd 0.0
        direction dd 0.0
        aspect          dd              ?
        tempVec Vector3 0.0, 1.0, 0.0
        instanseAmount dd ?
        counter dd 0
        globalTimer dd 100
        hThread    dd 0                
        dwThreadId dd 0  
        lapCountStr dd ?
        globalTimerStr dd  ? 
        EXIT dd 0   
        activeMenu dd menuButtons
        isGameEnd dd 0

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
        include         "2D.asm"
        include         "Button.asm"

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

proc RenderThreadProc
   


    ret
endp

proc WindowProc uses ebx,\
     hWnd, uMsg, wParam, lParam

    xor     ebx, ebx
    
    switch  [uMsg]
    
    case    .Destroy,       WM_DESTROY
    case    .KeyDown,       WM_KEYDOWN
    case    .KeyUp,         WM_KEYUP
    case    .MouseWheel,    WM_MOUSEWHEEL
    case    .Paint,         WM_PAINT
    

    invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
    jmp     .Return

.KeyUp:
    switch [wParam]
        case .ResetAcceleration1, VK_A
        case .ResetAcceleration2, VK_L
    jmp .ReturnZero

.ResetAcceleration1:
    stdcall Object.ResetAcceleration, car
    jmp .ReturnZero
.ResetAcceleration2:
    stdcall Object.ResetAcceleration, car2
    jmp .ReturnZero
.Paint:
    switch [GAME_MODE]
    case .RenderSplashScreen, SPLASHSCREEN
    case .RenderMainMenu, MAINMENU
    case .RenderMainMenu, SELECTMENU
    case .RenderMainMenu, SELECTMODE
    case .RenderMenu, PAUSEMENU
    case .RenderGame, GAME
    case .RenderEndGame, ENDGAME
    

.RenderSplashScreen:
    stdcall DrawSplashScreen
    jmp .RenderCommon
.RenderGame:
    stdcall Draw
    jmp .RenderCommon
.RenderMainMenu:
    stdcall UI.DrawMainMenu, [activeMenu]
    jmp .RenderCommon
.RenderMenu:
    stdcall Draw
    stdcall DrawMenu, [activeMenu]
    jmp .RenderCommon
.RenderEndGame:
    stdcall Draw
    stdcall DrawEndGame
    ;stdcall DrawMenu, [activeMenu]
.RenderCommon:
    invoke SwapBuffers, [hdc]
    jmp .ReturnZero

.KeyDown:
    switch [wParam]
        case .Destroy, 'P'
        case .GoToMenu, VK_ESCAPE
        case .IncActiveButton, VK_DOWN
        case .DecActiveButton, VK_UP
        case .ChangeCameraMode, VK_W
        case .SelectDrawMode, 31h
        case .Speed, VK_A
        case .Speed2, VK_L
        case .Respawn1, VK_R
        case .Respawn2, VK_U
        case .Enter, VK_RETURN
    jmp     .ReturnZero
.Enter:
    stdcall Button.Press, [activeButton]
    stdcall UI.SetActiveButton, [activeMenu], 0
    jmp .ReturnZero
.IncActiveButton:
    cmp [GAME_MODE], SELECTMODE
    je @F
    cmp [GAME_MODE], MAINMENU
    je @F
    cmp [GAME_MODE], SELECTMENU
    je @F
    cmp [GAME_MODE], PAUSEMENU
    jne .ReturnZero
@@:
    stdcall UI.SetDeactiveButton,[activeMenu], [activeButton]
    cmp [activeButton], 1
    ja @f
    inc [activeButton]
    stdcall UI.SetActiveButton, [activeMenu],[activeButton]
    jmp .ReturnZero
@@:
    mov [activeButton], 0
    stdcall UI.SetActiveButton,[activeMenu], [activeButton]
    jmp .ReturnZero
.DecActiveButton:
    cmp [GAME_MODE], SELECTMODE
    je @F
    cmp [GAME_MODE], MAINMENU
    je @F
    cmp [GAME_MODE], SELECTMENU
    je @F
    cmp [GAME_MODE], PAUSEMENU
    jne .ReturnZero
@@:
    stdcall UI.SetDeactiveButton, [activeMenu],[activeButton]
 
    cmp [activeButton], 1
    jb @f
    dec [activeButton]

    stdcall UI.SetActiveButton,[activeMenu], [activeButton]
    jmp .ReturnZero
@@:
    mov [activeButton], 2
    stdcall UI.SetActiveButton, [activeMenu], [activeButton]
    jmp .ReturnZero
.Respawn1:
    switch [GAME_MODE]
    case .1, GAME
    case .2, ENDGAME
.1:
    stdcall Object.Respawn, car
    jmp .ReturnZero
.2:
    mov [GAME_MODE], SELECTMENU
    mov eax,  selectModeButtons
    mov [activeMenu], eax
    stdcall Object.Respawn, car
    jmp .ReturnZero
.Respawn2:
    stdcall Object.Respawn, car2
    jmp .ReturnZero
.Speed2:
    stdcall Object.SetAcceleration, car2
    jmp     .ReturnZero
.Speed:
    stdcall Object.SetAcceleration, car
    jmp     .ReturnZero
.GoToMenu:
    stdcall UI.SetDeactiveButton, [activeMenu],[activeButton]
    stdcall UI.Pause
    stdcall UI.SetActiveButton, [activeMenu], 0
    jmp     .ReturnZero
.ChangeCameraMode:  ;W
    cmp [CAMERA_MODE], 0
    je @F
    mov [CAMERA_MODE], 0
    stdcall Vector3.Copy, tempCameraVector, cameraPosition
    stdcall Vector3.Copy, targetPosition, tVector
    jmp     .ReturnZero
@@:
    mov [CAMERA_MODE], 1
    jmp     .ReturnZero
.MouseWheel:
    mov     eax, [wParam]
    test    eax, 0x80000000
    jne     .Negative
    stdcall Vector3.Add,  lightPosition, tVector
    jmp     .ReturnZero    
.Negative:
    stdcall Vector3.Sub,  lightPosition, tVector
    jmp     .ReturnZero    
.SelectDrawMode:
    cmp [drawingMode], 1
    je  .SetFour
    mov [drawingMode], 1
    jmp @F    
.SetFour:
    mov [drawingMode], 4

@@:
    jmp .ReturnZero

.Destroy:
    invoke HeapDestroy, [hHeap]
    invoke CloseHandle, [logFile]
    invoke ExitProcess, ebx
    mov [EXIT], 1

.ReturnZero:
    xor     eax, eax

.Return:
    ret
endp