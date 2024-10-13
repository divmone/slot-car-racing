#version 330 core

uniform float time;
out vec4 vertexColor;

void main()
{

    vertexColor = vec4(0.5f * time , 0.02f * time, 0.02f * time, 1.0f); 

}