#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = vec4(texture(s_tex, v_texCoords).xyz, 1.f - u_percent / 2.f);
}