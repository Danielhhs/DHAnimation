#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_screenHeight;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float initialSwingRatio = 0.1;
const float transitionRatio = 0.2;
const float finalSwingRatio = 0.7;

const float pi = 3.141592657;
const float amplitude = pi / 10.f;

vec4 updatedPositionForInitialSwing()
{
    vec4 position = a_position;
    float percent = min(initialSwingRatio, u_percent);
    float rotation = percent / initialSwingRatio * amplitude;
    if (u_direction == 0) {
        rotation *= -1.f;
    }
    if (a_position.x == 0.f) {
        position.x = u_screenWidth / 2.f * (1.f - cos(rotation));
        position.y = u_screenHeight - u_screenWidth / 2.f * sin(rotation);
    } else {
        position.x = u_screenWidth / 2.f * (1.f + cos(rotation));
        position.y = u_screenHeight + u_screenWidth / 2.f * sin(rotation);
    }
    if (a_position.y == 0.f) {
        position.x = position.x + u_screenHeight * sin(rotation);
        position.y -= u_screenHeight * cos(rotation);
    }
    return position;
}

vec4 updatedPosition()
{
    vec4 position = a_position;
    if (u_percent <= initialSwingRatio + transitionRatio) {
        position = updatedPositionForInitialSwing();
        if (u_percent > initialSwingRatio) {
            float offset = (u_percent - initialSwingRatio) / transitionRatio * u_screenWidth * 1.5;
            if (u_direction == 1) {
                offset *= -1.f;
            }
            position.x = position.x + offset;
        }
    } else {
        position.x -= u_screenWidth * 1.5;
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}