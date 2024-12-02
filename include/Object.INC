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
ends

car Object 0,0,0,0
fileName        db              "../models/gtr1.obj",0
textPath        db              "../textures/gt-r.bmp", 0

nissan Object 
fileNameN        db              "../models/nissan.obj",0
textPathN        db              "../textures/nissan.bmp", 0

table Object 
fileNameT        db               "../models/desk.obj",0 
textPathT        db              "../textures/8027.bmp", 0

sphere Object
fileNameS        db             "../models/sphere.obj",0 
textPathS        db             "../textures/light.bmp", 0

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

R1 Object
r1Message db "packed", 0 
R2 Object
R3 Object


buttonTexture       db             "../textures/consolas.bmp", 0 

textCoords    dd      0.0, 1.0,  1.0, 1.0,  1.0, 0.0, 0.0, 0.0 

musicPath  db "../audio/goida.wav",0


testq1 quaternion 1.0, 2.0, 3.0, 4.0
testq2 quaternion 5.0, 6.0, 7.0, 8.0
testq3 quaternion

t1 Vector3
t2 Vector3
t3 Vector3
t4 Vector3

testObj Object