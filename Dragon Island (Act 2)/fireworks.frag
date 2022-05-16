// Simple Fireworks - by moranzcw - 2021
// Email: moranzcw@gmail.com
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

uniform sampler2D iChannel0;
uniform float iTime;
uniform vec2 iResolution = vec2(800, 600);

vec3 hsl2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0);
  return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}

float random (vec2 p) {
    return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453123);
}

vec4 firework(vec2 p, float n) {

    float dur = 3.; 
    float id = floor(iTime/dur-n) + n*8.;
    float t = smoothstep(0., 1., fract(iTime/dur-n));
    float t1 = max(0.0, 0.75 - t); 
    float t2 = max(0.0, t - 0.75); 
    p.y += t1 / 2; 
    p.y -= random(vec2(n*35.+id, n*45.+id))*0.3; 

    p.x += n - 0.5 + mix(0., sin(id)*0.4, t1);
    
    vec4 c;
    if ( dot(p,p) > 0.002 + t2 *0.1 ) 
        return c; 
    vec3 rgb = hsl2rgb(vec3(id*0.3, .8, .7)); 
    for (float i = 0.; i < 77.; i += 1.) {

        float angle = i + t*sin(i*4434.);
        float dist = 0.15 + 0.2 * random(vec2(i*351. + id, i*135. + id)); 

        vec2 pt = p + vec2(dist*sin(angle), dist*cos(angle)); 
        pt = mix(p, pt, t2); 

        float r = .03 * (1. - t) * t2 +
                  .002*t*t*(1. - max(.0, t - .9)*10.); 

        float d = 1. - smoothstep(sqrt(dot(pt, pt)), .0, r); 
        c += vec4(rgb, 1.) * d;
    }
    return c;
}

void main()
{
  vec2 uv = gl_TexCoord[0].xy;
  uv.x *= iResolution.x/iResolution.y; 
  for (float n = 0.; n < 6.; n += 1.) 
      gl_FragColor += firework(uv, n/6.) * 0.1;
	  gl_FragColor = clamp(gl_FragColor, 0, 0.25);
}