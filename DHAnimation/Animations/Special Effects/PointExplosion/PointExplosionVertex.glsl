#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_gravity;
uniform float u_time;
uniform vec3 u_emissionPosition;

layout(location = 0) in vec3 a_direction;
layout(location = 1) in float a_velocity;
layout(location = 2) in float a_pointSize;

const float cvr = 0.75;

vec4 updatedPosition() {
    vec3 offset = (a_velocity * a_direction * u_time + 0.5 * vec3(0.f, -u_gravity, 0.f) * u_time * u_time);
    float vy = a_velocity * a_direction.y;
    float duration = vy / u_gravity * 2.f;
    float timeInCycle = u_time - duration;
    float amplitude = 1.f;
    while (timeInCycle > 0.f && duration > 0.01) {
        amplitude *= cvr;
        vy *= cvr;
        duration = vy / u_gravity * 2.f;
        timeInCycle -= duration;
    }
    timeInCycle += duration;
    offset.y = vy * timeInCycle - 0.5 * u_gravity * timeInCycle * timeInCycle;
    return vec4(u_emissionPosition + offset, 1.f);
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    if (position.y < u_emissionPosition.y || u_time <= 0.f) {
        gl_PointSize = 0.f;
    } else {
        gl_PointSize = a_pointSize;
    }
}