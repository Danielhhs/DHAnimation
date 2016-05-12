#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (u_percent < 0.5) {
        position.z += 200.f * u_percent / 0.5;
    } else {
        position.z = position.z + 200.f - (u_percent - 0.5) / 0.5 * 200.f;
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords =  a_texCoords;
}