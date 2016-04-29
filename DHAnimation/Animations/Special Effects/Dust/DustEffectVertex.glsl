#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec4 a_targetPosition;
layout(location = 2) in float a_pointSize;
layout(location = 3) in float a_targetPointSize;
layout(location = 4) in float a_rotation;

out mat4 v_rotation;

vec4 updatedPosition()
{
    vec4 position = a_position;
    position += (a_targetPosition - a_position) * u_percent;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    gl_PointSize = a_pointSize + (a_targetPointSize - a_pointSize) * u_percent;
    float a_angle = a_rotation * u_percent;
    float cos = cos(a_angle);
    float sin = sin(a_angle);
    mat4 transInMat = mat4(1.0, 0.0, 0.0, 0.0,
                           0.0, 1.0, 0.0, 0.0,
                           0.0, 0.0, 1.0, 0.0,
                           0.5, 0.5, 0.0, 1.0);
    mat4 rotMat = mat4(cos, -sin, 0.0, 0.0,
                       sin, cos, 0.0, 0.0,
                       0.0, 0.0, 1.0, 0.0,
                       0.0, 0.0, 0.0, 1.0);
    mat4 resultMat = transInMat * rotMat;
    resultMat[3][0] = resultMat[3][0] + resultMat[0][0] * -0.5 + resultMat[1][0] * -0.5;
    resultMat[3][1] = resultMat[3][1] + resultMat[0][1] * -0.5 + resultMat[1][1] * -0.5;
    resultMat[3][2] = resultMat[3][2] + resultMat[0][2] * -0.5 + resultMat[1][2] * -0.5;
    v_rotation = resultMat;
    if (u_percent <= 0.f) {
        gl_PointSize = 0.f;
    }
}