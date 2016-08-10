#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in float v_percent;

layout(location = 0) out vec4 out_color;

void main() {
    vec4 textureColor = texture(s_tex, v_texCoords);
    if (textureColor.a < 0.1) {
        discard;
    } else {
        out_color = textureColor;
        out_color.a = 1.f - v_percent * v_percent;
    }
}