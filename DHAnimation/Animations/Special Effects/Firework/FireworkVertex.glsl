#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec3 u_emissionPosition;
uniform float u_time;
uniform float u_duration;
uniform float u_gravity;

layout(location = 0) in vec3 a_direction;
layout(location = 1) in float a_velocity;
layout(location = 2) in float a_emissionTime;


float easeOutExpo(float t, float b, float c, float d) {
    return (t == d) ? b + c : c * (-pow(2.f, -10.f * t / d) + 1.f) + b;
}

float easeOutCubic(float t, float b, float c, float d) {
    return c * ((t = t / d - 1.f) * t * t + 1.f) + b;
}

const float c_explosionTime = 1.5;
vec4 updatedPosition() {
    float t = easeOutCubic((u_time - a_emissionTime) * 1000.f, 0.f, u_duration, u_duration * 1000.f);
    float ax = -(a_velocity * a_direction).x / u_duration;
    float g = ((a_direction.y + 1.f) / 2.f * u_gravity) * 0.7 + u_gravity * 0.3;
    vec3 offset = (a_velocity * a_direction * t + 0.5 * vec3(ax, -g, 0.f) * t * t);
    return vec4(u_emissionPosition + offset, 1.f);
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    gl_PointSize = 30.f;
}