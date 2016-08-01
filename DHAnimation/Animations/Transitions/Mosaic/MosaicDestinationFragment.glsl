#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in vec3 v_normal;

layout(location = 0) out vec4 out_color;

const vec3 c_light = vec3(0.f, 0.f, 1.f);

void main() {
    vec4 tex_color = texture(s_tex, v_texCoords);
    out_color = vec4(tex_color.xyz * dot(c_light, normalize(v_normal)), 1.f);
}