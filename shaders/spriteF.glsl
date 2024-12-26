#version 430 core

in vec2 tCoord; 
out vec4 color;

uniform sampler2D tex;

void main()
{
    color = vec4(texture(tex, tCoord).agb, texture(tex, tCoord).r);
}
