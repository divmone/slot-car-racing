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
    ;objFileName  dd ?
    ;texFileName  dd ?
ends

car Object 
fileName        db              "../models/gtr.obj",0
textPath        db              "../textures/gt-r.bmp", 0

nissan Object 
fileNameN        db              "../models/nissan.obj",0
textPathN        db              "../textures/nissan.bmp", 0

table Object 
fileNameT        db               "../models/table.obj",0 
textPathT        db              "../textures/images.bmp", 0       

