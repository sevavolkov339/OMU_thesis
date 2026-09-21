if instance_exists(owner) {

// чёрная обводка в 1 пиксель, 4 смещённые чёрные копии под низом
var _offset = 1;
draw_sprite_ext(sprite_index, image_index, x - _offset, y, image_xscale, 1, 0, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x + _offset, y, image_xscale, 1, 0, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y - _offset, image_xscale, 1, 0, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y + _offset, image_xscale, 1, 0, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, 0, c_white, 1);

}