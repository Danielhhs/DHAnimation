#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_event;
uniform float u_percent;
uniform vec2 u_resolution;
uniform float u_elapsedTime;

in vec2 v_texCoords;

const int c_samplesX = 11;
const int c_samplesY = 11;

const int c_halfSamplesX = c_samplesX / 2;
const int c_halfSamplesY = c_samplesY / 2;

layout(location = 0) out vec4 out_color;

float Gaussian(float sigma, float x) {
    return exp(-(x * x) / (2.f * sigma * sigma));
}

vec3 BlurredPixel (vec2 uv) {
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    float c_sigmaX = (percent * 0.5 + 0.5) * 20.f;
    float c_sigmaY = c_sigmaX;
    
    float total  = 0.f;
    vec3 ret = vec3(0.f);
    vec2 pixelSize = 1.f / u_resolution.xy;
    for (int iy = 0; iy < c_samplesY; ++iy) {
        float fy = Gaussian(c_sigmaY, float(iy) - float(c_halfSamplesY));
        float offsetY = float(iy - c_halfSamplesY) * pixelSize.y;
        for (int ix = 0; ix < c_samplesX; ++ix) {
            float fx = Gaussian(c_sigmaX, float(ix) - float(c_halfSamplesX));
            float offsetX = float(ix - c_halfSamplesX) * pixelSize.x;
            total += fx * fy;
            ret += texture(s_tex, uv + vec2(offsetX, offsetY)).rgb * fx * fy;
        }
    }
    return ret / total;
}

void main() {
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    out_color = vec4(BlurredPixel(v_texCoords), percent);
}

