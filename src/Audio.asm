proc Audio.FoneMusicOn

     invoke mciSendStringA, foneMusicCommand, 0, 0, 0
     invoke mciSendStringA, setMusicVolume, 0, 0, 0
     invoke mciSendStringA, foneMusicPlay, 0, 0, 0
 .l:
     jmp .l
    ret
endp
