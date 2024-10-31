proc Object.Create uses esi edi,\
            objPtr, fileName
    
    locals
        addressV     dd 0
        addressI     dd 0
        addressT     dd 0
        vCount       dd 0
        iCount       dd 0
        tCount       dd 0
        buffer       dd 0
        bufferLength dd 0
        mesh         Mesh   
    endl

    stdcall File.LoadContent, [fileName]
    mov [buffer], eax

    stdcall File.GetSize, [fileName]
    mov [bufferLength], eax

    lea eax, [vCount]
    lea ecx, [iCount]
    lea edx, [tCount]

    stdcall OBJ.CountObj,  [buffer], [bufferLength], eax, ecx, edx

    stdcall OBJ.ParseVertices, [buffer],  [bufferLength], [vCount]
    mov [addressV], eax

    stdcall OBJ.ParseIndices, [buffer],  [bufferLength], [iCount]
    mov [addressI], eax

    stdcall OBJ.ParseTextCoord, [buffer],  [bufferLength], [iCount]
    mov [addressT], eax

    stdcall Mesh.Generate, 0, [objPtr], false, [addressV], [addressI], [iCount]
      
    invoke HeapFree, [hHeap], 0, [addressT]
    invoke HeapFree, [hHeap], 0, [addressI]
    invoke HeapFree, [hHeap], 0, [addressV]

    ret
endp