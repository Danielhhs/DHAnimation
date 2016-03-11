#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_edgeWidth;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec3 a_normal;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec3 a_columnStartPosition;

out vec2 v_texCoords;
out vec3 v_normal;

const float pi = 3.1415926;
const float pi_2 = pi / 2.f;
const float pi_4 = pi / 4.f;
const float sqrt_2 = sqrt(2.f);

vec4 updatedPositionForRightToLeft() {
    vec4 position = a_position;
    float rotation = u_percent * pi_2 - pi_4;
    float radius = u_edgeWidth * sqrt_2 / 2.f;
    vec2 center = vec2(a_columnStartPosition.x + u_edgeWidth /  2.f, -u_edgeWidth / 2.f);
    if (position.x == a_columnStartPosition.x) {
        position.z = center.y - radius * sin(rotation);
        position.x = center.x - radius * cos(rotation);
    } else {
        position.x = center.x - radius * sin(rotation);
        position.z = center.y + radius * cos(rotation);
    }
    v_normal = vec3(sin(u_percent * pi_2), 0.f, cos(u_percent * pi_2));
    return position;
}

vec4 updatedPositionForLeftToRight() {
    vec4 position = a_position;
    float rotation = u_percent * pi_2 - pi_4;
    float radius = u_edgeWidth * sqrt_2 / 2.f;
    vec2 center = vec2(a_columnStartPosition.x + u_edgeWidth /  2.f, -u_edgeWidth / 2.f);
    if (position.x == a_columnStartPosition.x) {
        position.x = center.x + radius * sin(rotation);
        position.z = center.y + radius * cos(rotation);
    } else {
        position.x = center.x + radius * cos(rotation);
        position.z = center.y - radius * sin(rotation);
    }
    v_normal = vec3(sin(u_percent * pi_2), 0.f, cos(u_percent * pi_2));
    return position;
}

vec4 updatedPositionForTopToBottom() {
    vec4 position = a_position;
    float rotation = u_percent * pi_2 - pi_4;
    float radius = u_edgeWidth * sqrt_2 / 2.f;
    vec2 center = vec2(a_columnStartPosition.y + u_edgeWidth /  2.f, -u_edgeWidth / 2.f);
    if (position.y == a_columnStartPosition.y) {
        position.y = center.x - radius * cos(rotation);
        position.z = center.y - radius * sin(rotation);
    } else {
        position.y = center.x - radius * sin(rotation);
        position.z = radius * cos(rotation) + center.y;
    }
    v_normal = vec3(0.f, sin(u_percent * pi_2), cos(u_percent * pi_2));
    return position;
}

vec4 updatedPositionForBottomToTop() {
    vec4 position = a_position;
    vec2 center = vec2(a_columnStartPosition.y + u_edgeWidth /  2.f, -u_edgeWidth / 2.f);
    float rotation = u_percent * pi_2 - pi_4;
    float radius = u_edgeWidth * sqrt_2 / 2.f;
    if (position.y == a_columnStartPosition.y) {
        position.y = center.x + radius * sin(rotation);
        position.z = radius * cos(rotation) + center.y;
    } else {
        position.z = center.y - radius * sin(rotation);
        position.y = center.x + radius * cos(rotation);
    }
    v_normal = vec3(0.f, sin(u_percent * pi_2), cos(u_percent * pi_2));
    return position;
}

vec4 updatedPosition() {
    if (u_direction == 0) {
        return updatedPositionForLeftToRight();
    } else if (u_direction == 1) {
        return updatedPositionForRightToLeft();
    } else if (u_direction == 2) {
        return updatedPositionForTopToBottom();
    } else if (u_direction == 3) {
        return updatedPositionForBottomToTop();
    }
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}