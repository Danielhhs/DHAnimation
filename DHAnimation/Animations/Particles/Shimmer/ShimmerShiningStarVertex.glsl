#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_elapsedTime;

layout(location = 0) in vec4 a_position;
layout(location = 1) in float a_startShiningTime;
layout(location = 2) in float a_lifeTime;
layout(location = 3) in float a_size;
layout(location = 4) in float a_rotation;

out float v_rotation;
out float v_startShiningTime;
out float v_lifeTime;
out mat4 v_rotationMatrix;

void main() {
    if (u_elapsedTime - a_startShiningTime > a_lifeTime || u_elapsedTime < a_startShiningTime) {
        return;
    }
    gl_Position = u_mvpMatrix * a_position;
    float percent = (u_elapsedTime - a_startShiningTime) / a_lifeTime;
    float scale = -4.f * (percent - 0.5) * (percent - 0.5) + 1.f;
    gl_PointSize = a_size * scale;
    v_startShiningTime = a_startShiningTime;
    v_lifeTime = a_lifeTime;
    
    float rotation = (percent * 3.1415927 / 4.f);
    float cos = cos(rotation);
    float sin = sin(rotation);
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
    v_rotationMatrix = resultMat;
}