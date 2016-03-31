#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

const float blurstep = 0.03;
void main() {
    vec4 color0 = texture(s_tex, vec2(v_texCoords.x - blurstep, v_texCoords.y - blurstep));
    vec4 color1 = texture(s_tex, vec2(v_texCoords.x + blurstep, v_texCoords.y - blurstep));
    vec4 color2 = texture(s_tex, vec2(v_texCoords.x - blurstep, v_texCoords.y + blurstep));
    vec4 color3 = texture(s_tex, vec2(v_texCoords.x + blurstep, v_texCoords.y + blurstep));
    out_color = (color0 + color1 + color2 + color3) / 4.f;
}