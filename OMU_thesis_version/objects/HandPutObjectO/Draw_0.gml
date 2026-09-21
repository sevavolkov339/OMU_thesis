if (instance_exists(carried_inst)) {
    // рисуем объект под рукой если надо, он рисуется сам
}
// обводка как у HandGrabObjectO
var _offset = 1;
draw_sprite_ext(sprite_index, image_index, x - _offset, y, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x + _offset, y, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y - _offset, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y + _offset, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);