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


    invoke HeapFree, [hHeap], 0, [resultT]
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
    movss xmm0, [x]           ; Load x into xmm0
    movss xmm1, [y]           ; Load y into xmm1
    movss xmm2, [z]

    movss [esi + Object.transform.position.x], xmm0
    movss [esi + Object.transform.position.y], xmm1
    movss [esi + Object.transform.position.z], xmm2
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

proc Object.Respawn uses esi, objPtr
    mov esi, [objPtr]

    mov [esi + Object.isFreeFall], 0
    mov [esi + Object.isCrashed], 0

    mov [esi + Object.acceleration], 0
    mov [esi + Object.speed], 0
    mov [esi + Object.speed2], 20.0
        
    stdcall	 GetRandomNumber, 10, 40
    mov [esi + Object.astep], eax
    fild [esi + Object.astep]
    fstp [esi + Object.astep]

    ret
endp

proc Object.SetAcceleration uses esi, objPtr
    mov esi, [objPtr]
    fld dword[esi + Object.acceleration]
    fld [maxForce]
    fdiv dword[esi + Object.mass]
    faddp st1, st0
    fstp dword[esi + Object.acceleration]
    ret
endp

proc Object.ResetAcceleration uses esi, objPtr
    mov esi, [objPtr]
    fldz
    fstp dword[esi + Object.acceleration] 
    
    ret
endp

proc Grass.InitArray uses esi edi ebx
    locals
        tempX dd 0.0
        tempY dd 0.0
        tempTime dd 0.0
        step dd 0.01
        maxB dd 4.0
        size dd ?
        buffer dd ?
        vbo dd ?
        sizeOfArr dd ?
        width dd 100
        heigth dd 100
    endl
    xor edx, edx
    mov eax, [width]
    mov ecx, [heigth]
    mul ecx
    mov ecx,  sizeof.Matrix4x4
    mul ecx
    mov [size], eax
    malloc eax
    mov [buffer], eax
 
    mov ebx, [buffer]
    mov ecx, [size]
     mov ebx, [buffer]
    mov ecx, [size]
    

    xor esi, esi             
.loopX:
    xor edi, edi             
.loopY:
    fld [esi]
    fmul [step]                ; X = esi * step
    fstp qword ptr [tempTime]  ; Сохраняем X в tempTime

    fld [edi]
    fmul [step]                ; Y = edi * step
    fstp qword ptr [tempTime+8] ; Сохраняем Y в tempTime + 8

    ; Преобразуем позицию в модельную матрицу
    push tempTime              ; Позиция X, Y
    stdcall Object.SetPosition, grass, 
    stdcall Matrix.CreateModel, grass
    memcpy ebx, model, 64      ; Копирование матрицы модели в буфер
    add ebx, sizeof.Matrix4x4  ; Переход к следующей ячейке в буфере

    inc edi                    ; Переход к следующей строке
    cmp edi, [heigth]           ; Проверяем, достигли ли конца по Y
    jl .loopY                   ; Если нет, продолжаем

    inc esi                    ; Переход к следующему столбцу
    cmp esi, [width]            ; Проверяем, достигли ли конца по X
    jl .loopX                   ; Если нет, продолжаем

    pop ecx                     ; Восстанавливаем контекст
    loop .loop                  ; Повторяем цикл для каждой ячейки сетки


    lea eax, [vbo]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [vbo]

    invoke glBufferData, GL_ARRAY_BUFFER, [sizeOfArr], [buffer], GL_STATIC_DRAW
    invoke  HeapFree, [hHeap], ebx, [buffer]
    invoke glBindVertexArray, [road.VAO]
    invoke glEnableVertexAttribArray, 3 
    invoke glVertexAttribPointer, 3, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 0
    invoke glEnableVertexAttribArray, 4
    invoke glVertexAttribPointer, 4, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 16
    invoke glEnableVertexAttribArray, 5
    invoke glVertexAttribPointer, 5, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 32
    invoke glEnableVertexAttribArray, 6
    invoke glVertexAttribPointer, 6, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 48
    invoke glVertexAttribDivisor, 3, 1
    invoke glVertexAttribDivisor, 4, 1
    invoke glVertexAttribDivisor, 5, 1
    invoke glVertexAttribDivisor, 6, 1
    invoke glBindVertexArray, 0
    ret
endp

proc Track.InitArray uses esi edi ebx
    locals
        tempTime dd 0.0
        step dd 0.01
        maxB dd 4.0
        size dd ?
        buffer dd ?
        vbo dd ?
        sizeOfArr dd ?
    endl
    mov eax, [cubeSpline.time]
    mov [maxB], eax

    fld [maxB]
    fdiv [step]
    fist [instanseAmount]
    fistp [size]

    mov eax, [size]
    xor edx, edx
    mov ecx, sizeof.Matrix4x4
    mul ecx
    mov [sizeOfArr], eax
    malloc eax 
    mov [buffer], eax

    mov ebx, [buffer]
    mov ecx, [size]
    
.loop:
    push ecx
    stdcall Spline.GetPoint, cubeSpline, road.transform.position, [tempTime] 
    stdcall Spline.GetRotation, cubeSpline, road, [tempTime]                                                                              
    stdcall Matrix.CreateModel, road   
    memcpy ebx, model, 64
    add ebx, sizeof.Matrix4x4

    fld [tempTime]
    fadd [step]
    fstp [tempTime]

    pop ecx
    loop .loop

    lea eax, [vbo]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [vbo]

    invoke glBufferData, GL_ARRAY_BUFFER, [sizeOfArr], [buffer], GL_STATIC_DRAW
    invoke  HeapFree, [hHeap], ebx, [buffer]
    invoke glBindVertexArray, [road.VAO]
    invoke glEnableVertexAttribArray, 3 
    invoke glVertexAttribPointer, 3, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 0
    invoke glEnableVertexAttribArray, 4
    invoke glVertexAttribPointer, 4, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 16
    invoke glEnableVertexAttribArray, 5
    invoke glVertexAttribPointer, 5, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 32
    invoke glEnableVertexAttribArray, 6
    invoke glVertexAttribPointer, 6, 4, GL_FLOAT, GL_FALSE, sizeof.Matrix4x4, 48
    invoke glVertexAttribDivisor, 3, 1
    invoke glVertexAttribDivisor, 4, 1
    invoke glVertexAttribDivisor, 5, 1
    invoke glVertexAttribDivisor, 6, 1
    invoke glBindVertexArray, 0
    ret
endp

proc Object.CheckLap uses esi, objPtr
    locals
        oldState dw ?
        newState dw ?
        laps dd 0 
    endl

    mov esi, [objPtr]
    fstcw [oldState]    
    mov ax, [oldState]  
    or ax, 0c00h        
    mov [newState], ax  
    fldcw [newState]    
    fld [esi + Object.positionOnSpline] 
    fdiv [cubeSpline.time]
    fistp [laps]      
    fldcw [oldState] 
    mov eax, [laps]
    ret
endp
