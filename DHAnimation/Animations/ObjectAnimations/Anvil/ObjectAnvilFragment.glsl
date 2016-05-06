#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform sampler2D s_texCube;
uniform float u_time;
uniform vec2 u_resolution;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    if (out_color.a < 0.1) {
        discard;
    }
}