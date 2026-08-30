//if (!instance_exists(PlayerBallerO)) exit;
//if (ui_alpha <= 0) exit;
//draw_set_alpha(ui_alpha);
//var p = instance_find(PlayerBallerO, 0);
//// ===== НАСТРОЙКИ =====
//var margin  = ui_margin;
//var spacing = heart_spacing;
//// ===== СЕРДЦА (ТОЛЬКО HP) =====
//for (var i = 0; i < p.hp; i++)
//{
//    var ui_x = margin + i * spacing;
//    var ui_y = margin;
//    draw_sprite(heart_sprite, 0, ui_x, ui_y);
//}
//// ===== ДЕНЬГИ =====
//var money_y = margin + sprite_get_height(heart_sprite) + space_between;
//// иконка яблока
//draw_sprite_ext(
//    apple_sprite,
//    0,
//    margin,
//    money_y + apple_y_offset,
//    apple_scale_x,
//    apple_scale_y,
//    0,
//    c_white,
//    1
//);
//// ===== ТЕКСТ ДЕНЕГ =====
//draw_set_font(MainFnt);
//draw_set_color(c_white);
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);
//draw_text(
//    margin + sprite_get_width(apple_sprite) + money_spacing,
//    money_y - 6.1,
//    string(p.money)
//);
//// =======================
//// PAUSE MENU
//// =======================
//if (pause_alpha > 0)
//{
//    var vw = display_get_gui_width();
//    var vh = display_get_gui_height();
//    draw_set_alpha(pause_alpha * 0.8);
//    draw_set_color(c_black);
//    draw_rectangle(0, 0, vw, vh, false);
//    draw_set_alpha(pause_alpha);
//    draw_set_color(c_white);
//    draw_set_font(MainFnt);
//    draw_set_halign(fa_center);
//    draw_set_valign(fa_middle);
//    draw_text(vw * 0.5, vh * 0.45, "PAUSED");
//    draw_text(vw * 0.5, vh * 0.55, "Press ESC to continue");
//    draw_set_alpha(1);
//    draw_set_halign(fa_left);
//    draw_set_valign(fa_top);
//}
//// ===== COMBO =====
//if (instance_exists(ComboControllerO) && combo_alpha > 0) {
//    var cc = ComboControllerO;
//    var bar_w = 50;
//    var bar_h = 8;
//    var bar_x = combo_bar_x;
//    var bar_y = combo_bar_y;
//    // заполненная часть
//    var filled = bar_w * cc.combo_bar;
//    if (filled > 0) {
//        draw_set_alpha(combo_alpha);
//        draw_set_color(c_white);
//        draw_rectangle(bar_x - filled, bar_y, bar_x + filled, bar_y + bar_h, false);
//    }
//    // число комбо с анимацией + обводка
//    var combo_text = "";
//    if (cc.combo >= 1) {
//        combo_text = string(cc.combo) + "x";
//    } else if (combo_show_zero) {
//        combo_text = "0";
//    }
//    if (combo_text != "") {
//        var tx = bar_x + combo_shake_x;
//        var ty = bar_y + (bar_h * 0.5) + combo_shake_y;
//        draw_set_font(MainFnt);
//        draw_set_halign(fa_center);
//        draw_set_valign(fa_middle);
//        // alpha: для нуля используем combo_zero_alpha, для остального combo_alpha
//        var text_alpha = (combo_show_zero && cc.combo == 0) ? combo_zero_alpha : combo_alpha;
//        draw_set_alpha(text_alpha);
//        var _mx = matrix_build(tx, ty, 0, 0, 0, combo_angle, combo_scale, combo_scale, 1);
//        var _prev = matrix_get(matrix_world);
//        matrix_set(matrix_world, matrix_multiply(_mx, _prev));
//        // обводка
//        draw_set_color(c_black);
//        draw_text( 1,  0, combo_text);
//        draw_text(-1,  0, combo_text);
//        draw_text( 0,  1, combo_text);
//        draw_text( 0, -1, combo_text);
//        // основной текст
//        draw_set_color(c_white);
//        draw_text(0, 0, combo_text);
//        matrix_set(matrix_world, _prev);
//        draw_set_halign(fa_left);
//        draw_set_valign(fa_top);
//    }
//}
//// сброс
//draw_set_alpha(1);
//draw_set_font(-1);
//draw_set_color(c_white);
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);