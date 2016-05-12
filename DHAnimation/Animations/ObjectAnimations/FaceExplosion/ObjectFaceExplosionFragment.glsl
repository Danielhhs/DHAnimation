#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    if (u_percent >= 1.f) {
        discard;
    }
}