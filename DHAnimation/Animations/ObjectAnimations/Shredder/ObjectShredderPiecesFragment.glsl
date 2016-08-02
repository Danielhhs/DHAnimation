#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_columnWidth;
uniform float u_screenScale;
uniform float u_shredderPosition;

in vec2 v_texCoords;
in float v_columnCenter;
in float v_shredderedZOffset;

layout(location = 0) out vec4 out_color;

void main() {
    if (v_shredderedZOffset == 0.f || gl_FragCoord.y > u_shredderPosition * u_screenScale) {
        out_color = texture(s_tex, v_texCoords);
    } else {
        float d = (gl_FragCoord.x - v_columnCenter * u_screenScale) / (u_columnWidth * u_screenScale / 2.f);
        if (d < 0.f) {
            d *= -1.f;
        }
        float a = (1.f - d * d) * 0.618 + 0.382;
        vec4 tex_color = texture(s_tex, v_texCoords);
        out_color = vec4(tex_color.rgb * a, 1.f);
    }
}