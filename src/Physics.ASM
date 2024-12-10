proc Physics.Update uses esi, deltaTime, spline, objPtr
        locals
                accelerationV dd ?
                frictionV dd ?
                ten dd 100.0
                radius dd ?
                vmax dd ?
                mu dd 0.00001
                str1 dd ?
                v dd 0.0
                vmax dd ?          
                deceleration dd 8.0
                testSpeed dd ?
                angle dd 0.0
                point Vector3 
                toDegree dd 180.0
                step2 dd 45.0

        endl

        cmp [START_CRASH], 1
        jne @f
        ret
@@:     
        cmp [PHYSICS_MODE], 1
        je .skip

        mov esi, [objPtr]

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

   
        
        stdcall Spline.GetAcceleration, [spline], accelerationVector, [positionOnSpline]
        stdcall Spline.GetDerivative, [spline], frictionVector, [positionOnSpline]
       
       ; mov [accelerationVector.y], 0.0
       ; mov [frictionVector.y], 0.0

        stdcall Vector3.Length, accelerationVector
        mov [accelerationV], eax
        
        stdcall Vector3.Length, frictionVector
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

       
    
     
        mov eax, [tempAngle3]
        mov [tempAngle], eax
        
        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [positionOnSpline]
        stdcall Spline.GetRotation, cubeSpline, car, [positionOnSpline]                                                                               
        mov eax, [tempAngle2]
        mov [tempAngle3], eax
        
        ;stdcall FloatToStr, [tempAngle3]
        ;stdcall Log, eax, ecx
        ;stdcall Log, nMessage, 1 
        ;mov eax, [positionOnSpline]
        ;mov [tempPositionOnSpline], eax
        ret
.skip:  

        fldz
        fld [speed2]
        fcomip st0, st1
        fstp st0
        ja @F
        mov [deceleration], 0.0
        mov [START_CRASH], 1

@@:
        fld [deceleration]
        fmul [deltaTime]
        fsubr [speed2]
        fstp [speed2]

.ll:
        ;memcpy car.transform.position, frictionVector, 12
        stdcall Vector3.Copy, frictionVector, car.matrix.m31
        stdcall Vector3.CrossValue, frictionVector, -1.0
        stdcall Vector3.Normalize, frictionVector
        stdcall Vector3.CrossValue, frictionVector, [deltaTime]
        stdcall Vector3.CrossValue, frictionVector, [speed2]
        
        ; lea eax, [point]
        ; stdcall Vector3.Normalize, eax
     
        
        
       
        fld [tempAngle3]
        fld [tempAngle]
        fcomip st0, st1
        jb @F

        fadd [astep]
        fstp [tempAngle4]
        jmp .l1
@@:
        fsub [astep]
        fstp [tempAngle4]
 .l1:       
        stdcall Quaternion.CreateFromAxisAngle, [objPtr], 0.0, 1.0, 0.0, [tempAngle4]
        
        ;stdcall Quaternion.CreateFromAxisAngle, testObj, 0.0, 0.0, 1.0, [tempAngle4]
        ;stdcall Quaternion.Multiply, testObj.q, car.q, car.q
        
        stdcall Vector3.Add, car.transform.position,  frictionVector
     
        mov [PHYSICS_MODE], 1
        ret
       
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