var _t = clamp(life / life_max, 0, 1);
var _alpha = (1 - _t) * 0.75;
draw_sprite_ext(sprite_index, image_index, x, y, scale, scale, 0, c_white, _alpha);
