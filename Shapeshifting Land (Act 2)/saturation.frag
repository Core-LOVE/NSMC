#version 120
uniform sampler2D iChannel0;
uniform vec3 rgb;
uniform float adjustment;
uniform float intensity;
uniform float iAdd;
uniform float iQuake;
uniform float iRandom;

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void main()
{
    vec2 uv = vec2(gl_TexCoord[0].x, gl_TexCoord[0].y + cos(iRandom*6.28)*0.01*iQuake);
	vec4 c = texture2D(iChannel0, uv);
	vec3 greyScale = czm_saturation(c.rgb, 0.25);


    gl_FragColor = c;
    gl_FragColor.rgb = greyScale*vec3(0.5*iAdd,0.9*iAdd,1*iAdd);
}