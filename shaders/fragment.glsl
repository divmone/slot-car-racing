#version 430 core
struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
}; 
  
out vec4 color;

in vec3 FragPos;  
in vec3 Normal; 
in vec2 tCoord; 

uniform Material material;
uniform vec3 lightPos; 
uniform vec3 viewPos;
uniform vec3 lightColor;
uniform vec3 objectColor;
uniform sampler2D tex;

void main()
{
    vec3 ambient = lightColor * material.ambient;
  	
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = lightColor * (diff * material.diffuse);

   vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = lightColor * (spec * material.specular);  

    vec3 result = (ambient + diffuse + specular) * vec3(texture(tex, tCoord).rgb);
    color = vec4(result, 1.0f);
    //color = texture(tex, tCoord);
}