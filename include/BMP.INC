struct BMPHeader  
        bfType        dw          ?
        bfSize        dd          ?
        bfReserved1   dw          ?
        bfReserved2   dw          ?
        bfOffBits     dd          ?
ends    

struct DIBHeader
        biSize         dd         ?
        biWidth        dd         ?
        biHeight       dd         ?
        biPlanes       dw         ?
        biBitCount     dw         ?
        biCompression   dd        ?
        biSizeImage     dd        ?
        biXPelsPerMeter  dd       ?
        biYPelsPerMeter     dd    ?
        biClrUsed       dd        ?
        biClrImportant      dd    ?
ends

struct BMP
        bfType        dw          ?
        bfSize        dd          ?
        bfReserved1   dw          ?
        bfReserved2   dw          ?
        bfOffBits     dd          ? 
        biSize         dd         ?
        biWidth        dd         ?
        biHeight       dd         ?
        biPlanes       dw         ?
        biBitCount     dw         ?
        biCompression   dd        ?
        biSizeImage     dd        ?
        biXPelsPerMeter  dd       ?
        biYPelsPerMeter     dd    ?
        biClrUsed       dd        ?
        biClrImportant      dd    ?
        pArray        dd          ?
ends