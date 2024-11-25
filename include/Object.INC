struct quaternion
    x dd 0.0
    y dd 0.0
    z dd 0.0
    w dd 0.0
ends

struct Transform
    position Vector3
    rotation Vector3
    scale    Vector3
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
fileNameTr     db             "../models/track2.obj",0 
textPathTr        db             "../textures/images.bmp", 0 

R1 Object

musicPath  db "../audio/goida.wav",0