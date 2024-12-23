foneMusicCommand        db  'open "../audio/ost.mp3" type mpegvideo alias foneMusic', 0
    foneMusicPlay           db  'play foneMusic', 0
    foneMusicClose          db  'close foneMusic', 0
    foneMusicStatus         db  'status foneMusic mode', 0

setMusicVolume              db  'setaudio foneMusic volume to 100',0