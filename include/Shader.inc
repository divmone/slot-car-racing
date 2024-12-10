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

modelName2D db                    "model2D", 0
modelLocation2D GLint             ?

projectionName db                    "projection2D", 0
projectionLocation GLint             ?

ambientName db "material.ambient", 0
ambientLocation GLint ?
diffuseName db "material.diffuse", 0
diffuseLocation GLint ?
specularName db "material.specular", 0
specularLocation GLint ?
shininessName db "material.shininess", 0
shininessLocation GLint ?

program2D         dd              0

vertexShader2D    GLuint          0
vshaderFile2D      db             "../shaders/vertex2D.glsl", 0

fragmentShader2D  GLuint          0
fshaderFile2D     db             "../shaders/fragment2D.glsl", 0        
