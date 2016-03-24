#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform mat4 u_modelViewMatrix;

in vec2 v_texCoords;
in vec3 v_normal;

layout(location = 0) out vec4 out_color;

const vec3 c_light = vec3(0.f, 0.f, 1.f);

void main() {
    vec4 texture_color = texture(s_tex, v_texCoords);
    vec3 normal = normalize(v_normal);
    vec3 transformedLightPosition = (u_modelViewMatrix * vec4(c_light, 1.f)).xyz;
    float alpha = dot(transformedLightPosition, normal);
    out_color = vec4(texture_color.rgb * alpha, 1.f);
    out_color = texture_color;
}