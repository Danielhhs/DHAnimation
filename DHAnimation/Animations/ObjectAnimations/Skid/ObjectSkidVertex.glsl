#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_event;
uniform float u_percent;
uniform float u_offset;
uniform vec2 u_center;
uniform vec2 u_resolution;
uniform float u_slidingTime;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float c_forwardTime = 0.2;
const float c_backwardTime = 0.2;
const float c_recoverTime = 0.1;

const float c_forwardPercent = 0.3;
const float c_backwardPercent = 0.1;
vec4 updatedPosition() {
    vec4 position = a_position;
    
    float movement = 0.f;
    if (u_percent < u_slidingTime) {
        movement = -u_offset * (1.f - u_percent / u_slidingTime);
        position.x = a_position.x + movement;
    } else if (u_percent < u_slidingTime + c_forwardTime) {
        if (a_position.y > u_center.y) {
            position.x += u_resolution.x * c_forwardPercent * (u_percent - u_slidingTime) / c_forwardTime;
        } else {
            position.x += u_resolution.x * c_forwardPercent / 2.f * (u_percent - u_slidingTime) / c_forwardTime;
        }
    } else if (u_percent < u_slidingTime + c_forwardTime + c_backwardTime) {
        float percent = (u_percent - u_slidingTime - c_forwardTime) / c_backwardTime;
        if (a_position.y > u_center.y) {
            position.x = a_position.x + u_resolution.x * c_forwardPercent - percent * (u_resolution.x * (c_forwardPercent + c_backwardPercent));
        } else {
            position.x = a_position.x + u_resolution.x * c_forwardPercent / 2.f - percent * (u_resolution.x * c_forwardPercent / 2.f);
        }
    } else {
        float percent = (u_percent - u_slidingTime - c_forwardTime - c_backwardTime) / c_recoverTime;
        if (a_position.y > u_center.y) {
            position.x = a_position.x - u_resolution.x * c_backwardPercent + u_resolution.x * c_backwardPercent * percent;
        }
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}