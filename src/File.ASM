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
       
        ret
endp

proc File.GetSize uses edi,\
        fileName
        
        locals
                hFile   dd      ? 
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], ebx
        inc     eax

    ret
endp

proc File.Create uses edi ,\
        fileName
        
        locals
                hFile   dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
        mov [hFile], eax
        cmp     eax, INVALID_HANDLE_VALUE
        je      .Error
        
        stdcall Log, FILE_CREATED_SUCCESSFULLY, FILE_CREATED_SUCCESSFULLY.size

        mov eax, [hFile]
        ret
.Error:
        stdcall Log, FILE_CREATION_FAILED , FILE_CREATION_FAILED.size
        mov eax, [hFile]
        ret
endp

proc File.WriteContent uses edi ,\
        fileName, buffer, length

        locals
                hFile   dd      ?
                pBuffer dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax

        invoke  WriteFile, [hFile], [buffer], [length], edi, ebx

        ret
endp