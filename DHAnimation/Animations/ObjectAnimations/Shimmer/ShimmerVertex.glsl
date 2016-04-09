#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform mat4 u_rotationMatrix;
uniform float u_event;

layout(location = 0) in vec4 a_startingPosition;
layout(location = 1) in float a_size;
layout(location = 2) in float a_targetSize;
layout(location = 3) in vec4 a_targettingPosition;
layout(location = 4) in vec2 a_texCoords;

out vec2 v_texCoords;

const float transitionRatio = 0.7;
const float maxScale = 1.6;

void main() {
    if (u_event == 0.f) {
        if (u_percent <= transitionRatio) {
            vec4 currentPosition = a_startingPosition + (a_targettingPosition - a_startingPosition) * (u_percent / transitionRatio);
            gl_Position = u_mvpMatrix * currentPosition;
            gl_PointSize = a_size + (a_targetSize - a_size) * (u_percent / transitionRatio);
        } else {
            gl_Position = u_mvpMatrix * a_targettingPosition;
            float middleX = (1.f - transitionRatio) / 2.f;
            float a = (1.f - maxScale) / (middleX * middleX);
            float scale = a * (u_percent - transitionRatio - middleX) * (u_percent - transitionRatio - middleX) + maxScale;
            gl_PointSize = a_targetSize * scale;
        }
    } else {
        if (u_percent <= 1.f - transitionRatio) {
            gl_Position = u_mvpMatrix * a_startingPosition;
            float middleX = (1.f - transitionRatio) / 2.f;
            float a = (1.f - maxScale) / (middleX * middleX);
            float scale = a * (u_percent - middleX) * (u_percent - middleX) + maxScale;
            gl_PointSize = a_size * scale;
        } else {
            vec4 currentPosition = a_startingPosition + (a_targettingPosition - a_startingPosition) * ((u_percent - (1.f - transitionRatio)) / transitionRatio);
            gl_Position = u_mvpMatrix * currentPosition;
            gl_PointSize = a_size + (a_targetSize - a_size) * ((u_percent - (1.f - transitionRatio)) / transitionRatio);
        }
    }
    v_texCoords = a_texCoords;
}