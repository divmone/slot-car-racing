proc Game.MainLoop
    stdcall Spline.GetPoint, cubeSpline, car.transform.position, [programTime] 
    stdcall Spline.GetRotation, cubeSpline, car.transform.position, [programTime]
    
    ret
endp