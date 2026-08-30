var _sway = sin(current_time * sway_speed + sway_offset) * 0.1;

var _prev = matrix_get(matrix_world);

var _mx = matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1);
_mx[4] = _sway;

matrix_set(matrix_world, matrix_multiply(_mx, _prev));

draw_sprite_ext(sprite_index, image_index, 0, 0, 1, 1, 0, make_color_rgb(0x77, 0xFF, 0x4C), 1); 

matrix_set(matrix_world, _prev);