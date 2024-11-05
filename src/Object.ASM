proc Object.Create uses esi edi ,\
            objPtr, fileName, texFileName
    
    locals
        addressV     dd 0
        addressI     dd 0
        addressT     dd 0
        addressTI    dd 0
        resultT      dd 0

        vCount       dd 0
        iCount       dd 0
        tCount       dd 0
        buffer       dd 0
        bufferLength dd 0
        mesh         Mesh 

        vertexVBO    GLuint 0
        normalsVBO   GLuint 0
        textVBO      GLuint 0

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

    stdcall OBJ.ParseTextCoord, [buffer],  [bufferLength], [tCount]
    mov [addressT], eax

    stdcall OBJ.ParseTextCoordI, [buffer], [bufferLength], [iCount]
    mov [addressTI], eax
    
    stdcall Mesh.GenerateTextCoord, [tCount], [iCount], [addressT], [addressTI]
    mov [resultT], eax

    
    invoke HeapFree, [hHeap], 0, [addressT]
    invoke HeapFree, [hHeap], 0, [addressTI]

    stdcall Mesh.Generate, [objPtr], [resultT], [addressV], [addressI], [iCount]
    
    invoke HeapFree, [hHeap], 0, [addressI]
    invoke HeapFree, [hHeap], 0, [addressV]

    stdcall Mesh.CalculateNormals, [objPtr]
    mov esi, [objPtr]
    add esi, Object.VAO
    stdcall VAO.Init, esi, [objPtr]

    stdcall Texture.Create, [texFileName]
    mov esi, [objPtr]
    add esi, Object.texture
    mov [esi], eax

    mov esi, [objPtr]
    ;add esi, Object.transform
    mov [esi + Object.transform.position.x], 0.0
    mov [esi + Object.transform.position.y], 0.0
    mov [esi + Object.transform.position.z], 0.0

    mov [esi + Object.transform.rotation.x], 0.0
    mov [esi + Object.transform.rotation.y], 0.0
    mov [esi + Object.transform.rotation.z], 0.0

    mov [esi + Object.transform.scale.x], 1.0
    mov [esi + Object.transform.scale.y], 1.0
    mov [esi + Object.transform.scale.z], 1.0
    
    ret
endp