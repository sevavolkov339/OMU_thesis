//draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, make_color_rgb(0x77, 0xFF, 0x4C), 1); //FF51B3

// в мире 2 (спрайт с шарфом) цвет не подкрашиваем — только у обычной лягушки
var _tint = (sprite_index == BigFrogInScarfS) ? c_white : make_color_rgb(0x00, 0xFF, 0x00);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, _tint, 1)