#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_position;
uniform vec2 u_direction;
uniform float u_radius;

in vec2 v_texCoords;
in vec2 v_position;

layout(location = 0) out vec4 out_color;

void main() {
    vec2 dir = vec2(u_direction.y, -u_direction.x);
    vec2 v = v_position - u_position;
    float d = dot(v, dir);
    float l = 0.4 + 0.6 * smoothstep(0.5, 0.8, d / (2.f * u_radius));
    out_color = texture(s_tex, v_texCoords);
    out_color = vec4(out_color.rgb * l, 1.f);
}