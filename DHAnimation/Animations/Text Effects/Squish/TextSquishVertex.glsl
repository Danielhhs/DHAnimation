#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_offset;
uniform float u_duration;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startTime;

out vec2 v_texCoords;

const float c_jumping_ratio = 0.8;
const float c_gravity = -1000.f;

//vec4 updatedPosition() {
//    float jumpingTime = u_duration * c_jumping_ratio;
//    float time = u_time - a_startTime;
//    
//    float jumpCycle = sqrt(2.f * u_offset / c_gravity);
//    float cycles = jumpingTime / jumpCycle;
//    int numberOfCycles = int(ceil(cycles));
//    cycles = time / jumpCycle;
//    int currentCycle = int(floor(cycles));
//    float amplitude = (1.f - float(currentCycle) / float(numberOfCycles)) * u_offset;
//    float timeInCycle = time - float(currentCycle) * jumpCycle;
//    
//    float y = 0.f;
//    if (currentCycle == 0) {
//        y = 0.5 * c_gravity * time * time;
//    } else {
//        float velocity = sqrt(2.f * c_gravity * amplitude);
//        y = velocity * timeInCycle - 0.5 * c_gravity * timeInCycle * timeInCycle;
//    }
//    vec4 position = a_position;
//    position.y = y;
//    return position;
//}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    float jumpingTime = u_duration * c_jumping_ratio;
    float time = u_time - a_startTime;
    if (time < 0.f) {
        position.y += u_offset;
        return position;
    } else if (time > jumpingTime) {
        return position;
    }
    float jumpCycle = sqrt(2.f * u_offset / (-1.f * c_gravity)) * 2.f;
    float cycles = (jumpingTime - jumpCycle / 2.f) / jumpCycle + 1.f;
    int numberOfCycles = int(ceil(cycles));
    cycles = (time - jumpCycle / 2.f) / jumpCycle + 1.f;
    int currentCycle = int(floor(cycles));
    if (time < jumpCycle / 2.f) {
        currentCycle = 0;
    }
    float amplitude = (1.f - float(currentCycle) / float(numberOfCycles)) * u_offset;
    float timeInCycle = time - jumpCycle / 2.f - float(currentCycle - 1) * jumpCycle;
    if (currentCycle == 0) {
        timeInCycle = time;
    }
    
    float y = a_position.y + u_offset;
    
    if (currentCycle == 0) {
        y += 0.5 * c_gravity * time * time;
    } else {
        float velocity = sqrt(2.f * (-1.f * c_gravity) * amplitude);
        y = a_position.y + velocity * timeInCycle + 0.5 * c_gravity * timeInCycle * timeInCycle;
    }
//    float time = u_time - a_startTime;
//    float y = 0.f;
//    y = 0.5 * c_gravity * time * time;
    position.y = y;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}