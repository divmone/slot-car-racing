proc Texture.Init
    locals
        
    endl

    ;invoke glGenTextures, 1, texture
    ;invoke glBindTexture, GL_TEXTURE_2D, [texture]
    ;invoke glTexImage2D, GL_TEXTURE_2D, 0, GL_RGBA, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE, Texture 

    ;invoke glBindTexture, GL_TEXTURE_2D, 0
    ;invoke glGenerateMipmap, GL_TEXTURE_2D

    stdcall BMP.LoadFromFile, textPath

    

    ret
endp