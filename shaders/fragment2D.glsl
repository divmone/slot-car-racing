#version 430 core

in vec2 tCoord; 
out vec4 color;

uniform vec3 texColor;
uniform sampler2D tex;

void main()
{
    vec4 sampled = vec4(1.0, 1.0, 1.0, texture(tex, tCoord).r);
    color = vec4(texColor, 1.0) * sampled;
}
