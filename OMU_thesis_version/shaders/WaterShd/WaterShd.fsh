varying vec2 v_vTexcoord;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec4 u_color_shallow; // цвет мелкой воды
uniform vec4 u_color_deep;    // цвет глубокой воды

// байеровская матрица 4x4
float bayer4x4(vec2 pos) {
    int x = int(mod(pos.x, 4.0));
    int y = int(mod(pos.y, 4.0));
    int index = x + y * 4;
    float matrix[16];
    matrix[0]  =  0.0 / 16.0;
    matrix[1]  =  8.0 / 16.0;
    matrix[2]  =  2.0 / 16.0;
    matrix[3]  = 10.0 / 16.0;
    matrix[4]  = 12.0 / 16.0;
    matrix[5]  =  4.0 / 16.0;
    matrix[6]  = 14.0 / 16.0;
    matrix[7]  =  6.0 / 16.0;
    matrix[8]  =  3.0 / 16.0;
    matrix[9]  = 11.0 / 16.0;
    matrix[10] =  1.0 / 16.0;
    matrix[11] =  9.0 / 16.0;
    matrix[12] = 15.0 / 16.0;
    matrix[13] =  7.0 / 16.0;
    matrix[14] = 13.0 / 16.0;
    matrix[15] =  5.0 / 16.0;
    return matrix[index];
}

void main() {
    vec2 pixel_pos = floor(v_vTexcoord * u_resolution);
    
    // волны — несколько слоёв синусов
    float wave1 = sin(v_vTexcoord.x * 8.0 + u_time * 1.2) * 0.5 + 0.5;
    float wave2 = sin(v_vTexcoord.x * 5.0 - u_time * 0.8 + v_vTexcoord.y * 3.0) * 0.5 + 0.5;
    float wave3 = sin(v_vTexcoord.y * 6.0 + u_time * 1.0 + v_vTexcoord.x * 2.0) * 0.5 + 0.5;
    
    // комбинируем волны
    float wave = (wave1 * 0.5 + wave2 * 0.3 + wave3 * 0.2);
    
    // дополнительные блики — быстрые маленькие волны
    float highlight = sin(v_vTexcoord.x * 20.0 + u_time * 3.0) * 
                      sin(v_vTexcoord.y * 15.0 + u_time * 2.0);
    highlight = clamp(highlight, 0.0, 1.0);
    highlight = pow(highlight, 3.0); // только яркие пики
    
    wave = clamp(wave + highlight * 0.3, 0.0, 1.0);
    
    // dithering
    float threshold = bayer4x4(pixel_pos);
    float dithered = step(threshold, wave);
    
    // второй уровень dithering для переходов между цветами
    float wave_mid = clamp(wave * 2.0 - 0.5, 0.0, 1.0);
    float dithered_mid = step(threshold, wave_mid);
    
    // три зоны: глубокая / средняя / мелкая
    vec4 color;
    if (dithered_mid > 0.5) {
        color = u_color_shallow; // блик / мелко
    } else if (dithered > 0.5) {
        color = mix(u_color_deep, u_color_shallow, 0.5); // средняя
    } else {
        color = u_color_deep; // глубоко
    }
    
    gl_FragColor = color;
}