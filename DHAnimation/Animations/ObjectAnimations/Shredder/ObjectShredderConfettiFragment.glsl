#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in float v_percent;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    out_color.a = 1.f - v_percent;
}