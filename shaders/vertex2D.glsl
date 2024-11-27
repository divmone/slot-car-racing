#version 430

layout (location = 0) in vec2 pos;
layout (location = 1) in vec2 textCoord;

uniform mat4 model2D;
uniform mat4 projection2D;
out vec2 tCoord;

void main()
{
    gl_Position = projection2D * model2D * vec4(pos, 0.0, 1.0);
    tCoord = textCoord; 
} 