#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_columnWidth;
uniform float u_shredderPosition;

in vec2 v_texCoord;
in vec3 v_normal;
in vec2 v_position;
in vec2 v_pieceWidthRange;

layout(location = 0) out vec4 out_color;

#define shadowLength 15.0

void main() {
    float d = u_shredderPosition - v_position.y;
    vec4 color = texture(s_tex, v_texCoord);
    vec3 normal = normalize(v_normal);
    float alpha = 1.0;
    if (v_position.y <= u_shredderPosition) {
        float widthHalf = (v_pieceWidthRange.y - v_pieceWidthRange.x) / 2.0;
        float middle = widthHalf + v_pieceWidthRange.x;
        float a = -0.5 / widthHalf / widthHalf;
        float x = v_position.x - middle;
        alpha = a * x * x + 0.9;
    }
    if (d > 0.0 && d < shadowLength) {
        alpha = d / shadowLength;
    }
    out_color = vec4(color.rgb * alpha, color.a);
}