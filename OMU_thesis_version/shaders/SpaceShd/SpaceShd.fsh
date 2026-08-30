varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_time;
uniform float u_aspect;

float hash(vec2 p) {
    p = fract(p * vec2(127.1, 311.7));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amp   = 0.5;
    float freq  = 1.0;
    for (int i = 0; i < 6; i++) {
        value += amp * noise(p * freq);
        freq  *= 2.1;
        amp   *= 0.48;
    }
    return value;
}

//float stars(vec2 uv, float density, float size) {
//    vec2 grid = floor(uv * density);
//    vec2 jitter = vec2(hash(grid), hash(grid + vec2(43.0, 17.0)));

//    float speed = hash(grid + vec2(7.3)) * 0.3 + 0.08;
//    float angle = hash(grid + vec2(13.7, 5.1)) * 6.28;
//    vec2 drift = vec2(cos(angle), sin(angle)) * speed * u_time * 0.015;

//    // Корректируем соотношение сторон чтобы звёзды были круглыми
//    vec2 aspectUV = vec2(uv.x, uv.y * u_aspect);
//    vec2 aspectPos = (grid + 0.5 + jitter * 0.75 + drift) / density;
//    aspectPos.y *= u_aspect;

//    float dist = length(aspectUV - aspectPos);

//    float brightness = hash(grid + vec2(99.0));
//    // Только яркие звёзды — отсеиваем тусклые
//    brightness = step(0.45, brightness) * brightness;
//    brightness = brightness * brightness;

//    float twinkle = 0.75 + 0.25 * sin(u_time * (1.5 + brightness * 6.0) + brightness * 80.0);

//    // Чёткий жёсткий край
//    float star = step(dist, size) * twinkle;
//    return star * brightness;
//}

void main() {
    vec2 uv = v_vTexcoord;
    float t = u_time * 0.025; // было 0.09

    vec2 q = vec2(fbm(uv + t * 0.15),
                  fbm(uv + vec2(5.2, 1.3) + t * 0.1));

    vec2 r = vec2(fbm(uv + 4.0 * q + vec2(1.7, 9.2) + t * 0.08),
                  fbm(uv + 4.0 * q + vec2(8.3, 2.8) - t * 0.07));

    // Искажаем UV для семплирования спрайта
    vec2 warpedUV = uv + (r - 0.5) * 0.15;

    // Семплируем спрайт с искажёнными координатами
    vec4 texColor = texture2D(gm_BaseTexture, warpedUV);

    // Дополнительно считаем base для контраста/постеризации
    float base = fbm(uv + 4.0 * r);
    base = pow(base, 1.8);
    base = smoothstep(0.2, 0.8, base);
    base = floor(base * 5.0) / 5.0;
    float ripple = fbm(uv * 2.5 + t * 0.2 + r) * 0.06; // было t*0.6 и 0.1
    base = clamp(base + ripple, 0.0, 1.0);
    base = smoothstep(0.15, 0.85, base);

    // Смешиваем цвет спрайта с эффектом разводов
    vec4 col = texColor * v_vColour;

    // base модулирует яркость — разводы влияют на изображение
    col.rgb *= (0.4 + base * 0.8);

    gl_FragColor = col;
}