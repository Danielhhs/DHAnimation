#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
//    out_color = vec4(1.f, 0.f, 0.f, 1.f);
}