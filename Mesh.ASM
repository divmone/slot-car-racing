proc Mesh.Generate uses ebx esi edi,\
     sourceMesh, resultMesh , copyColors

        locals
                verticesCount   dd      ?
                vertices        dd      ?
                colors          dd      ?
                resultIndex     dd      ?
                resultVertices  dd      ?
                resultColors    dd      ?
                resultNormals   dd      ?
                indices         dd      ?
        endl

        mov     esi, [sourceMesh]
        mov     edi, [resultMesh]

        mov     eax, [esi + PackedMesh.vertices]
        mov     [vertices], eax
        mov     eax, [esi + PackedMesh.colors]
        mov     [colors], eax
        mov     eax, [esi + PackedMesh.indices]
        mov     [indices], eax

        mov     [resultIndex], ebx

        mov     eax, [esi + PackedMesh.trianglesCount]
        ; mov     [edi + Mesh.trianglesCount], eax
        xor     edx, edx
        mov     ecx, 3
        mul     ecx
        mov     [verticesCount], eax    ; verticesCount = trianglesCount * 3
        xor     edx, edx
        mov     ecx, sizeof.Vertex
        mul     ecx

        push    eax
        push    eax
        push    eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [resultVertices], eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [resultColors], eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [resultNormals], eax

        mov     ecx, [verticesCount]

.CopyCycle:
        push    ecx

        xor     edx, edx
        mov     esi, [indices]
        movzx   eax, word[esi + ebx * 4]    ; index
        mov     edi, sizeof.Vertex
        mul     edi                     ; index * sizeof.Vertex

        mov     esi, [vertices]
        add     esi, eax                ; vertices + index * sizeof.Vertex = vertices[index]

        xor     edx, edx
        mov     eax, [resultIndex]      ; resultIndex
        mov     edi, sizeof.Vertex
        mul     edi                     ; resultIndex * sizeof.Vertex

        mov     edi, [resultVertices]
        add     edi, eax                ; resultVertices + resultIndex * sizeof.Vertex = resultVertices[resultIndex]

        mov     eax, [esi + Vertex.x]   ; x = vertices[index].x
        mov     ecx, [esi + Vertex.y]   ; y = vertices[index].y
        mov     edx, [esi + Vertex.z]   ; z = vertices[index].z
        mov     [edi + Vertex.x], eax   ; resultVertices[resultIndex].x = x
        mov     [edi + Vertex.y], ecx   ; resultVertices[resultIndex].y = y
        mov     [edi + Vertex.z], edx   ; resultVertices[resultIndex].z = z


        cmp     [copyColors], false
        je      .DoNotCopyColors;
        xor     edx, edx
        mov     esi, [indices]
        movzx   eax, byte[esi + ebx]    ; index
        mov     edi, sizeof.Color
        mul     edi                     ; index * sizeof.Color

        mov     esi, [colors]
        add     esi, eax                ; colors + index * sizeof.Color = colors[index]

        xor     edx, edx
        mov     eax, [resultIndex]      ; resultIndex
        mov     edi, sizeof.Color
        mul     edi                     ; resultIndex * sizeof.Color

        mov     edi, [resultColors]
        add     edi, eax                ; resultColors + resultIndex * sizeof.Color = resultColors[resultIndex]

        mov     eax, [esi + Color.r]    ; r = colors[index].r
        mov     ecx, [esi + Color.g]    ; g = colors[index].g
        mov     edx, [esi + Color.b]    ; b = colors[index].b
        mov     [edi + Color.r], eax    ; resultColors[resultIndex].r = r
        mov     [edi + Color.g], ecx    ; resultColors[resultIndex].g = g
        mov     [edi + Color.b], edx    ; resultColors[resultIndex].b = b

.DoNotCopyColors:

        inc     ebx
        inc     [resultIndex]

        pop     ecx
        loop    .CopyCycle

        mov     edi, [resultMesh]

        mov     eax, [resultVertices]
        mov     [edi + Mesh.vertices], eax
        mov     eax, [resultColors]
        mov     [edi + Mesh.colors], eax
        mov     eax, [resultNormals]
        mov     [edi + Mesh.normals], eax
        mov     eax, [verticesCount]
        mov     [edi + Mesh.verticesCount], eax

        ret
endp

proc Mesh.CalculateNormals uses esi edi ebx,\
     mesh

        locals
                trianglesCount  dd      ?
                v1              Vector3
                v2              Vector3
                normal          Vector3
        endl

        mov     esi, [mesh]

        mov     eax, [esi + Mesh.verticesCount]
        xor     edx, edx
        mov     ecx, 3
        div     ecx
        mov     [trianglesCount], eax

        mov     edi, [esi + Mesh.normals]
        mov     esi, [esi + Mesh.vertices]

        mov     ecx, [trianglesCount]

