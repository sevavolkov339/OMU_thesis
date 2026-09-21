//var _world_prev = matrix_get(matrix_world);
//matrix_set(matrix_world, matrix_build_identity());

//matrix_set(matrix_world, matrix_build_identity());

//var cam = CameraControllerO.cam;
//var cx = camera_get_view_x(cam);
//var cy = camera_get_view_y(cam);
//var gx = mouse_x - cx;
//var gy = mouse_y - cy;


//draw_sprite_ext(
// sprite_index
//);



// tooltip
//if (room == World_1_Store && tooltip_item != undefined) {
//    draw_set_font(MainFnt);
//    var price_str = string(tooltip_item.cost);
//    var apple_w = sprite_get_width(AppleBlackIconS);
//    var apple_h = sprite_get_height(AppleBlackIconS);
//    var text_w = string_width(price_str);
//    var pad = 4;
//    var tip_w = apple_w + 2 + text_w + pad * 2;
//    var tip_h = 16;
//    var tip_x = gx + 10;
//    var tip_y = gy - tip_h - 4;
//    var tip_cx = tip_x + tip_w * 0.5;
//    var tip_cy = tip_y + tip_h * 0.5;

//    var _tmx = matrix_build(tip_cx, tip_cy, 0, 0, 0, 0, tooltip_scale_x, tooltip_scale_y, 1);
//    var _tprev = matrix_get(matrix_world);
//    matrix_set(matrix_world, matrix_multiply(_tmx, _tprev));

//    var lx = -tip_w * 0.5;
//    var ly = -tip_h * 0.5;

// фон
//    draw_set_alpha(1);
//    draw_set_color(c_white);
//    draw_rectangle(lx, ly, lx + tip_w, ly + tip_h, false);

// обводка
//    draw_set_color(c_black);
//    draw_rectangle(lx - 0.08, ly - 0.08, lx + tip_w + 0.08, ly, false);
//    draw_rectangle(lx - 0.08, ly + tip_h, lx + tip_w + 0.08, ly + tip_h + 0.08, false);
//    draw_rectangle(lx - 0.08, ly, lx, ly + tip_h, false);
//    draw_rectangle(lx + tip_w, ly, lx + tip_w + 0.08, ly + tip_h, false);

// яблоко
//    draw_sprite_ext(AppleBlackIconS, 0,
// lx + pad + sprite_get_xoffset(AppleBlackIconS)
//        sprite_get_yoffset(AppleBlackIconS) - apple_h * 0.5 + 1,
//        1, 1, 0, c_white, 1);

// цена
//    draw_set_color(c_black);
//    draw_set_halign(fa_left);
//    draw_set_valign(fa_middle);
//    draw_text(lx + pad + apple_w + 2, 1, price_str);

//    matrix_set(matrix_world, _tprev);

//    draw_set_halign(fa_left);
//    draw_set_valign(fa_top);
//    draw_set_alpha(1);
//}

//matrix_set(matrix_world, _world_prev);