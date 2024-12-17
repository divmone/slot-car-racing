#version 430 core

in vec2 tCoord; 
out vec4 color;

uniform sampler2D tex;

void main()
{
    color = texture(tex, tCoord);
}
