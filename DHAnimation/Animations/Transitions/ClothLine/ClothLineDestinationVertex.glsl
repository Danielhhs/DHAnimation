#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_screenHeight;
uniform float u_duration;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float initialSwingRatio = 0.1;
const float transitionRatio = 0.2;
const float finalSwingRatio = 0.7;
const float finalSwingCycle = 0.5;

const float pi = 3.141592657;
const float amplitude = pi / 10.f;

vec4 updatedPositionForRotation(float rotation) {
    vec4 position = a_position;
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

vec4 updatedPositionForInitialSwing()
{
    float percent = min(initialSwingRatio, u_percent);
    float rotation = percent / initialSwingRatio * amplitude;
    if (u_direction == 0) {
        rotation *= -1.f;
    }
    return updatedPositionForRotation(rotation);
}

float rotationForCurrentState()
{
    float finalSwingTime = u_duration * finalSwingRatio;
    int cycleCount = int(finalSwingTime / finalSwingCycle);
    float swingedTime = (u_percent - initialSwingRatio - transitionRatio) * u_duration;
    int currentCycle = int(swingedTime / finalSwingCycle);
    float timeInCurrentCycle = swingedTime - float(currentCycle) * finalSwingCycle;
    
    float cycleInitialRotation = amplitude * (1.f - float(currentCycle) /  float(cycleCount));
    cycleInitialRotation = max(cycleInitialRotation, 0.f);
    if (currentCycle % 2 != 0) {
        cycleInitialRotation *= -1.f;
    }
    float cycleDestinationRotation = amplitude * (1.f - (float(currentCycle) + 1.f) /  float(cycleCount));
    if (currentCycle % 2 == 0) {
        cycleDestinationRotation *= -1.f;
    }
    if (currentCycle == cycleCount) {
        cycleDestinationRotation = 0.f;
    }
    
    float cycleRotationRange = cycleDestinationRotation - cycleInitialRotation;
    float rotation = cycleInitialRotation + sin((timeInCurrentCycle / finalSwingCycle) * pi / 2.f) * cycleRotationRange;
    if (u_direction == 0) {
        rotation *= -1.f;
    }
    return rotation;
//    float rotation = pi / 6.f * (1.f - swingedTime / finalSwingTime);
//    return rotation;
}

vec4 updatedPositionForFinalSwing()
{
    float rotation = rotationForCurrentState();
    return updatedPositionForRotation(rotation);
}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (u_percent < initialSwingRatio) {
        position.x += u_screenWidth * 1.5;
    } else if (u_percent < initialSwingRatio + transitionRatio) {
        position = updatedPositionForInitialSwing();
        float offset = u_screenWidth * 1.5 * (1.f - (u_percent - initialSwingRatio) / transitionRatio);
        if (u_direction == 0) {
            offset *= -1.f;
        }
        position.x += offset;
    } else {
        position = updatedPositionForFinalSwing();
    }
    
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}