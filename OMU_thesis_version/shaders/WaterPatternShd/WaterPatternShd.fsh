varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_time;

void main() {
    vec2 uv = v_vTexcoord;
    float t = u_time * 0.25; // общий множитель скорости
    
    vec2 offset1 = vec2(
        sin(uv.y * 12.0 + t * 1.4) * 0.012,
        cos(uv.x * 10.0 + t * 1.1) * 0.012
    );
    vec2 offset2 = vec2(
        sin(uv.y * 7.0 - t * 0.9 + 1.5) * 0.009,
        cos(uv.x * 8.0 + t * 1.3 + 0.8) * 0.009
    );
    vec2 offset3 = vec2(
        sin(uv.x * 15.0 + uv.y * 6.0 + t * 2.0) * 0.006,
        cos(uv.y * 9.0 - uv.x * 4.0 - t * 1.7) * 0.006
    );
    
    vec2 animated_uv = uv + offset1 + offset2 + offset3;
    vec4 color = texture2D(gm_BaseTexture, animated_uv);
    
    float pulse = sin(t * 1.8 + uv.x * 6.0 + uv.y * 5.0) * 0.08 + 0.92;
    float highlight = pow(max(0.0, sin(uv.x * 20.0 + t * 3.0) * sin(uv.y * 15.0 - t * 2.5)), 3.0) * 0.15;
    
    color.rgb *= pulse;
    color.rgb += highlight;
    color.rgb = clamp(color.rgb, 0.0, 1.0);
    
    gl_FragColor = color * v_vColour;
}