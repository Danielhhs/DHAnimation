#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_event;
uniform vec2 u_center;
uniform vec2 u_resolution;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi = 3.1415927;
const float totalRotation = 4.f * pi;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    float rotation;
    if (a_position.x > u_center.x && a_position.y > u_center.y) {
        rotation = pi / 4.f;
    } else if (a_position.x < u_center.x && a_position.y > u_center.y) {
        rotation = pi / 4.f * 3.f;
    } else if (a_position.x < u_center.x && a_position.y < u_center.y) {
        rotation = pi / 4.f * 5.f;
    } else {
        rotation = pi / 4. * 7.f;
    }
    
    float radius = distance(a_position.xy, u_center);
    
    position.x = u_center.x + radius * cos(rotation + u_percent * totalRotation);
    position.y = u_center.y + radius * sin(rotation + u_percent * totalRotation);
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}