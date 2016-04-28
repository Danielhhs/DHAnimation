#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in mat4 v_rotation;

layout(location = 0) out vec4 out_color;

void main() {
    vec2 texCoord = (v_rotation * vec4(gl_PointCoord, 0.f, 1.f)).xy;
    out_color = texture(s_tex, texCoord);
    if (out_color.a < 0.1 || u_percent < 0.f)
    {
        discard;
    } else {
        out_color = vec4(1.f, 1.f, 1.f, 1.f - u_percent);
    }
}