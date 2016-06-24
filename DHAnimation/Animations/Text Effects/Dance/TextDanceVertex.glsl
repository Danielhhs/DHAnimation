#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_offset;
uniform float u_duration;
uniform float u_amplitude;
uniform float u_cycle;
uniform float u_singleCycleDuration;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startTime;

out vec2 v_texCoords;

const float c_gravity = -1000.f;

vec4 updatedPosition() {
    vec4 position = a_position;
    float time = u_time - a_startTime;
    float percent = time / u_duration;
    if (percent <= 1.f) {
        position.x += u_offset * (1.f - percent);
        float timeInCycle = time;
        while (timeInCycle > 0.f) {
            timeInCycle -= u_singleCycleDuration;
        }
        timeInCycle += u_singleCycleDuration;
        float velocity = sqrt(2.f * -c_gravity * u_amplitude);
        float y = velocity * timeInCycle + 0.5 * c_gravity * timeInCycle * timeInCycle;
        position.y += y;
    }
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}