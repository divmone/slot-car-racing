proc Physics.Update uses esi, deltaTime, spline, objPtr
        locals
                accelerationV dd ?
                frictionV dd ?
                ten dd 100.0
                radius dd ?
                vmax dd ?
                mu dd 0.8

        endl

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
        fstp [positionOnSpline]

        stdcall Spline.GetAcceleration, [spline], accelerationVector, [positionOnSpline]
        stdcall Spline.GetDerivative, [spline], frictionVector, [positionOnSpline]
        
        stdcall Vector3.Cross, frictionVector, accelerationVector, tempPhysicV
        stdcall Vector3.Length, tempPhysicV
        mov [accelerationV], eax
        
        stdcall Vector3.Length, frictionVector
        mov [frictionV], eax
        
        fld [frictionV]
        fmul [frictionV]
        fmul [frictionV]
        fdiv [accelerationV]

        fmul [mu]
        fmul [gravity]
        fsqrt
        fld dword[esi + Object.speed]
        fcomip st0, st1
        fstp st0
        ja .skip

        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [positionOnSpline]
        stdcall Spline.GetRotation, cubeSpline, car, [positionOnSpline]                                                                               
        ret
.skip:  
        stdcall Vector3.Add, car.transform.position,  upperVector
        mov [PHYSICS_MODE], 1
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