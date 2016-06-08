#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in vec2 v_color;
in float v_lifeTime;
in float v_percent;
in mat4 v_rotationMatrix;

layout(location = 0) out vec4 out_color;

void main() {
    vec4 texColor = texture(s_tex, (v_rotationMatrix * vec4(gl_PointCoord, 0.f, 1.f)).xy);
    if (texColor.a < 0.1) {
        out_color = vec4(0.f);
    } else {
        out_color = vec4(v_color, 0.f, 1.f);
        float alpha = v_percent * 0.3 + 0.7;
        out_color.a = texColor.a * alpha;
        if (u_percent > 0.9) {
            out_color.rgb -= out_color.rgb * (u_percent - 0.9) / 0.1;
        }
        if (v_percent > 1.f) {
            out_color.a = 1.f - (v_percent - 1.f) / 0.2;
        }
    }
}