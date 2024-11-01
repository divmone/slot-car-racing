struct Object
    mesh Mesh
    VAO  dd ?
     
    ;objFileName  dd ?
    ;texFileName  dd ?
ends

fileName        db              "..\models\skull.obj",0
textPath        db              "../textures/penger.bmp", 0
      

car Object 0;, fileName, textPath