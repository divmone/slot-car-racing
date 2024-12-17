proc Log.Create uses edi esi ebx eax

    ; invoke  AllocConsole
    ; invoke  GetStdHandle,  STD_OUTPUT_HANDLE
    ; mov     [hConsole], eax

    ; stdcall Log, okMessage, okMessage.size


    ret
endp

proc Log.Console  buffer, length
   
    invoke  WriteConsole, [hConsole], [buffer], [length], 0, 0

    ret
endp

proc Log.File  buffer, length
    invoke  CreateFile, logFileName, GENERIC_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov [logFile], eax  
    invoke  WriteFile, [logFile], [buffer], [length], 0, 0

    ret
endp

proc Log buffer, length
    
    ;stdcall Log.Console, [buffer], [length]
   ; stdcall Log.File, [buffer], [length]

    ret
endp
