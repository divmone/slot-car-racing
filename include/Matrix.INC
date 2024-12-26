struct Matrix4x4
        m11     dd      ?
        m12     dd      ?
        m13     dd      ?
        m14     dd      ?
        m21     dd      ?
        m22     dd      ?
        m23     dd      ?
        m24     dd      ?
        m31     dd      ?
        m32     dd      ?
        m33     dd      ?
        m34     dd      ?
        m41     dd      ?
        m42     dd      ?
        m43     dd      ?
        m44     dd      ?
ends

view1            Matrix4x4     1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0
view            Matrix4x4     1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0      
        model           Matrix4x4         


        scale           Matrix4x4          1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0

        turn            Matrix4x4          

        position        Matrix4x4          1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0

        positionN        Matrix4x4          1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0
        MVP             Matrix4x4

        PV              Matrix4x4

        projection      Matrix4x4  


        tempMatrix      Matrix4x4 
        tempMatrix2      Matrix4x4
        tempMatrix3      Matrix4x4
        tempMatrix4      Matrix4x4  

        model2D      Matrix4x4             1.0,0.0,0.0,1.0,\
                                           0.0,1.0,0.0,1.0,\
                                           0.0,0.0,1.0,1.0,\
                                           0.0,0.0,0.0,1.0

        projection2D Matrix4x4    1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0

        splineMatrix Matrix4x4              1.0, 0.0, 0.0, 0.0,\
                                            -3.0, 3.0, 0.0, 0.0,\
                                            3.0, -6.0, 3.0, 0.0,\
                                            -1.0, 3.0, -3.0, 1.0


        lightSpaceMatrix Matrix4x4 1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0
        lightProjection Matrix4x4 1.0,0.0,0.0,0.0,\
                                           0.0,1.0,0.0,0.0,\
                                           0.0,0.0,1.0,0.0,\
                                           0.0,0.0,0.0,1.0

        unitMatrix Matrix4x4            1.0,0.0,0.0,0.0,\
                                        0.0,1.0,0.0,0.0,\
                                        0.0,0.0,1.0,0.0,\
                                        0.0,0.0,0.0,1.0
        pMatrix Matrix4x4

        currentMatrix Matrix4x4
