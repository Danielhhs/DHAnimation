#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    vec4 texture_color = texture(s_tex, v_texCoords);
    out_color = vec4(texture_color.rgb * (0.5 + u_percent * 0.5), 1.f);
}