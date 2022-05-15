#version 120
uniform sampler2D iChannel0;
uniform vec2 delta;
uniform vec2 resolution;
uniform float lenght;
uniform float time;
uniform float intensity;

void main()
{
	float s = sin(gl_TexCoord[0].y*(256*lenght) + time);
    vec2 uv = vec2(gl_TexCoord[0].x*((1-intensity)+s*intensity) - s*(intensity/2) + (intensity/2),gl_TexCoord[0].y);

	vec2 value = delta;

	vec4 c1 = texture2D(iChannel0, uv - value / resolution.x );
	vec4 c2 = texture2D(iChannel0, uv);
	vec4 c3 = texture2D(iChannel0, uv + value / resolution.y );
	
	gl_FragColor = vec4(c1.r, c2.g, c3.b, c1.a + c2.a + c3.b );

}