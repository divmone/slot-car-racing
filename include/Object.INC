struct Object
    mesh Mesh
    VAO  GLuint ?
    texture GLuint ?
    ;objFileName  dd ?
    ;texFileName  dd ?
ends

car Object 
fileName        db              "../models/carcar.obj",0
textPath        db              "../textures/carcar.bmp", 0

nissan Object 
fileNameN        db              "../models/nissan.obj",0
textPathN        db              "../textures/nissan.bmp", 0
      