.CalculateNormalsLoop:
        push    ecx

        lea     ebx, [v1]
        add     esi, sizeof.Vector3 * 2
        stdcall Vector3.Copy, ebx, esi

        sub     esi, sizeof.Vector3 * 2
        stdcall Vector3.Sub, ebx, esi

        stdcall Vector3.Normalize, ebx

        lea     ebx, [v2]
        add     esi, sizeof.Vector3 * 1
        stdcall Vector3.Copy, ebx, esi

        sub     esi, sizeof.Vector3 * 1
        stdcall Vector3.Sub, ebx, esi

        stdcall Vector3.Normalize, ebx

        lea     ebx, [normal]
        push    ebx
        lea     ebx, [v1]
        push    ebx
        lea     ebx, [v2]
        push    ebx
        stdcall Vector3.Cross

        lea     ebx, [normal]
        stdcall Vector3.Normalize, ebx

        lea     ebx, [normal]
        stdcall Vector3.Copy, edi, ebx
        add     edi, sizeof.Vector3 * 1
        stdcall Vector3.Copy, edi, ebx
        add     edi, sizeof.Vector3 * 1
        stdcall Vector3.Copy, edi, ebx
        add     edi, sizeof.Vector3 * 1

        add     esi, sizeof.Vector3 * 3

        pop     ecx
        loop    .CalculateNormalsLoop

        ret
endp

proc Mesh.Subdivide uses esi edi ebx,\
     sourceMesh, resultMesh

        locals
                trianglesCount          dd      ?
                verticesCount           dd      ?
                newVerticesCount        dd      ?
                newTrianglesCount       dd      ?
                vertices                dd      ?
                colors                  dd      ?
                newVertices             dd      ?
                newColors               dd      ?
                newNormals              dd      ?
                index                   dd      ?
                center                  Vertex
                oldV                    dd      (sizeof.Vertex * 3 / 4) dup ?
                middlePoints            dd      (sizeof.Vertex * 3 / 4) dup ?
                newV                    dd      (sizeof.Vertex * 12 / 4) dup ?
        endl

        mov     esi, [sourceMesh]
        mov     edi, [resultMesh]

        mov     eax, [esi + Mesh.verticesCount]
        mov     [verticesCount], eax
        xor     edx, edx
        mov     ecx, 3
        div     ecx
        mov     [trianglesCount], eax
        shl     eax, 2
        mov     [newTrianglesCount], eax

        mov     eax, [verticesCount]
        shl     eax, 2
        mov     [newVerticesCount], eax

        mov     eax, [esi + Mesh.vertices]
        mov     [vertices], eax
        mov     eax, [esi + Mesh.colors]
        mov     [colors], eax

        mov     eax, [newVerticesCount]
        xor     edx, edx
        mov     ecx, sizeof.Vertex
        mul     ecx

        push    eax
        push    eax
        push    eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [newVertices], eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [newColors], eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [newNormals], eax

        mov     [index], ebx
        mov     [center.x], ebx
        mov     [center.y], ebx
        mov     [center.z], ebx

        mov     esi, [vertices]
        mov     ecx, [verticesCount]

.SumVerticesLoop:
        fld     [esi + Vertex.x]
        fadd    [center.x]
        fstp    [center.x]
        fld     [esi + Vertex.y]
        fadd    [center.y]
        fstp    [center.y]
        fld     [esi + Vertex.z]
        fadd    [center.z]
        fstp    [center.z]

        mov     eax, sizeof.Vertex
        add     esi, eax

        loop    .SumVerticesLoop

        fld     [center.x]
        fdiv    [verticesCount]
        fstp    [center.x]

        fld     [center.y]
        fdiv    [verticesCount]
        fstp    [center.y]

        fld     [center.z]
        fdiv    [verticesCount]
        fstp    [center.z]

        mov     ecx, [trianglesCount]

