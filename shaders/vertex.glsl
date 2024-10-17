#version 430


layout (location = 0) in vec4 pos;
layout (location = 1) in vec3 color;

layout(location = 2) uniform float multiplier;
layout(location = 3) uniform float aX;
layout(location = 4) uniform float aY;
layout(location = 5) uniform float aZ;

out  vec4 colors;

void main()
{
        mat4 rotation = mat4(
        cos(aZ), 0.0, sin(aZ), 0.0,
        0.0,        1.0, 0.0,        0.0,
       -sin(aZ), 0.0, cos(aZ), 0.0,
        0.0,        0.0, 0.0,        1.0
    );

        vec3 rotatedPos = (rotation * vec4(pos.xyz, 1.0)).xyz;  // Вращаем позицию
        vec3 transformedPos = rotatedPos * multiplier + vec3(aX, aY, 0.0); 
        gl_Position = vec4(transformedPos, pos.w);
        colors = vec4(color, 1.0);
}     