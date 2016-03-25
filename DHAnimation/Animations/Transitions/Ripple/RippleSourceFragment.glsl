#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    vec2 pos = -1.f + 2.0 * gl_FragCoord.xy / u_resolution;
    float cLength = length(pos);
    
    vec2 uv = gl_FragCoord.xy/u_resolution.xy+(pos/cLength)*cos(cLength*18.0-u_time*10.0)*0.03;
    vec3 col = texture(s_tex,uv).xyz;
    
    out_color = vec4(col,1.f - u_percent);
}