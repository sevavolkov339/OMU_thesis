var _t = clamp((start_y - y) / max_height, 0, 1);
var _alpha = (1 - _t) * 0.6;
draw_sprite_ext(sprite_index, image_index, x, y, scale, scale, 0, c_white, _alpha);