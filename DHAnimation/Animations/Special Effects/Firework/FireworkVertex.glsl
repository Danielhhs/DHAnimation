#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec3 u_emissionPosition;
uniform float u_time;
uniform float u_duration;
uniform float u_gravity;

layout(location = 0) in vec3 a_position;
layout(location = 1) in float a_appearTime;
layout(location = 2) in float a_lifeTime;

out float v_percent;

void main() {
    if (u_time > a_appearTime && u_time < a_appearTime + a_lifeTime) {
        gl_Position = u_mvpMatrix * vec4(a_position, 1.f);
        gl_PointSize = 30.f;
        v_percent = (u_time - a_appearTime) / a_lifeTime;
    } else {
        gl_PointSize = 0.f;
        v_percent = 1.f;
    }
}