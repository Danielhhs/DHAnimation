#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_offset;
uniform float u_time;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec4 a_color;
layout(location = 2) in vec2 a_offset;
layout(location = 3) in float a_startTime;
layout(location = 4) in float a_disappearTime;

out vec4 v_color;

void main() {
    vec4 position = a_position;
    position.xy += u_offset;
    position.xy += a_offset;
    gl_Position = u_mvpMatrix * position;
    if (u_time < a_startTime || u_time > a_disappearTime) {
        gl_PointSize = 0.f;
    } else {
        gl_PointSize = 2.f;
    }
    v_color = a_color;
}