#version 300 es

precision highp float;

uniform float u_shredderPosition;
uniform sampler2D s_tex;

in vec2 v_texCoords;
in vec2 v_yRange;
in vec2 v_position;
layout(location = 0) out vec4 out_color;
void main() {
    if (v_position.y > u_shredderPosition) {
        discard;
    } else {
        out_color = texture(s_tex, v_texCoords);
    }
}