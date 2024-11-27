#version 430 core

in vec2 tCoord; 
out vec4 color;

uniform sampler2D tex;

void main()
{
    //color = vec4(0.0, 1.0, 0.0, 1.0);
    color = texture(tex, tCoord);
}
