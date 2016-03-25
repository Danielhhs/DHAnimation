#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in vec3 v_normal;

layout(location = 0) out vec4 out_color;

const vec3 c_light = normalize(vec3(0.f, 0.f, 1.f));

void main() {
    vec3 normal = normalize(v_normal);
    float alpha = dot(normal, c_light);
    vec4 color = texture(s_tex, v_texCoords);
    out_color = vec4(color.xyz * alpha, 1.);
}