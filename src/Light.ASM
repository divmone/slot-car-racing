proc Light.Init
    invoke glGenFramebuffers, 1, depthMapFBO

    invoke glGenTextures, 1, depthMap
    invoke glBindTexture, GL_TEXTURE_2D, [depthMap]
    invoke glTexImage2D, GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, SHADOW_WIDTH, SHADOW_HEIGHT, 0, GL_DEPTH_COMPONENT, GL_FLOAT, 0
    invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
    invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT
    invoke glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT


    invoke glBindFramebuffer, GL_FRAMEBUFFER, [depthMapFBO]
        invoke glFramebufferTexture2D, GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, [depthMap], 0
        invoke glDrawBuffer, GL_NONE
        invoke glReadBuffer, GL_NONE
    invoke glBindFramebuffer, GL_FRAMEBUFFER, 0

    ret
endp