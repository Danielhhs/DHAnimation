#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in mat4 v_rotation;

layout(location = 0) out vec4 out_color;

void main() {
    vec2 texCoord = (v_rotation * vec4(gl_PointCoord, 0.f, 1.f)).xy;
    out_color = texture(s_tex, texCoord);
    if (out_color.a < 0.1)
    {
        discard;
    } else {
        out_color.a = (1.f - u_percent);
    }
}