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

    mov [esi + Object.q.x], 0.0
    mov [esi + Object.q.y], 0.0
    mov [esi + Object.q.z], 0.0
    mov [esi + Object.q.w], 0.0


    
    ret
endp


proc Object.SetRotation uses esi,\
               object, x, y, z

    mov esi, [object]

    mov eax, [x]
    mov [esi + Object.transform.rotation.x], eax

    mov eax, [y]
    mov [esi + Object.transform.rotation.y], eax

    mov eax, [z]
    mov [esi + Object.transform.rotation.z], eax

    ret
endp

proc Object.SetPosition uses esi,\
               object, x, y, z

    mov esi, [object]

    mov eax, [x]
    mov [esi + Object.transform.position.x], eax

    mov eax, [y]
    mov [esi + Object.transform.position.y], eax

    mov eax, [z]
    mov [esi + Object.transform.position.z], eax

    ret
endp

proc Object.SetScale uses esi,\
               object, x, y, z

    mov esi, [object]

    mov eax, [x]
    mov [esi + Object.transform.scale.x], eax

    mov eax, [y]
    mov [esi + Object.transform.scale.y], eax

    mov eax, [z]
    mov [esi + Object.transform.scale.z], eax


    
    ret
endp

proc Object.SetPositionV uses esi edi,\
               object, v

    mov     esi, [v]
    mov     edi, [object]
    add     edi, Object.transform.position
    mov     ecx, 12
    rep     movsb  
    ret
endp

proc Object.InitModelMatrix uses esi edi,\
                        objPtr
        
        mov esi, [objPtr]
        add esi, Object.transform.position
        stdcall Matrix.CreatePosition, esi, position  
        add esi, 12
        stdcall Matrix.CreateTurn, turn, esi     
        add esi, 12
        stdcall Matrix.CreateScale, esi, scale
        stdcall Matrix.Multiply4x4, scale, turn, model 
        stdcall Matrix.Multiply4x4, model, position, model 

        mov edi, [objPtr]
        add edi, Object.matrix
        mov esi, model
        mov ecx, 16
        rep movsd
    ret
endp

proc Object.SetMaterial uses esi, objPtr, ambient, diffuse, specular, shininess
    mov eax, [objPtr]
    add eax, Object.material.ambient
    memcpy eax, [ambient], 12

    mov eax, [objPtr]
    add eax, Object.material.diffuse
    memcpy esi, [diffuse], 12

    mov eax, [objPtr]
    add eax, Object.material.specular
    memcpy eax, [specular], 12

    mov esi, [objPtr] 
    mov eax, [shininess]
    mov [esi + Object.material.shininess], eax

    ret
endp