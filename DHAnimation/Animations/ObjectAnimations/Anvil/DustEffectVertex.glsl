#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec4 a_targetPosition;
layout(location = 2) in float a_pointSize;
layout(location = 3) in float a_targetPointSize;