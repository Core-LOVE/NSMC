#version 120
uniform sampler2D iChannel0;
uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float time;

void main()
{
    vec2 p = vec2(1.0, 1.0) - (gl_FragCoord.xy / (iResolution.xy/2));
   
    float horizon =(iMouse.y/iResolution.y)-0.1;
    float fov = 0.175; 

    float px = p.x*0.08;
    float py = p.y - horizon - fov; 
    float pz = p.y - horizon;
     
    
     vec2 uv =  vec2(px / pz, py / pz);
     vec2 dir =  vec2(0,1*time);

         gl_FragColor =  texture2D(iChannel0,(uv*(-0.75)) + 0.5);
    
        if(abs(uv.y)>=0.65) // sky
         gl_FragColor = vec4(0,0,0,0);
}