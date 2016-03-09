#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    vec4 texture_color = texture(s_tex, v_texCoords);
    float alpha = 0.3 + 0.7 * u_percent;
    out_color = vec4(texture_color.rgb * alpha, 1.);
}