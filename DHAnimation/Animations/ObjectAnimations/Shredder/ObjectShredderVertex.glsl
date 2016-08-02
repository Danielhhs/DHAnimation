#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_shredderPosition;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
       
vec4 updatedPosition() {
    vec4 position = a_position;
    position.y += u_shredderPosition;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}