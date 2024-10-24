#version 430


layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 color;


layout(location = 2) uniform mat4 MVP;

out  vec4 colors;

void main()
{

    gl_Position = MVP * vec4(pos, 1.0);

    colors = vec4(color, 1.0);
}
