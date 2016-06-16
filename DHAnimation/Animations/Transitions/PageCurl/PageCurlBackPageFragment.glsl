#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform sampler2D s_gradient;

in vec2 v_texCoords;
in vec2 v_gradientTexCoords;


layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    vec4 gradient = texture(s_gradient, v_gradientTexCoords);
    out_color = vec4(out_color.rgb * (1.f - gradient.a) + gradient.rgb, out_color.a);
}