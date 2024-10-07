struct Spline.Point
        pMainVertex     dd      ?
        pDirectionPrev  dd      ?
        pDirectionNext  dd      ?
        time            dd      ?
ends

struct Spline
        pointsCount     dd      ?
        points          dd      ?
        cycle           dd      ?
        time            dd      ?
ends