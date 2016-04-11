#version 300 es

precision highp float;
uniform sampler2D s_tex;

in vec2 v_texCoords;
in float v_shouldShow;

layout(location = 0) out vec4 out_color;

void main()
{
    vec4 texture_color = texture(s_tex, v_texCoords);
//    if (v_shouldShow != 1.f) {
//        discard;
//    }
    out_color = vec4(1.f, 0.f, 0.f, 1.f);
}