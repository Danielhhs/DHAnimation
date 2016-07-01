#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_center;
uniform float u_wiperWidth;
uniform vec2 u_wiperRange;
uniform float u_wiperRadius;
uniform float u_percentInCycle;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

const vec2 c_y_axis = vec2(0.f, 1.f);
const float c_resolution = 2.f;

void main() {
    float d = distance(gl_FragCoord.xy, u_center * c_resolution);
    float angle = acos(dot(gl_FragCoord.xy - u_center * c_resolution, c_y_axis) / length(gl_FragCoord.xy - u_center * c_resolution));
    float currentAngle = u_wiperRange.x + (u_wiperRange.y - u_wiperRange.x) * u_percentInCycle;
    if (d > u_wiperRadius * c_resolution && d < u_wiperRadius * c_resolution + u_wiperWidth * c_resolution && angle < currentAngle) {
        discard;
    } else {
        out_color = texture(s_tex, v_texCoords);
    }
}