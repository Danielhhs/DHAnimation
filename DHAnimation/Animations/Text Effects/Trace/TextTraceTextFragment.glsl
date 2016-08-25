#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in float v_percent;

layout(location = 0) out vec4 out_color;

void main() {
//    out_color = texture(s_tex, v_texCoords);
//    out_color.a = v_percent;
    out_color = vec4(0.f, 0.f, 1.f, 1.f);
}