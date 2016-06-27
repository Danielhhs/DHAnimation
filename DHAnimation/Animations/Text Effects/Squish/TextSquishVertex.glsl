#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_offset;
uniform float u_duration;
uniform float u_coefficient;
uniform float u_cycle;
uniform float u_gravity;
uniform float u_squishTime;
uniform float u_squishFactor;
uniform float u_numberOfCycles;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startTime;
layout(location = 3) in vec2 a_center;

out vec2 v_texCoords;

const float c_jumping_ratio = 0.8;
const float c_cofficient = 0.618;

const float c_expantionFactor = 1.2f;

vec2 squishWithTimeAndAmount(float time, float squishTime, float squishAmount)
{
    float percent = time / squishTime;
    float factor = -(1.f - squishAmount) * percent + 1.f;
    vec2 centerToPosition = a_position.xy - a_center;
    float yOffset = (centerToPosition.y - centerToPosition.y * factor) * 2.f;
    centerToPosition.x *= (1.f / factor);
    if (a_position.y > a_center.y) {
        centerToPosition.y -= yOffset * 2.f;
    }
    return a_center + centerToPosition;
}

vec2 expandWithTimeAndAmount(float time, float expandTime, float squishAmount) {
    float magnifyTime = expandTime;
    vec2 centerToPosition = a_position.xy - a_center;
    if (time < magnifyTime) {
        float percent = time / magnifyTime;
        float factor = (c_expantionFactor - squishAmount) * percent + squishAmount;
        float yOffset = (centerToPosition.y - centerToPosition.y * factor) * 2.f;
        centerToPosition.x *= (1.f / factor);
        if (a_position.y > a_center.y) {
            centerToPosition.y -= yOffset * 2.f;
        }
        return a_center + centerToPosition;
    }
    return centerToPosition;
}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    float time = u_time - a_startTime;
    
    //Animation for the current character not started yet
    if (time < 0.f) {
        position.y += u_offset;
        return position;
    }
    
    //Handles for the first pass;
    if (time < u_cycle / 2.f) {
        //free fall
        if (time < u_cycle / 2.f - u_squishTime) {
            float offset = u_offset - 0.5 * u_gravity * time * time;
            position.y += offset;
        } else {
            position.xy = squishWithTimeAndAmount(time - (u_cycle / 2.f - u_squishTime), u_squishTime, u_squishFactor);
        }
    } else {
        time = u_time - a_startTime - u_cycle / 2.f;
        float cycle = u_cycle * u_coefficient;
        float squishTime = u_squishTime * u_coefficient;
        float amplitude = u_offset * u_coefficient;
        float squishFactorIncrement = (1.f - u_squishFactor) / u_numberOfCycles;
        float squishFactor = u_squishFactor - squishFactorIncrement;
        while (time > 0.f && cycle > 0.01) {
            time -= cycle;
            amplitude *= u_coefficient;
            cycle *= u_coefficient;
            squishTime *= u_coefficient;
            squishFactor += squishFactorIncrement;
        }
        if (time < 0.f) {
            cycle /= u_coefficient;
            squishFactor -= squishFactorIncrement;
            squishTime /= u_coefficient;
            amplitude /= u_coefficient;
            time += cycle;
        }
        if (cycle <= 0.01) {
            return position;
        }
        float expandTime = squishTime;
        
        if (time < expandTime && expandTime > 0.05) {
            position.xy = expandWithTimeAndAmount(time, expandTime, squishFactor);
        }
        if (time >= cycle - squishTime) {
            if (squishTime > 0.05) {
                position.xy = squishWithTimeAndAmount(time - (cycle - squishTime), squishTime, squishFactor);
            }
        } else if (time > squishTime) {
            time = time - squishTime;
            float t = cycle / 2.f - squishTime;
            float velocity = u_gravity * t;
            float offset = velocity * time - 0.5 * u_gravity * time * time;
            position.y += offset;
        }
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}