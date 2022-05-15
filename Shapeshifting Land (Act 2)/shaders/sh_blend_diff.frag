//Read from the main texture using the regular texutre coordinates, and blend it with the tint colour.
//This is regular glDraw behaviour and is the same as using no shader.

#version 120
#include "shaders/logic.glsl"
uniform sampler2D iChannel0;
uniform sampler2D iBackdrop;
uniform float iBlend;
uniform float iOpacity;

//Do your per-pixel shader logic here.
void main()
{
	vec4 c = texture2D(iChannel0, gl_TexCoord[0].xy);
	vec4 c2 = texture2D(iBackdrop, gl_TexCoord[0].xy);
	float mult = or(neq(c.r, c2.r), or(neq(c.g, c2.g), neq(c.b, c2.b)));

	c.rgb = mix(c.rgb, abs(c2.rgb - c.rgb), mult);
	c.a = mix(c.a, iOpacity * c.a, mult);
	gl_FragColor = c;
}