#version 330 core
layout (location = 0) in vec3 position;

out vec3 FragPos;

void main()
{
    FragPos = vec3(0.3 * vec4(position, 1.0f));
}