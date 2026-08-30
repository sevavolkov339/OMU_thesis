if (visible_scale < 0.01) exit;


// обводка
var _offset = 1;
draw_sprite_ext(sprite_index, image_index, x - _offset, y, image_xscale, image_yscale, image_angle, c_black, visible_scale);
draw_sprite_ext(sprite_index, image_index, x + _offset, y, image_xscale, image_yscale, image_angle, c_black, visible_scale);
draw_sprite_ext(sprite_index, image_index, x, y - _offset, image_xscale, image_yscale, image_angle, c_black, visible_scale);
draw_sprite_ext(sprite_index, image_index, x, y + _offset, image_xscale, image_yscale, image_angle, c_black, visible_scale);

// оригинал
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, visible_scale);

