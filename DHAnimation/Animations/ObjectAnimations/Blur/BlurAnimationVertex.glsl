#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec2 v_blurTexCoords[14];

void main() {
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
    
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    
    v_blurTexCoords[ 0] = v_texCoords + vec2(0.0, -0.056 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 1] = v_texCoords + vec2(0.0, -0.048 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 2] = v_texCoords + vec2(0.0, -0.040 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 3] = v_texCoords + vec2(0.0, -0.032 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 4] = v_texCoords + vec2(0.0, -0.024 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 5] = v_texCoords + vec2(0.0, -0.016 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 6] = v_texCoords + vec2(0.0, -0.008 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 7] = v_texCoords + vec2(0.0,  0.008 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 8] = v_texCoords + vec2(0.0,  0.016 * 1.5 * (1.f - percent));
    v_blurTexCoords[ 9] = v_texCoords + vec2(0.0,  0.024 * 1.5 * (1.f - percent));
    v_blurTexCoords[10] = v_texCoords + vec2(0.0,  0.032 * 1.5 * (1.f - percent));
    v_blurTexCoords[11] = v_texCoords + vec2(0.0,  0.040 * 1.5 * (1.f - percent));
    v_blurTexCoords[12] = v_texCoords + vec2(0.0,  0.048 * 1.5 * (1.f - percent));
    v_blurTexCoords[13] = v_texCoords + vec2(0.0,  0.056 * 1.5 * (1.f - percent));
}