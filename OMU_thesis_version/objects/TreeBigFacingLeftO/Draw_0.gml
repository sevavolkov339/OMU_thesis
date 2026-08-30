var _sway = sin(current_time * sway_speed + sway_offset) * 0.1;

var _prev = matrix_get(matrix_world);

var _mx = matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1);
_mx[4] = _sway;

matrix_set(matrix_world, matrix_multiply(_mx, _prev));

// чёрная обводка в 1 пиксель — рисуем со смещением в 4 стороны с тем же xscale, что и сам спрайт
var _offsets = [[-1,0],[1,0],[0,-1],[0,1]];
for (var i = 0; i < 4; i++) {
    draw_sprite_ext(sprite_index, image_index,
        _offsets[i][0], _offsets[i][1],
        -1, 1, 0, c_black, 1);
}

draw_sprite_ext(sprite_index, image_index, 0, 0, -1, 1, 0, make_color_rgb(0x00, 0xFF, 0x00), 1);

matrix_set(matrix_world, _prev);