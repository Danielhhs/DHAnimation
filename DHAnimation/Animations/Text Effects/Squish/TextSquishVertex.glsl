#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_offset;
uniform float u_duration;
uniform float u_numberOfCycles;
uniform float u_coefficient;
uniform float u_cycle;
uniform float u_gravity;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startTime;

out vec2 v_texCoords;

const float c_jumping_ratio = 0.8;
const float c_cofficient = 0.618;

vec4 updatedPosition() {
    vec4 position = a_position;
    float time = u_time - a_startTime;
    if (time < 0.f) {
        position.y += u_offset;
        return position;
    }
    float timeInCycle = time - u_cycle / 2.f;
    float height = u_offset;
    float cycle = u_cycle;
    float offset = 0.f;
    if (timeInCycle < 0.f) {
        timeInCycle = time;
        offset = u_offset - 0.5 * u_gravity * time * time;
    } else {
        while (cycle >= 0.01 && timeInCycle > 0.f) {
            height *= u_coefficient;
            cycle *= u_coefficient;
            timeInCycle -= cycle;
        }
        timeInCycle += cycle;
        if (cycle < 0.01) {
            timeInCycle = 0.f;
        }
        float velocity = u_gravity * (cycle / 2.f);
        offset = velocity * timeInCycle - 0.5 * u_gravity * timeInCycle * timeInCycle;
    }
    position.y += offset;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}