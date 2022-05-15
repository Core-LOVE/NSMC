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

	c.rgb = mix(c.rgb, mix(1.0 - 2.0 * (1.0 - c.rgb) * (1.0 - c2.rgb), 2.0 * c2.rgb * c.rgb, lt(max(c2.r,max(c2.b,c2.g)), 0.5)), mult);
	c.a = mix(c.a, iOpacity * c.a, mult);
	gl_FragColor = c;
}