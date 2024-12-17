struct quaternion
    x dd 0.0
    y dd 0.0
    z dd 0.0
    w dd 0.0
ends

struct Transform
    position Vector3 0.0, 0.0, 0.0
    rotation Vector3 0.0, 0.0, 0.0
    scale    Vector3 1.0, 1.0, 1.0
ends

struct Material
    ambient Vector3 0.9472,	0.9995,	0.9745	
    diffuse Vector3 0.9,	0.9,	0.9
    specular Vector3 0.9,	0.9,	0.9	
    shininess GLfloat  0.9
ends
  
struct Object
    mesh Mesh
    transform Transform 
    VAO  GLuint ?
    texture GLuint ?
    q quaternion
    matrix Matrix4x4 
    rmatrix Matrix4x4 
    ;objFileName  dd ?
    ;texFileName  dd ?
    speed dd 0.0
    mass dd 6.0
    mu dd 0.8
    acceleration dd 0.0
    material Material
    positionOnSpline dd 0.0 
    tempAngle dd 0.0
    speed2 dd 20.0
    isCrashed dd 0
    isFreeFall dd 0
    astep dd 20.0
    useInstancing dd 0
    lapCount dd 0
ends

car Object 0,0,0,0
fileName        db              "../models/gtr.obj",0
textPath        db              "../textures/gtrred.bmp", 0

car2 Object 0,0,0,0
fileName2        db              "../models/gtr.obj",0
textPath2        db              "../textures/gt-r.bmp", 0


nissan Object 
fileNameN        db              "../models/nissan.obj",0
textPathN        db              "../textures/nissan.bmp", 0

table Object 
fileNameT        db               "../models/desk.obj",0 
textPathT        db              "../textures/8027.bmp", 0

sphere Object
fileNameS        db             "../models/sphere.obj",0 
textPathS        db             "../textures/8027.bmp", 0

lamp Object
fileNameL        db             "../models/lamp.obj",0 
textPathL        db             "../textures/light.bmp", 0

pens Object
fileNameP        db             "../models/pens.obj",0 
textPathP        db             "../textures/light.bmp", 0

books Object
fileNameB        db             "../models/books.obj",0 
textPathB        db             "../textures/light.bmp", 0

track Object
fileNameTr     db             "../models/room.obj",0 
textPathTr        db             "../textures/images.bmp", 0 

road Object
fileNameR db  "../models/road.obj",0 
textPathR        db    "../textures/road.bmp", 0 

arch Object
fileNameA db  "../models/ballooons.obj",0 
textPathA        db    "../textures/ui.bmp", 0 


R1 Object
r1Message db "123", 0 
R2 Object
R3 Object



musicPath  db "../audio/goida.wav",0


testq1 quaternion 1.0, 2.0, 3.0, 4.0
testq2 quaternion 5.0, 6.0, 7.0, 8.0
testq3 quaternion

t1 Vector4
t2 Vector4
t3 Vector4
t4 Vector4

testVector Vector3 1.0, 2.0, 3.0

testObj Object

positionOnSpline2 dd 0.0
positionOnSpline dd 0.0
speed dd 0.0
speed2 dd 20.0
acceleration2 dd 0.0
acceleration dd 0.0
friction dd 0.01
maxForce dd 1.0
maxForce2 dd 0.5
mass dd 1.0

carAmbient Vector3 0.2472,	0.1995,	0.0745	
carDiffuse Vector3    0.75164,	0.60648,	0.22648
carSpecular Vector3     0.628281,	0.555802,	0.366065
carShinine   dd  0.4