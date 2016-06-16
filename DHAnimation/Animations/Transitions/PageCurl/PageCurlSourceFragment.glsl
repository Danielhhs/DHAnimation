#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in vec3 v_normal;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    vec3 normal = normalize(v_normal);
    out_color = vec4(out_color.rgb * normal.z, out_color.a);
}