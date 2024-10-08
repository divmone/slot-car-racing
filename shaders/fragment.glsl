uniform float time;
uniform vec2 size;

void main(void)
{
	vec2 uv = gl_FragCoord.xy / size;
	float t = time / 300.0;
	float f = 1.0 ;
	vec3 col = vec3(0.0, 0.0, 0.5) * pow(f, 0.2);
	gl_FragColor = vec4(col, 1.0);
}