#version 300 es

precision highp float;

uniform sampler2D s_tex;

in float v_percent;
in vec4 v_color;

layout(location = 0) out vec4 out_color;

const vec3 c_white_color = vec3(1.f);

void main() {
    out_color = texture(s_tex, gl_PointCoord.xy);
    if (out_color.r < 0.1 && out_color.g < 0.1 && out_color.b < 0.1) {
        discard;
    } else {
        if (v_percent < 0.5) {
            float percent = v_percent / 0.5;
            out_color.rgb = c_white_color + (v_color.rgb - c_white_color) * percent;
        } else {
            out_color.rgb = v_color.rgb;
        }
        out_color.a = 1.f - v_percent;
    }
}