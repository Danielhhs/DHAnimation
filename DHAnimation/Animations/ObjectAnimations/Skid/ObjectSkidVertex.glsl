#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_event;
uniform float u_percent;
uniform float u_offset;
uniform vec2 u_center;
uniform vec2 u_resolution;
uniform float u_slidingTime;
uniform float u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float c_forwardTime = 0.2;
const float c_backwardTime = 0.2;
const float c_recoverTime = 0.1;

const float c_forwardPercent = 0.3;
const float c_backwardPercent = 0.1;

vec4 updatedPositionForLeftIn() {
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
    } else if (u_percent < u_slidingTime + c_forwardTime + c_backwardTime + c_recoverTime) {
        float percent = (u_percent - u_slidingTime - c_forwardTime - c_backwardTime) / c_recoverTime;
        if (a_position.y > u_center.y) {
            position.x = a_position.x - u_resolution.x * c_backwardPercent + u_resolution.x * c_backwardPercent * percent;
        }
    }
    
    return position;
}

vec4 updatedPositionForRightIn() {
    vec4 position = a_position;
    float offset = u_offset;
    float movement = 0.f;
    if (u_percent < u_slidingTime) {
        movement = u_offset * (1.f - u_percent / u_slidingTime);
        position.x = a_position.x + movement;
    } else if (u_percent < u_slidingTime + c_forwardTime) {
        if (a_position.y > u_center.y) {
            position.x -= u_resolution.x * c_forwardPercent * (u_percent - u_slidingTime) / c_forwardTime;
        } else {
            position.x -= u_resolution.x * c_forwardPercent / 2.f * (u_percent - u_slidingTime) / c_forwardTime;
        }
    } else if (u_percent < u_slidingTime + c_forwardTime + c_backwardTime) {
        float percent = (u_percent - u_slidingTime - c_forwardTime) / c_backwardTime;
        if (a_position.y > u_center.y) {
            position.x = a_position.x - (u_resolution.x * c_forwardPercent - percent * (u_resolution.x * (c_forwardPercent + c_backwardPercent)));
        } else {
            position.x = a_position.x - (u_resolution.x * c_forwardPercent / 2.f - percent * (u_resolution.x * c_forwardPercent / 2.f));
        }
    } else if (u_percent < u_slidingTime + c_forwardTime + c_backwardTime + c_recoverTime) {
        float percent = (u_percent - u_slidingTime - c_forwardTime - c_backwardTime) / c_recoverTime;
        if (a_position.y > u_center.y) {
            position.x = a_position.x + u_resolution.x * c_backwardPercent - u_resolution.x * c_backwardPercent * percent;
        }
    }
    
    return position;
}

vec4 updatedPositionForLeftOut() {
    vec4 position = a_position;
    float movement = -u_offset * u_percent;
    position.x += movement;
    return position;
}

vec4 updatedPositionForRightOut() {
    vec4 position = a_position;
    float movement = u_offset * u_percent;
    position.x += movement;
    return position;
}

vec4 updatedPosition() {
    vec4 position = a_position;
    if (u_event == 0.f) {
        if (u_direction == 0.f) {
            position = updatedPositionForLeftIn();
        } else {
            position = updatedPositionForRightIn();
        }
    } else {
        if (u_direction == 0.f) {
            position = updatedPositionForLeftOut();
        } else {
            position = updatedPositionForRightOut();
        }
    }
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}