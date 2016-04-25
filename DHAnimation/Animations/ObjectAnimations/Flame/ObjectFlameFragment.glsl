//#version 300 es
//
//precision highp float;
//
//uniform sampler2D s_tex;
//uniform float u_percent;
//
//in vec2 v_texCoords;
//
//layout(location = 0) out vec4 out_color;
//
//void main() {
//    out_color = texture(s_tex, v_texCoords);
//    out_color.a = u_percent;
//}

#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform vec2 u_resolution;
uniform float uTime;
uniform vec4 u_rect;
uniform float u_percent;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

const float noiseScale = 15.f;
const float noiseTimeScale = 0.9;
const float noiseUpSpeed = 7.0;

const int noiseCurlSteps = 2;
const float noiseCurlValue = 0.5;
const float noiseCurlStepValue = noiseCurlValue / float(noiseCurlSteps);

const int colorsCount = 16;
const vec3 c0 = vec3(1.00, 1.00, 1.00);
const vec3 c1 = vec3(1.00, 0.97, 0.70);
const vec3 c2 = vec3(0.99, 0.94, 0.50);
const vec3 c3 = vec3(0.98, 0.90, 0.30);
const vec3 c4 = vec3(0.98, 0.85, 0.25);
const vec3 c5 = vec3(0.98, 0.80, 0.20);
const vec3 c6 = vec3(0.98, 0.75, 0.15);
const vec3 c7 = vec3(0.98, 0.70, 0.10);
const vec3 c8 = vec3(0.98, 0.60, 0.00);
const vec3 c9 = vec3(0.95, 0.50, 0.00);
const vec3 c10 = vec3(0.90, 0.40, 0.00);
const vec3 c11 = vec3(0.75, 0.30, 0.00);
const vec3 c12 = vec3(0.60, 0.20, 0.00);
const vec3 c13 = vec3(0.50, 0.10, 0.00);
const vec3 c14 = vec3(0.40, 0.10, 0.00);
const vec3 c15 = vec3(0.00, 0.00, 0.00);

vec3 getColor(int i) {
    return i<8 ?
    i<4 ? i<2 ? i==0 ? c0 : c1 : i==2 ? c2 : c3 : i<6 ? i==4 ? c4 : c5 : i==6 ? c6 : c7 :
    i<12 ? i<10 ? i==8 ? c8 : c9 : i==10 ? c10 : c11 : i<14 ? i==12 ? c12 : c13 : i==14 ? c14 : c15;
    
}
vec3 getColor(float v) {
    v = 1.0 - v;
    int i = int(v * float(colorsCount-1));
    vec3 color1 = getColor(i);
    vec3 color2 = getColor(i+1);
    return mix(color1, color2, fract(v * float(colorsCount-1)));
}

float simplex(vec3 v);
float getNoise(vec3 v, float curl);


void main()
{
    if (gl_FragCoord.x >= u_rect.x && gl_FragCoord.x <= u_rect.z && gl_FragCoord.y >= u_rect.y && gl_FragCoord.y <= u_rect.w) {
        vec2 resolution = u_resolution;
        resolution.y = u_resolution.y * (0.5 + u_percent);
        vec2 uv = (gl_FragCoord.xy - u_rect.xy) / resolution.xy;
        float speed = noiseUpSpeed + (1.f + 3.f * u_percent);
        vec3 noisePos = vec3(uv * noiseScale - vec2(0, uTime * speed), uTime * noiseTimeScale);
        float noise = getNoise(noisePos, 0.5+sqrt(uv.y)/2.);  //more curly in the upper part
        float fire = noise*noise*1.5 + noise*0.8 - uv.y*2.0 + 0.25;  //more contrast noise in the upper part
        fire = clamp(fire, 0.0, 1.0);
        out_color = vec4(getColor(fire), 1.0);
        if (out_color.x < 0.1 && out_color.y < 0.1 && out_color.z < 0.1) {
            out_color.a = 0.f;
        } else {
            out_color.a = 1.f - u_percent * u_percent * u_percent;
        }
    } else {
        discard;
    }
}



//    noise

float fbm3(vec3 v) {
    float result = simplex(v);
    result += simplex(v * 2.) / 2.;
    result += simplex(v * 4.) / 4.;
    result /= (1. + 1./2. + 1./4.);
    return result;
}

float fbm5(vec3 v) {
    float result = simplex(v);
    result += simplex(v * 2.) / 2.;
    result += simplex(v * 4.) / 4.;
    result += simplex(v * 8.) / 8.;
    result += simplex(v * 16.) / 16.;
    result /= (1. + 1./2. + 1./4. + 1./8. + 1./16.);
    return result;
}

float getNoise(vec3 v, float curl) {
    //  make it curl
    for (int i=0; i<noiseCurlSteps; i++) {
        v.xy += vec2(fbm3(v), fbm3(vec3(v.xy, v.z + 1000.))) * noiseCurlStepValue * curl;
    }
    //  normalize
    return fbm5(v) / 2. + 0.5;
}

//
// Description : Array and textureless GLSL 2D/3D/4D simplex
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

vec3 mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
    return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float simplex(vec3 v)
{
    const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);
    
    // First corner
    vec3 i  = floor(v + dot(v, C.yyy) );
    vec3 x0 =   v - i + dot(i, C.xxx) ;
    
    // Other corners
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy );
    
    //   x0 = x0 - 0.0 + 0.0 * C.xxx;
    //   x1 = x0 - i1  + 1.0 * C.xxx;
    //   x2 = x0 - i2  + 2.0 * C.xxx;
    //   x3 = x0 - 1.0 + 3.0 * C.xxx;
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
    vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
    
    // Permutations
    i = mod289(i);
    vec4 p = permute( permute( permute(
                                       i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
                              + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
                     + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
    
    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float n_ = 0.142857142857; // 1.0/7.0
    vec3  ns = n_ * D.wyz - D.xzx;
    
    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
    
    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
    
    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);
    
    vec4 b0 = vec4( x.xy, y.xy );
    vec4 b1 = vec4( x.zw, y.zw );
    
    //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
    //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));
    
    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
    
    vec3 p0 = vec3(a0.xy,h.x);
    vec3 p1 = vec3(a0.zw,h.y);
    vec3 p2 = vec3(a1.xy,h.z);
    vec3 p3 = vec3(a1.zw,h.w);
    
    //Normalise gradients
    vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;
    
    // Mix final noise value
    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
                                 dot(p2,x2), dot(p3,x3) ) );
}