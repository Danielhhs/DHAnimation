#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_shredderPosition;

in vec2 v_texCoord;
in vec3 v_normal;
in vec2 v_position;
layout(location = 0) out vec4 out_color;

#define shadowLength 10.0

void main() {
    float d = u_shredderPosition - v_position.y;
    float alpha = 1.0;
    if (d > 0.0 && d < shadowLength) {
        alpha = d / shadowLength;
    }
    vec4 color = texture(s_tex, v_texCoord);
    out_color = vec4(color.rgb * alpha,  color.a);
}