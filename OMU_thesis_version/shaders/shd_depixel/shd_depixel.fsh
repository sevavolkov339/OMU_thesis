varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texel_size;
uniform float u_upscale;
uniform float u_threshold;

#define AA_SCALE 17.6

vec4 fetchPixel(vec2 uv) {
    return texture2D(gm_BaseTexture, (floor(uv) + 0.5) * u_texel_size);
}

bool diag(inout vec4 sum, vec2 uv, vec2 p1, vec2 p2, float thickness) {
    vec4 v1 = fetchPixel(uv + p1);
    vec4 v2 = fetchPixel(uv + p2);

    if (length(v1 - v2) < u_threshold) {
        vec2 dir = p2 - p1;
        vec2 lp = uv - (floor(uv + p1) + 0.5);
        dir = normalize(vec2(dir.y, -dir.x));
        float l = clamp((thickness - dot(lp, dir)) * AA_SCALE, 0.0, 1.0);
        sum = mix(sum, v1, l);
        return true;
    }
    return false;
}

void main() {
    vec2 ip = v_vTexcoord / u_texel_size / u_upscale;

    vec4 s = fetchPixel(ip);

    if (diag(s, ip, vec2(-1,0), vec2(0,1), 0.38197)) {
        diag(s, ip, vec2(-1,0), vec2(1,1), 0.25);
        diag(s, ip, vec2(-1,-1), vec2(0,1), 0.25);
    }
    if (diag(s, ip, vec2(0,1), vec2(1,0), 0.38197)) {
        diag(s, ip, vec2(0,1), vec2(1,-1), 0.25);
        diag(s, ip, vec2(-1,1), vec2(1,0), 0.25);
    }
    if (diag(s, ip, vec2(1,0), vec2(0,-1), 0.38197)) {
        diag(s, ip, vec2(1,0), vec2(-1,-1), 0.25);
        diag(s, ip, vec2(1,1), vec2(0,-1), 0.25);
    }
    if (diag(s, ip, vec2(0,-1), vec2(-1,0), 0.38197)) {
        diag(s, ip, vec2(0,-1), vec2(-1,1), 0.25);
        diag(s, ip, vec2(1,-1), vec2(-1,0), 0.25);
    }

    gl_FragColor = v_vColour * s;
}