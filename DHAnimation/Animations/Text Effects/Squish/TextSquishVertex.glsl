#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_offset;
uniform float u_duration;
uniform float u_numberOfCycles;
uniform float u_coefficient;
uniform float u_cycle;
uniform float u_gravity;
uniform float u_squish;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startTime;
layout(location = 3) in vec2 a_center;

out vec2 v_texCoords;

const float c_jumping_ratio = 0.8;
const float c_cofficient = 0.618;

const float c_squishTime = 0.5;

vec2 squish(float time) {
    vec2 centerToPosition = a_position.xy - a_center;
    if (time > c_squishTime) {
        return vec2(0.f);
    }
    centerToPosition.x *= 0.618 * time / c_squishTime;
    centerToPosition.y *= 0.618 * time / c_squishTime;
    return centerToPosition;
}

vec2 expand(float time) {
    vec2 centerToPosition = a_position.xy - a_center;
    if (time > c_squishTime) {
        return vec2(0.f);
    }
    centerToPosition.x *= 0.618 * (1.f - time / c_squishTime);
    centerToPosition.y *= 0.618 * (1.f -time / c_squishTime);
    return  centerToPosition;
}

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
    if (timeInCycle < 0.f) {        //For the first pass, free fall
        timeInCycle = time;
        offset = u_offset - 0.5 * u_gravity * time * time;
    } else {
        while (cycle >= 0.01 && timeInCycle > 0.f) {    //For bouncing, find the cycle
            height *= u_coefficient;
            cycle *= u_coefficient;
            timeInCycle -= cycle;
        }
        timeInCycle += cycle;
        if (cycle < 0.01) {
            timeInCycle = 0.f;
        }
        float previousCycle = cycle / u_coefficient;
        if (previousCycle - timeInCycle < c_squishTime) {
            vec2 pointOffset = squish(previousCycle - timeInCycle);
            if (a_position.y > a_center.y) {
                position.y -= 2.f * pointOffset.y;
            }
            position.x += pointOffset.x;
        } else if (timeInCycle < c_squishTime) {
            vec2 pointOffset = expand(timeInCycle);
            if (a_position.y > a_center.y) {
                position.y -= 2.f * pointOffset.y;
            }
            position.x += pointOffset.x;
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