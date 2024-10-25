#version 430

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 color;
layout (location = 2) in vec3 normal;

uniform mat4 MVP;
uniform mat4 model;

out vec3 Normal;
out vec3 FragPos;

void main()
{
    gl_Position = MVP * vec4(pos, 1.0f);
    FragPos = vec3(model * vec4(pos, 1.0f));
    Normal = normal;  
} 