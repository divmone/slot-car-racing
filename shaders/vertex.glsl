#version 330

in vec4 pos;
in vec3 norm;

out vec3 normal;

void main()
{
        gl_Position = pos;
        normal = norm;
}