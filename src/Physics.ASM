proc ThreadWrapper uses esi, args
        mov esi, [args]
        push dword[esi + 8]
        push dword[esi + 4]
        push dword[esi]
        stdcall Physics.Update
        xor eax, eax

        ret
endp

proc Physics.Update uses esi ebx, deltaTime, spline, objPtr
        locals
                accelerationV dd ?
                frictionV dd ?
                ten dd 100.0
                radius dd ?
                mu dd 0.00001
                v dd 0.0
                vmax dd ?          
                deceleration dd 8.0
                ;testSpeed dd ?
                angle dd 0.0
                point Vector3 
                toDegree dd 180.0
                step2 dd 45.0
                positionOnSpline dd 0.0
                frictionVector Vector3 
                accelerationVector Vector3
                
        endl

        lea ebx, [frictionVector]
        mov esi, [objPtr]
        mov eax, [esi + Object.positionOnSpline]
        mov [positionOnSpline], eax

        cmp [esi + Object.isCrashed], 1
        jne @f
        ret
@@:     
        cmp [esi + Object.isFreeFall], 1
        je .skip

        fld dword[esi + Object.acceleration]
        fmul [deltaTime]
        fadd dword[esi + Object.speed]
        fstp dword[esi + Object.speed]

        fld dword[esi + Object.speed]
        fmul [friction]
        fsubr dword[esi + Object.speed]
        fstp dword[esi + Object.speed]

        fld dword[esi + Object.speed]
        fmul [deltaTime]
        fadd [positionOnSpline]
        fstp [positionOnSpline]

        lea eax, [accelerationVector]
        stdcall Spline.GetAcceleration, [spline], eax, [positionOnSpline]
        stdcall Spline.GetDerivative, [spline], ebx, [positionOnSpline]
       
       ; mov [accelerationVector.y], 0.0
       ; mov [ebx.y], 0.0
        lea eax, [accelerationVector]
        stdcall Vector3.Length, eax
        mov [accelerationV], eax
        
        stdcall Vector3.Length, ebx
        mov [frictionV], eax

        fld [frictionV]
        fmul st0, st0
        fsqrt
        fstp [radius]
        fld [radius]
        fmul [radius]
        fmul [radius]
        fdiv [accelerationV]
        fmul [mu]
        fmul [gravity]
        fsqrt
        fstp [vmax]

        ; fld [v]
        ; fcomip st0, st1
        ; fstp [v]
        ; ja .skip

      
        fld [esi + Object.acceleration]
        fmul [deltaTime]
        fadd [esi + Object.speed]
        fstp [v]

        fld [vmax]
        fld [v]
        fcomip st0, st1
        fstp st0
        ja .skip

        mov eax, [esi + Object.tempAngle]
        mov [tempAngle], eax
        

        lea eax, [esi + Object.transform.position]

        stdcall Spline.GetPoint, [spline], eax, [positionOnSpline]
        stdcall Spline.GetRotation, [spline], esi, [positionOnSpline]                                                                               
  
        ;stdcall FloatToStr, [tempAngle3]
        ;stdcall Log, eax, ecx
        ;stdcall Log, nMessage, 1 
        ;mov eax, [positionOnSpline]
        ;mov [tempPositionOnSpline], eax
        mov eax, [positionOnSpline]
        mov [esi + Object.positionOnSpline], eax
        ret
.skip:  

        fldz
        fld [esi + Object.speed2]
        fcomip st0, st1
        fstp st0
        ja @F
        mov [deceleration], 0.0

        mov [esi + Object.isCrashed], 1

@@:
        fld [deceleration]
        fmul [deltaTime]
        fsubr [esi + Object.speed2]
        fstp [esi + Object.speed2]

.ll:
     
        fld1
        fchs
        fmul [deltaTime]
        fmul [esi + Object.speed2]
        fstp [v]
        lea eax, [esi + Object.matrix.m31]
        stdcall Vector3.Copy, ebx, eax
        stdcall Vector3.Normalize, ebx
        stdcall Vector3.CrossValue, ebx,[v]
       
        
        ; lea eax, [point]
        ; stdcall Vector3.Normalize, eax

        fld dword[esi + Object.tempAngle]
        fld [tempAngle]
        fcomip st0, st1
        jb @F

        fadd dword[esi + Object.astep]
        fstp [tempAngle4]
        jmp .l1
@@:
        fsub dword[esi + Object.astep]
        fstp [tempAngle4]
 .l1:       
        stdcall Quaternion.CreateFromAxisAngle, [objPtr], 0.0, 1.0, 0.0, [tempAngle4]
        
        ;stdcall Quaternion.CreateFromAxisAngle, testObj, 0.0, 0.0, 1.0, [tempAngle4]
        ;stdcall Quaternion.Multiply, testObj.q, car.q, car.q
 
        lea eax, [esi + Object.transform.position]
        stdcall Vector3.Add, eax,  ebx
        mov [esi + Object.isFreeFall], 1
        ret
endp

proc Physics.CalculateFriction uses esi, objPtr

        locals
                friction dd ?
        endl
        mov esi, [objPtr]
        fld dword[esi + Object.mass]
        fmul [gravity]
        fmul dword[esi + Object.mu]
        fstp [friction]
        mov eax, [friction]
    
        ret
endp

proc Physics.CalculateMU uses esi, objPtr
    locals
                temp dd 0.8
        endl
        mov esi, [objPtr]
        fld dword[esi + Object.speed]
        fmul [temp]
        fstp [esi + Object.mu]

        ret
endp