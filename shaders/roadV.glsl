#version 430

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 textCoord;
layout (location = 3) in mat4 instanceMatrix;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 lightSpaceMatrix;

out vec3 Normal;
out vec3 FragPos;
out vec2 tCoord;
out vec4 FragPosLightSpace;

void main()
{
    tCoord = textCoord; 
    gl_Position =  projection * view * instanceMatrix * vec4(pos, 1.0f);
    FragPos = vec3(instanceMatrix * vec4(pos, 1.0f));
    Normal = transpose(inverse(mat3(instanceMatrix))) * normal;
    FragPosLightSpace =  lightSpaceMatrix * vec4(FragPos, 1.0);
} 


