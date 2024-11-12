#version 430

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 textCoord;

uniform mat4 MVP;
uniform mat4 model;

out vec3 Normal;
out vec3 FragPos;
out vec2 tCoord;

void main()
{
    tCoord = textCoord; 
    gl_Position = MVP * vec4(pos, 1.0f);
    FragPos = vec3(model * vec4(pos, 1.0f));
    Normal = normal;  
} 