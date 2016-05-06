#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;
uniform float u_event;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    vec4 texture_color = texture(s_tex, v_texCoords);
    
    if (texture_color.a < 0.1) {
        discard;
    } else {
        out_color = vec4(texture_color.rgb, percent);
    }
}