#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_targetXPositionRange;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    float range = u_targetXPositionRange.y - u_targetXPositionRange.x;
    if (gl_FragCoord.x > u_targetXPositionRange.x + range * u_percent) {
        discard;
    }
}