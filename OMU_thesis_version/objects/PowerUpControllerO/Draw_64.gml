//var n = array_length(powerups);
//if (n == 0) exit;

//var _gui_w = display_get_gui_width();
//var _start_x = _gui_w - 16; // отступ от правого края
//var _start_y = 24; // отступ сверху
//var _spacing = 18; // расстояние между иконками

//for (var i = 0; i < n; i++) {
//    var _ix = _start_x - i * _spacing;
//    var _iy = _start_y;
//    // тень/обводка
//    draw_sprite_ext(powerups[i].sprite, 0, _ix - 1, _iy, 1, 1, 0, c_black, 1);
//    draw_sprite_ext(powerups[i].sprite, 0, _ix + 1, _iy, 1, 1, 0, c_black, 1);
//    draw_sprite_ext(powerups[i].sprite, 0, _ix, _iy - 1, 1, 1, 0, c_black, 1);
//    draw_sprite_ext(powerups[i].sprite, 0, _ix, _iy + 1, 1, 1, 0, c_black, 1);
//    // иконка
//    draw_sprite_ext(powerups[i].sprite, 0, _ix, _iy, 1, 1, 0, c_white, 1);
//}