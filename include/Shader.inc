program         dd              0

vertexShader    GLuint          0
vshaderFile      db             "../shaders/vertex.glsl", 0

fragmentShader  GLuint          0
fshaderFile      db             "../shaders/fragment.glsl", 0        

viewPosName     db              "viewPos", 0
viewPosLocation GLint           ?
viewPosLocation2 GLint           ?

lightPosName     db             "lightPos", 0
lightPosLocation GLint          ?
lightPosLocation2 GLint          ?

objectColorName     db          "objectColor", 0
objectColorLocation GLint       ?

lightColorName db               "lightColor", 0
lightColorLocation GLint        ?

modelName db                    "model", 0
modelLocation GLint             ?

MVPName db                      "MVP", 0
MVPLocation GLint               ?

modelName2D db                    "model2D", 0
modelLocation2D GLint             ?
modelLocation2 GLint             ?
modelLocation3 GLint             ?

projectionName db                    "projection", 0
projectionLocation GLint             ?
projectionLocation2 GLint             ?

viewName db                    "view", 0
viewLocation GLint             ?
viewLocation2 GLint             ?

colorName db "texColor", 0
colorNameLocation GLint  ?


projectionName2D db                    "projection2D", 0
projectionLocation2D GLint             ?


texName db "tex", 0
texLocation GLint ?
texLocation2 GLint ?

depthMapName db "shadowMap", 0
depthMapLocation GLint ?
depthMapLocation1 GLint ?
depthMapLocation2 GLint ?

lightSpaceMatrixLocation GLint ?
lightSpaceMatrixLocation2 GLint ?
lightSpaceMatrixLocation3 GLint ?
lightSpaceMatrixName db "lightSpaceMatrix", 0

useInstancingLocation GLint ?
useInstancingName db "useInstancing", 0

program2D         dd              0

vertexShader2D    GLuint          0
vshaderFile2D      db             "../shaders/vertex2D.glsl", 0

fragmentShader2D  GLuint          0
fshaderFile2D     db             "../shaders/fragment2D.glsl", 0        


depthShader    dd   0
depthVShader   GLuint    0
depthVShaderFile    db   "../shaders/depthVShader.glsl", 0        

depthFShader   GLuint    0
depthFShaderFile    db   "../shaders/depthFShader.glsl", 0        

roadShader    dd   0
roadVShader   GLuint    0
roadVShaderFile    db   "../shaders/roadV.glsl", 0        

roadFShader   GLuint    0
roadFShaderFile    db   "../shaders/roadF.glsl", 0        

