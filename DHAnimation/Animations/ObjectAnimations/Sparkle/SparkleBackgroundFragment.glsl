#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_targetXPositionRange;
uniform float u_percent;
uniform float u_event;
uniform float u_direction;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, v_texCoords);
    float range = u_targetXPositionRange.y - u_targetXPositionRange.x;
    
    if (u_event == 0.f) {
        if (u_direction == 0.f) {
            if (gl_FragCoord.x > u_targetXPositionRange.x + range * u_percent) {
                discard;
            }
        } else {
            if (gl_FragCoord.x < u_targetXPositionRange.x + range * (1.f - u_percent)) {
                discard;
            }
        }
    } else {
        if (u_direction == 0.f) {
            if (gl_FragCoord.x < u_targetXPositionRange.x + range * u_percent) {
                discard;
            }
        } else {
            if (gl_FragCoord.x > u_targetXPositionRange.x + range * (1.f - u_percent)) {
                discard;
            }
        }
    }
}