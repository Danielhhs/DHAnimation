#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

const vec3 white_color = vec3(1.f, 1.f, 1.f);

void main() {
    out_color = texture(s_tex, v_texCoords);
    out_color.rgb = out_color.rgb + (white_color - out_color.rgb) * u_percent * u_percent;
    if (u_percent >= 1.f) {
        discard;
    }
}