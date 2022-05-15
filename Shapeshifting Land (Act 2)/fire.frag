#version 120
#include "shaders/logic.glsl"
uniform sampler2D iChannel0;

void main()
{	
	vec2 uv = vec2(gl_TexCoord[0].x,gl_TexCoord[0].y);
	vec4 c = texture2D( iChannel0, uv);
	
	gl_FragColor = c*vec4(3,0.75,0.75,1);
}