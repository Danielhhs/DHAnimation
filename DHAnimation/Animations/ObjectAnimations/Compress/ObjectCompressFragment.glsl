#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_showRange;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    if (gl_FragCoord.y > u_showRange.x && gl_FragCoord.y < u_showRange.y) {
        out_color = texture(s_tex, v_texCoords);
    } else if (gl_FragCoord.y == u_showRange.x || gl_FragCoord.y == u_showRange.y) {
        out_color = vec4(1.f);
    } else {
        out_color = vec4(0.f);
    }
    
}