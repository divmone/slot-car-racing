accelerationVector Vector3 ?
frictionVector Vector3 ?
tempPhysicV Vector3 ?
gravity dd 9.81
PHYSICS_MODE dd 0

unitPhVector4 Vector4 0.0, 1.0, 0.0, 0.01 

struct threadArgs 
        deltaTime dd ?
        spline    dd ?
        car       dd ?
ends

arg threadArgs 0.7, cubeSpline, car