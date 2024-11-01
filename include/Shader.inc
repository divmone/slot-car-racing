program         dd              0

vertexShader    GLuint          0
vshaderFile      db             "../shaders/vertex.glsl", 0

fragmentShader  GLuint          0
fshaderFile      db             "../shaders/fragment.glsl", 0        

viewPosName     db              "viewPos", 0
viewPosLocation GLint           ?

lightPosName     db             "lightPos", 0
lightPosLocation GLint          ?

objectColorName     db          "objectColor", 0
objectColorLocation GLint       ?

lightColorName db               "lightColor", 0
lightColorLocation GLint        ?

modelName db                    "model", 0
modelLocation GLint             ?

MVPName db                      "MVP", 0
MVPLocation GLint               ?