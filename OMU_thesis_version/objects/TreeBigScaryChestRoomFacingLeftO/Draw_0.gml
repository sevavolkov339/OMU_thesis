var _sway = sin(current_time * sway_speed + sway_offset) * 0.1;
var _prev = matrix_get(matrix_world);
var _mx = matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1);
_mx[4] = _sway;
matrix_set(matrix_world, matrix_multiply(_mx, _prev));

// чёрная обводка, рисуется первой (снаружи, дальше от спрайта), поэтому останется
var _black_offsets = [[-2,0],[2,0],[0,-2],[0,2]];
for (var i = 0; i < 4; i++) {
    draw_sprite_ext(sprite_index, image_index,
        _black_offsets[i][0], _black_offsets[i][1],
        -1, 1, 0, c_black, 1);
}
// белая обводка в 1 пиксель, рисуется поверх чёрной, прямо у края спрайта
var _white_offsets = [[-1,0],[1,0],[0,-1],[0,1]];
for (var i = 0; i < 4; i++) {
    draw_sprite_ext(sprite_index, image_index,
        _white_offsets[i][0], _white_offsets[i][1],
        -1, 1, 0, c_white, 1);
}
// оригинальный спрайт поверх без изменения цвета
draw_sprite_ext(sprite_index, image_index, 0, 0, -1, 1, 0, c_white, 1);

matrix_set(matrix_world, _prev);