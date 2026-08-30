var _saved = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_build_identity());
var cam = CameraControllerO.cam;
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);
// бабл
if (bubble_scale_x > 0.05 && bubble_scale_y > 0.05) {
    draw_set_font(SmallFnt);
    var pad = bubble_pad;
    var tail_h = sprite_get_height(TextBubbleTailS);
    var gx = round(x - cx);
    var gy = round(y - cy);
    var bw = max(round(bubble_current_w), 4);
    var bh = bubble_h;
    var bcx = gx;
    var bcy = round(gy - bh * 0.5 - tail_h - 16);
    var _bmx = matrix_build(bcx, bcy, 0, 0, 0, 0, bubble_scale_x, bubble_scale_y, 1);
    var _bprev = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_bmx, _bprev));
    var lx = (-bw * 0.5) - 1;
    var ly = -bh * 0.5;
    draw_set_alpha(1);
    // внешняя черная обводка
    draw_set_color(c_black);
    draw_rectangle(lx - 2, ly - 2, lx + bw + 2, ly + bh + 2, false);
    // белая обводка
    draw_set_color(c_white);
    draw_rectangle(lx - 1, ly - 1, lx + bw + 1, ly + bh + 1, false);
    // черный фон
    draw_set_color(c_black);
    draw_rectangle(lx, ly, lx + bw, ly + bh, false);
    draw_sprite_ext(TextBubbleTailS, 0,
        -17.5,
        ly + bh + 17,
        1, 1, 0, c_white, 1);
    matrix_set(matrix_world, _bprev);
    matrix_set(matrix_world, matrix_build_identity());
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var visible_str = string_copy(bubble_current_text, 1, bubble_visible_chars);
    var total_w = string_width(visible_str);
    var char_draw_x = round(bcx - total_w * 0.5);
    var char_draw_y = round(bcy - string_height("A") * 0.5);
    for (var _i = 0; _i < string_length(visible_str); _i++) {
        var _ch = string_char_at(visible_str, _i + 1);
        var _cy_off = (_i < array_length(bubble_char_y)) ? bubble_char_y[_i] : 0;
        var _ca = (_i < array_length(bubble_char_alpha)) ? bubble_char_alpha[_i] : 1;
        draw_set_alpha(_ca * bubble_scale_y);
        // черная обводка текста
        draw_set_color(c_black);
        draw_text(char_draw_x + 1, char_draw_y + _cy_off, _ch);
        draw_text(char_draw_x - 1, char_draw_y + _cy_off, _ch);
        draw_text(char_draw_x, char_draw_y + _cy_off + 1, _ch);
        draw_text(char_draw_x, char_draw_y + _cy_off - 1, _ch);
        // белый текст
        draw_set_color(c_white);
        draw_text(char_draw_x, char_draw_y + _cy_off, _ch);
        char_draw_x += string_width(_ch);
    }
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
matrix_set(matrix_world, _saved);
draw_set_font(-1);