.SubdivideLoop:
        push    ecx

        mov     eax, [trianglesCount]
        sub     eax, ecx
        xor     edx, edx
        mov     ecx, sizeof.Vertex * 3
        mul     ecx

        mov     esi, [sourceMesh]
        mov     esi, [vertices]
        add     esi, eax
        lea     edi, [oldV]
        mov     ecx, sizeof.Vertex * 3 / 4
        rep     movsd

        lea     esi, [oldV]
        lea     edi, [center]
        lea     ebx, [middlePoints]

        push    ebx
        push    edi
        add     esi, sizeof.Vertex * 1
        push    esi
        sub     esi, sizeof.Vertex * 1
        push    esi
        stdcall GetSmoothPoint

        add     ebx, sizeof.Vertex * 1
        push    ebx
        push    edi
        add     esi, sizeof.Vertex * 2
        push    esi
        sub     esi, sizeof.Vertex * 1
        push    esi
        stdcall GetSmoothPoint

        add     ebx, sizeof.Vertex * 1
        push    ebx
        push    edi
        add     esi, sizeof.Vertex * 1
        push    esi
        sub     esi, sizeof.Vertex * 2
        push    esi
        stdcall GetSmoothPoint

        jmp     .CopyVertices

.Continue:
        pop     ecx
        loop    .SubdivideLoop

        jmp     .CopyResults

.CopyVertices:
        lea     esi, [oldV]
        lea     edi, [newV]
        lea     ebx, [middlePoints]

        mov     eax, [esi + sizeof.Vertex * 0 + Vertex.x]
        stosd
        mov     eax, [esi + sizeof.Vertex * 0 + Vertex.y]
        stosd
        mov     eax, [esi + sizeof.Vertex * 0 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.z]
        stosd

        mov     eax, [esi + sizeof.Vertex * 1 + Vertex.x]
        stosd
        mov     eax, [esi + sizeof.Vertex * 1 + Vertex.y]
        stosd
        mov     eax, [esi + sizeof.Vertex * 1 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 0 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 2 + Vertex.z]
        stosd

        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.x]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.y]
        stosd
        mov     eax, [ebx + sizeof.Vertex * 1 + Vertex.z]
        stosd

        mov     eax, [esi + sizeof.Vertex * 2 + Vertex.x]
        stosd
        mov     eax, [esi + sizeof.Vertex * 2 + Vertex.y]
        stosd
        mov     eax, [esi + sizeof.Vertex * 2 + Vertex.z]
        stosd

        lea     esi, [newV]
        mov     edi, [newVertices]

        xor     edx, edx
        mov     eax, [index]
        mov     ecx, sizeof.Vertex
        mul     ecx
        add     edi, eax

        add     [index], 12

        mov     ecx, sizeof.Vertex * 12 / 4
        rep     movsd

        jmp     .Continue

.CopyResults:

        mov     edi, [resultMesh]

        mov     eax, [newVertices]
        mov     [edi + Mesh.vertices], eax
        mov     eax, [newColors]
        mov     [edi + Mesh.colors], eax
        mov     eax, [newNormals]
        mov     [edi + Mesh.normals], eax
        mov     eax, [newTrianglesCount]
        mov     [edi + Mesh.verticesCount], eax

        stdcall Mesh.CalculateNormals, edi

        ret
endp

proc GetSmoothPoint uses esi edi ebx,\
     v1, v2, center, result

        locals
                middlePoint     Vertex
                length1         dd      ?
                length2         dd      ?
                averageLength   dd      ?
                two             dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]
        mov     ebx, [result]

        fld1
        fld1
        faddp
        fstp    [two]

        fld     [esi + Vertex.x]
        fadd    [edi + Vertex.x]
        fdiv    [two]
        fstp    [middlePoint.x]

        fld     [esi + Vertex.y]
        fadd    [edi + Vertex.y]
        fdiv    [two]
        fstp    [middlePoint.y]

        fld     [esi + Vertex.z]
        fadd    [edi + Vertex.z]
        fdiv    [two]
        fstp    [middlePoint.z]

        mov     esi, [center]

        fld     [middlePoint.x]
        fsub    [esi + Vertex.x]
        fstp    [ebx + Vertex.x]

        fld     [middlePoint.y]
        fsub    [esi + Vertex.y]
        fstp    [ebx + Vertex.y]

        fld     [middlePoint.z]
        fsub    [esi + Vertex.z]
        fstp    [ebx + Vertex.z]

        stdcall Vector3.Distance, esi, [v1]
        mov     [length1], eax

        stdcall Vector3.Distance, esi, [v2]
        mov     [length2], eax

        fld     [length1]
        fadd    [length2]
        fdiv    [two]
        fstp    [averageLength]

        stdcall Vector3.Normalize, ebx

        fld     [ebx + Vertex.x]
        fmul    [averageLength]
        fstp    [ebx + Vertex.x]

        fld     [ebx + Vertex.y]
        fmul    [averageLength]
        fstp    [ebx + Vertex.y]

        fld     [ebx + Vertex.z]
        fmul    [averageLength]
        fstp    [ebx + Vertex.z]

        ret
endp