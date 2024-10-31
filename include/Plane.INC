PLANE_TRIANGLES_COUNT   =       2
PLANE_VERTICES_COUNT    =       PLANE_TRIANGLES_COUNT * 3
PLANE_INDICES_COUNT    =       PLANE_TRIANGLES_COUNT * 3

planeVertices GLfloat -10.0, -1.0, -10.0,\
                      -10.0, -1.0,  10.0,\
                       10.0, -1.0,  10.0,\
                      -10.0, -1.0, -10.0,\
                       10.0, -1.0,  10.0,\
                       10.0, -1.0, -10.0


cubeTextCoord GLfloat 0.0 , 0.0 ,  0.0, 10.0,  10.0, 10.0, 0.0, 0.0, 10.0, 10.0, 10.0, 0.0