proc Button.Press, index
     switch [index]
     case .Enter, 0
     case .Settings, 1
     case .Exit, 2
.Enter:
     cmp [GAME_MODE], 2
     jne @F
     mov [car.acceleration], 0.0
     mov [car.speed], 0.0
     mov [car.positionOnSpline], 0.0
@@:
     mov [GAME_MODE], 0
     ret
.Settings: 
     ret
.Exit:
     invoke HeapDestroy, [hHeap]
     invoke CloseHandle, [logFile]
     invoke ExitProcess, ebx 
     ret
endp