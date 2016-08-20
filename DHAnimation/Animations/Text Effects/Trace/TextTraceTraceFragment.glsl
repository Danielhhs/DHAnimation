#version 300 es

precision highp float;

in vec4 v_color;

layout(location = 0) out vec4 out_color;

void main() {
//    out_color = v_color;
    out_color = vec4(1.f, 0.f, 0.f, 1.f);
}