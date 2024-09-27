proc Matrix.Projection uses edi,\
     aspect, fov, zNear, zFar

        locals
                matrix          Matrix4x4
                sine            dd              ?
                cotangent       dd              ?
                deltaZ          dd              ?
                radians         dd              ?
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        lea     edi, [matrix]

        fld     [fov]
        fld1
        fld1
        faddp
        fdivp
        fdiv    [radian]
        fstp    [radians]

        fld     [zFar]
        fsub    [zNear]
        fstp    [deltaZ]

        fld     [radians]
        fsin
        fstp    [sine]

        fld     [radians]
        fcos
        fdiv    [sine]
        fstp    [cotangent]

        fld     [cotangent]
        fdiv    [aspect]
        fstp    [edi + Matrix4x4.m11]

        fld     [cotangent]
        fstp    [edi + Matrix4x4.m22]

        fld     [zFar]
        fadd    [zNear]
        fdiv    [deltaZ]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fchs
        fstp    [edi + Matrix4x4.m34]

        fld1
        fld1
        faddp
        fchs
        fmul    [zNear]
        fmul    [zFar]
        fdiv    [deltaZ]
        fstp    [edi + Matrix4x4.m43]

        invoke  glMultMatrixf, edi

        ret
endp
; координаты камеры
; точка куда смотрит
; вектор направенный вверх

proc Matrix.LookAt uses esi edi ebx,\
     camera, target, up

        locals
                temp    dd              ?
                matrix  Matrix4x4
                forw    Vector3
                side    Vector3
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [forw.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [forw.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [forw.z]

        lea     eax, [forw]
        stdcall Vector3.Normalize, eax

        lea     eax, [forw]
        lea     ecx, [side]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [side]
        stdcall Vector3.Normalize, eax

        lea     eax, [side]
        lea     ecx, [forw]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [side]
        lea     edi, [matrix]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m11]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m21]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m31]

        fld     [ebx + Vector3.x]
        fstp    [edi + Matrix4x4.m12]
        fld     [ebx + Vector3.y]
        fstp    [edi + Matrix4x4.m22]
        fld     [ebx + Vector3.z]
        fstp    [edi + Matrix4x4.m32]

        lea     esi, [forw]
        fld     [esi + Vector3.x]
        fchs
        fstp    [edi + Matrix4x4.m13]
        fld     [esi + Vector3.y]
        fchs
        fstp    [edi + Matrix4x4.m23]
        fld     [esi + Vector3.z]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fstp    [edi + Matrix4x4.m44]

        invoke  glMultMatrixf, edi

        mov     esi, [camera]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.y]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef

        ret
endp

 ;float zAxis = normalize(eye - target)
 ;float xAxis = normalize(up * zAxis)
 ;float yAxis = up

proc Matrix.GetAxis  uses esi edi ebx,\
     camera, target, up, xAx, yAx, zAx

         locals
                temp    dd              ?
                matrix  Matrix4x4
                forw    Vector3
                side    Vector3
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [forw.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [forw.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [forw.z]

        lea     eax, [forw]
        stdcall Vector3.Normalize, eax
        lea     eax, [forw]
        lea ecx, [zAx]
        stdcall Vector3.Copy, eax, ecx

        lea     eax, [forw]
        lea     ecx, [side]
        stdcall Vector3.Cross, eax, ebx, ecx


        lea     eax, [side]
        stdcall Vector3.Normalize, eax
           lea     eax, [forw]
        lea ecx, [xAx]
        stdcall Vector3.Copy, eax, ecx
        lea     eax, [up]
        lea ecx, [yAx]
        stdcall Vector3.Copy, eax, ecx



        ret

endp
