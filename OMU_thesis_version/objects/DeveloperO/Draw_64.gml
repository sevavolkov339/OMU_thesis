// просто текст поверх экрана, без окна/спрайта, печатается построчно
var _saved = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_build_identity());
var cam = CameraControllerO.cam;
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);
var gx = round(x - cx);
var gy = round(y - cy);

draw_set_font(font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _lines_to_draw = min(current_line + 1, array_length(lines));
for (var _li = 0; _li < _lines_to_draw; _li++) {
    var _line_text = lines[_li];
    var _visible = (_li == current_line) ? visible_chars : string_length(_line_text);
    var _visible_str = string_copy(_line_text, 1, _visible);
    var _total_w = string_width(_visible_str);
    var _line_y = gy + _li * line_height;
    var _char_x = round(gx - _total_w * 0.5);

    var _cy_arr = line_char_y[_li];
    var _ca_arr = line_char_alpha[_li];

    for (var _i = 0; _i < _visible; _i++) {
        var _ch = string_char_at(_line_text, _i + 1);
        var _cy_off = (_i < array_length(_cy_arr)) ? _cy_arr[_i] : 0;
        var _ca = (_i < array_length(_ca_arr)) ? _ca_arr[_i] : 1;

        draw_set_alpha(_ca);
        draw_set_color(c_black);
        draw_text(_char_x + 1, _line_y + _cy_off,     _ch);
        draw_text(_char_x - 1, _line_y + _cy_off,     _ch);
        draw_text(_char_x,     _line_y + _cy_off + 1, _ch);
        draw_text(_char_x,     _line_y + _cy_off - 1, _ch);
        draw_set_color(c_white);
        draw_text(_char_x, _line_y + _cy_off, _ch);

        _char_x += string_width(_ch);
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
matrix_set(matrix_world, _saved);
draw_set_font(-1);
