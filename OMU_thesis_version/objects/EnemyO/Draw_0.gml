// обводка по позиции без shake
//draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_red, 1);
//draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_red, 1);
//draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_red, 1);
//draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, c_red, 1);

// спрайт с shake
//draw_sprite_ext(
// sprite_index
//);

walk_timer += walk_speed;

// тilt меняется по синусу, смена знака = "приземление"
var _tilt_raw = sin(walk_timer);
var _tilt = _tilt_raw * walk_tilt_amount;

// прыжок, между сменами угла (abs синуса)
var _bounce = abs(_tilt_raw);
var _y_off = -_bounce * walk_bounce_height;

// squash при приземлении (когда abs синуса близко к 0)
var _land = 1 - _bounce;
var _sx_walk = 1 + _land * 0.35;
var _sy_walk = 1 - _land * 0.25;

var _sx = image_xscale * _sx_walk;
var _sy = image_yscale * _sy_walk;
var _angle = image_angle + _tilt;
var _x = x + shake_offset_x;
var _y = y + shake_offset_y + _y_off;

draw_sprite_ext(sprite_index, image_index, _x, _y, _sx, _sy, _angle, c_white, image_alpha);