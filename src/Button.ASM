proc Button.Press, index
     stdcall UI.SetDeactiveButton, [activeMenu], [activeButton]
     stdcall UI.SetActiveButton, [activeMenu], 0
     mov [activeButton], 0
     switch [index]
     case .Start, 0
     case .Settings, 1
     case .Exit, 2
.Start: 
     switch [GAME_MODE]
     case .SettingsMode1, SETTINGS
     case .SelectMenu, SELECTMENU
     case .MainMenu, MAINMENU
     case .PauseMenu, PAUSEMENU
     case .SelestMode, SELECTMODE
     case .GameMode, GAME
     .SettingsMode1:
          ret
     .SelectMenu:
          mov eax,  modesButtons
          mov [activeMenu], eax
          mov [GAME_MODE], SELECTMODE
          ret
     .MainMenu:
          mov [GAME_MODE], SELECTMENU
          mov eax,  selectModeButtons
          mov [activeMenu], eax
          ret
     .PauseMenu:
          mov [GAME_MODE], GAME
          ret
     .SelestMode:
          stdcall Button.selectMode, 30
     .GameMode:
     

          ret

.Settings: 
     switch [GAME_MODE]
     case .SettingsMode, SETTINGS
     case .SelectMenu1, SELECTMENU
     case .MainMenu1, MAINMENU
     case .PauseMenu1, PAUSEMENU
     case .SelestMode1, SELECTMODE
     case .GameMode1, GAME
     .SettingsMode:
          
          ret
     .SelectMenu1:
          mov [isBotGame], 1
          mov [GAME_MODE], SELECTMODE
          mov eax, modesButtons
          mov [activeMenu], eax
          ret
     .MainMenu1:
          mov [GAME_MODE], SETTINGS
          mov [fromMainMenu], 1
          ret
     .PauseMenu1:
          mov [GAME_MODE], SETTINGS
          mov [fromMainMenu], 0
          ret
     .SelestMode1:
     stdcall Button.selectMode, 60
          ret

          .GameMode1:
          ret


     ret
.Exit:
     switch [GAME_MODE]
     case .SettingsMode2, SETTINGS
     case .SelectMenu2, SELECTMENU
     case .MainMenu2, MAINMENU
     case .PauseMenu2, PAUSEMENU
     case .SelestMode2, SELECTMODE
     case .GameMode2, GAME
     .SettingsMode2:
          ret
     .SelectMenu2:
          ret
     .MainMenu2:
     invoke HeapDestroy, [hHeap]
     invoke CloseHandle, [logFile]
     invoke ExitProcess, ebx    
     .PauseMenu2:
     mov [GAME_MODE], MAINMENU
          ret
     .SelestMode2:
          stdcall Button.selectMode, 120
          ret

     .GameMode2:
          ret
    
     ret
endp

proc Button.selectMode, time
     mov [GAME_MODE], GAME
     mov eax,  menuButtons
     mov [activeMenu], eax
     mov eax, [time]
     mov [globalTimer], eax
     mov [car.acceleration], 0.0
     mov [car.speed], 0.0
     mov [car.positionOnSpline], 0.0
     mov [EXIT], 0
     stdcall IntToStr, [car.lapCount]
     mov [lapCountStr], eax
     stdcall IntToStr, [car2.lapCount]
     mov [lapCountStr2], eax
     mov [car.lapCount], 0
     mov [car2.lapCount], 0
     invoke CreateThread, 0, 0, DecrementThread, 0, 0, 0
     cmp [isBotGame], 1
     jne @F
     mov [isBotGame], 2
@@:
     ret
endp
proc Button.Create uses esi, objPtr, x, y, message, buttonColor, textColor
    locals
        length dd ?
    endl
    mov esi, [objPtr]
    add esi, Button.messageRect
    stdcall Rectangle.Create, esi, 0.0, 0.0, 1.0, 1.0
    stdcall Object.SetPosition, esi, [x], [y], 0.0
    mov esi, [objPtr]
    stdcall Texture.CreateRGBA, fontTexture, 512, 512
    mov [esi + Button.messageRect.texture], eax 

    stdcall GetStringLength, [message]
    mov [length], eax
    fild [length]
    fstp [length]
    mov esi, [objPtr]
    add esi, Button.buttonRect
    stdcall Rectangle.Create, esi, 0.0, 0.0, 9.0, 1.0
    stdcall Object.SetPosition, esi, [x], [y], 0.0
    mov esi, [objPtr]
    stdcall Texture.Create, buttonTexture
    mov [esi + Button.buttonRect.texture], eax 
    mov eax, [message]
    mov [esi + Button.message], eax
    mov eax, [x]
    mov [esi + Button.position.x], eax
    mov eax, [y]
    mov [esi + Button.position.y], eax

    mov eax, [buttonColor]
    mov [esi + Button.buttonColor], eax
    mov eax, [textColor]
    mov [esi + Button.textColor], eax



    ret
endp

proc Button.Draw uses esi, objPtr
    mov esi, [objPtr]
    lea eax, [esi + Button.messageRect]
    stdcall Sprite.DrawText, eax, [esi + Button.message], [esi + Button.position.x], [esi + Button.position.y], [esi + Button.textColor], 1.0
    lea eax, [esi + Button.buttonRect]
    stdcall Sprite.Draw, eax, [esi + Button.buttonColor]
  
    ret
endp