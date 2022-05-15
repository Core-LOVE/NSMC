#version 120
#include "shaders/logic.glsl"
uniform sampler2D iChannel0;

void main()
{	
	float s = sin(gl_TexCoord[0].y*3.14);
	vec2 uv = vec2(gl_TexCoord[0].x*(0.6+s*0.4) - s*0.2 + 0.2,gl_TexCoord[0].y*(0.8+s*0.2) - s*0.1 + 0.1);
	vec4 c = texture2D(iChannel0, uv);
	
	gl_FragColor = c*vec4(1 - s*0.25,1 - s*0.25,1 - s*0.25,1);
}