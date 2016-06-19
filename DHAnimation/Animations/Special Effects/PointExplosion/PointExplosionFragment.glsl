#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, gl_PointCoord.xy);
    if (out_color.a < 0.1) {
        discard;
    } else {
        out_color.a = 1.f - u_percent * u_percent * u_percent;
    }
}