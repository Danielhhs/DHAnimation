#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_headerHeight;
uniform float u_columnWidth;
uniform vec2 u_origin;
uniform float u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_index;
layout(location = 3) in vec4 a_columnStartPosition;

out vec2 v_texCoords;
out vec3 v_normal;

const float M_PI = 3.1415927;


vec4 updatedPositionForRightToLeft()
{
    vec4 position = a_position;
    float rotation = u_percent * M_PI / 2.f;
    int indexInFold = int(a_index) % 2;
    if (indexInFold == 0) {
        if (a_columnStartPosition.x == position.x) {
            position.x = u_origin.x + u_headerHeight + a_index * u_columnWidth * cos(rotation);
        } else {
            position.x = u_origin.x + u_headerHeight + (a_index + 1.f) * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        }
        v_normal = vec3(sin(rotation), 0.f, cos(rotation));
    } else {
        if (a_columnStartPosition.x == position.x) {
            position.x = u_origin.x + u_headerHeight + a_index * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        } else {
            position.x = u_origin.x + u_headerHeight + (a_index + 1.f) * u_columnWidth * cos(rotation);
        }
        v_normal = vec3(-sin(rotation), 0.f, cos(rotation));
    }
    return position;
}

vec4 updatedPositionForLeftToRight()
{
    vec4 position = a_position;
    float rotation = u_percent * M_PI / 2.f;
    int indexInFold = int(a_index) % 2;
    if (indexInFold == 0) {
        if (a_columnStartPosition.x != position.x) {
            position.x = u_origin.x - u_headerHeight - a_index * u_columnWidth * cos(rotation);
        } else {
            position.x = u_origin.x - u_headerHeight - (a_index + 1.f) * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        }
        v_normal = vec3(sin(rotation), 0.f, cos(rotation));
    } else {
        if (a_columnStartPosition.x != position.x) {
            position.x = u_origin.x - u_headerHeight - a_index * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        } else {
            position.x = u_origin.x - u_headerHeight - (a_index + 1.f) * u_columnWidth * cos(rotation);
        }
        v_normal = vec3(-sin(rotation), 0.f, cos(rotation));
    }
    return position;
}

vec4 updatedPositionForTopToBottom() {
    vec4 position = a_position;
    float rotation = u_percent * M_PI / 2.f;
    int indexInFold = int(a_index) % 2;
    if (indexInFold == 0) {
        if (a_columnStartPosition.y == position.y) {
            position.y = u_origin.y + u_headerHeight + a_index * u_columnWidth * cos(rotation);
        } else {
            position.y = u_origin.y + u_headerHeight + (a_index + 1.f) * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        }
        v_normal = vec3(0.f, sin(rotation), cos(rotation));
    } else {
        if (a_columnStartPosition.y == position.y) {
            position.y = u_origin.y + u_headerHeight + a_index * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        } else {
            position.y = u_origin.y + u_headerHeight + (a_index + 1.f) * u_columnWidth * cos(rotation);
        }
        v_normal = vec3(0.f, -sin(rotation), cos(rotation));
    }
    return position;
}

vec4 updatedPositionForBottomToTop() {
    vec4 position = a_position;
    float rotation = u_percent * M_PI / 2.f;
    int indexInFold = int(a_index) % 2;
    if (indexInFold == 0) {
        if (a_columnStartPosition.y == position.y) {
            position.y = u_origin.y - u_headerHeight - a_index * u_columnWidth * cos(rotation);
        } else {
            position.y = u_origin.y - u_headerHeight - (a_index + 1.f) * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        }
        v_normal = vec3(0.f, -sin(rotation), cos(rotation));
    } else {
        if (a_columnStartPosition.y == position.y) {
            position.y = u_origin.y - u_headerHeight - a_index * u_columnWidth * cos(rotation);
            position.z = -u_columnWidth * sin(rotation);
        } else {
            position.y = u_origin.y - u_headerHeight - (a_index + 1.f) * u_columnWidth * cos(rotation);
        }
        v_normal = vec3(0.f, sin(rotation), cos(rotation));
    }
    return position;
}

vec4 updatedPosition() {
    if (a_index < 0.f) {
        v_normal = vec3(0.f, 0.f, 1.f);
        return a_position;
    }
    if (u_direction == 0.f) {
        return updatedPositionForLeftToRight();
    } else if (u_direction == 1.f) {
        return updatedPositionForRightToLeft();
    } else if (u_direction == 2.f) {
        return updatedPositionForTopToBottom();
    } else {
        return updatedPositionForBottomToTop();
    }
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}