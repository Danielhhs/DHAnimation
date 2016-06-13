#version 300 es

precision highp float;

uniform sampler2D s_tex;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, gl_PointCoord.xy);
    if (out_color.r < 0.1 && out_color.g < 0.1 && out_color.b < 0.1) {
        discard;
    }
}