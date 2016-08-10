#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_offset;
uniform float u_duration;
uniform float u_amplitude;
uniform float u_cycle;
uniform float u_singleCycleDuration;
uniform float u_gravity;
uniform float u_squishTimeRatio;
uniform float u_squishFactor;
uniform float u_event;
uniform float u_singleCharDuration;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startTime;
layout(location = 3) in vec2 a_center;

out vec2 v_texCoords;

vec2 squishWithTime(float time) {
    float percent = time / (u_singleCycleDuration * u_squishTimeRatio);
    vec2 centerToPosition = a_position.xy - a_center;
    float factor = -(1.f - u_squishFactor) * percent + 1.f;
    vec2 offset = centerToPosition;
    offset.x = centerToPosition.x * (1.f / factor);
    if (a_position.y > a_center.y) {
        offset.y = centerToPosition.y * (factor - 1.f) * 2.f;
    }
    return a_center + offset;
}

vec2 expandWithTime(float time) {
    float percent = time / (u_singleCycleDuration * u_squishTimeRatio);
    vec2 centerToPosition = a_position.xy - a_center;
    float factor = (1.f - u_squishFactor) * percent + u_squishFactor;
    vec2 offset = centerToPosition;
    offset.x = centerToPosition.x * (1.f / factor);
    if (a_position.y > a_center.y) {
        offset.y = centerToPosition.y * (factor - 1.f) * 2.f;
    }
    return a_center + offset;
    
}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    float startTime = a_startTime;
    if (u_event == 1.f) {
        startTime = u_duration - u_singleCharDuration - startTime;
    }
    float time = u_time - startTime;
    if (u_event == 1.f) {
        time = u_singleCharDuration - time;
    }
    float percent = time / u_singleCharDuration;
    if (percent <= 0.f) {
        position.x += u_offset;
        return position;
    }
    if (percent <= 1.f) {
        float timeInCycle = time;
        float xOffset = u_offset;
        float xOffsetForOneCycle = -u_offset * (u_singleCycleDuration / u_singleCharDuration);
        while (timeInCycle > 0.f) {
            timeInCycle -= u_singleCycleDuration;
            xOffset += xOffsetForOneCycle;
        }
        timeInCycle += u_singleCycleDuration;
        xOffset -= xOffsetForOneCycle;
        if (timeInCycle < u_singleCycleDuration * u_squishTimeRatio) {
            position.xy = expandWithTime(timeInCycle);
        } else if (timeInCycle > u_singleCycleDuration * (1.f - u_squishTimeRatio)) {
            xOffset += xOffsetForOneCycle;
            position.xy = squishWithTime(timeInCycle - u_singleCycleDuration * (1.f - u_squishTimeRatio));
        } else {
            timeInCycle -= u_singleCycleDuration * u_squishTimeRatio;
            float xPercent = timeInCycle / (u_singleCycleDuration * (1.f - 2.f * u_squishTimeRatio));
            xOffset += xOffsetForOneCycle * xPercent;
            float velocity = u_gravity * (u_singleCycleDuration / 2.f - u_singleCycleDuration * u_squishTimeRatio);
            float y = velocity * timeInCycle - 0.5 * u_gravity * timeInCycle * timeInCycle;
            position.y += y;
        }
        position.x += xOffset;
    }
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}