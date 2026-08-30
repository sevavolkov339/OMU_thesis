draw_set_font(SmallFnt);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _cx = x;
var _y = y - 60;
var _line_h = 20;
var _icon_size = 16;
var _icon_gap = 3;

// TIME — строка 0
var _a0 = row_alphas[0];
var _off0 = row_offset_y[0];
var _fl0 = sin(row_float_timer[0] * 0.5) * 1.5;
if (_a0 > 0) {
    draw_wave_text(format_time(counter_time), _cx, _y - _off0 + _fl0, _a0);
}
_y += _line_h;

// MONEY — строка 1
var _a1 = row_alphas[1];
var _off1 = row_offset_y[1];
var _fl1 = sin(row_float_timer[1] * 0.5) * 1.5;
if (_a1 > 0) {
    var _money_str = "+" + string(counter_money);
    draw_set_font(SmallFnt);
    var _tw = string_width(_money_str);
    var _iw = _icon_size;
    var _gap = 2;
    var _total = _tw + _gap + _iw;
    var _sx = _cx - _total * 0.5;
    var _ty = _y - _off1 + _fl1;
    draw_set_alpha(_a1);
    // иконка двигается вместе с волной — берём среднюю волну текста
    var _wave_y = sin(wave_text_timer + string_length(_money_str) * 0.25) * 2.5;
    draw_sprite_ext(AppleS, 0,
        _sx + _tw + _gap + _iw * 0.5,
        _ty + _wave_y + 5,
        1, 1, 0, c_white, _a1);
    draw_wave_text(_money_str, _sx + _tw * 0.5, _ty, _a1);
}
_y += _icon_size + 4;

// ITEMS — строка 2
var _a2 = row_alphas[2];
var _off2 = row_offset_y[2];
var _fl2 = sin(row_float_timer[2] * 0.5) * 1.5;
if (_a2 > 0 && array_length(items_list) > 0) {
    var _n = array_length(items_list);
    var _icons_w = _n * _icon_size + (_n - 1) * _icon_gap;
    var _start_x = _cx - _icons_w * 0.5;
    for (var i = 0; i < _n; i++) {
        var _ix = _start_x + i * (_icon_size + _icon_gap) + _icon_size * 0.5;
        var _wave_i = sin(wave_text_timer + i * 0.5) * 2.5;
        var _iy = _y + _icon_size * 0.5 - _off2 + _fl2 + _wave_i;
        if (sprite_exists(items_list[i].sprite)) {
            draw_sprite_ext(items_list[i].sprite, 0, _ix, _iy, 1, 1, 0, c_white, _a2);
        }
    }
    _y += _icon_size + 8;
}

// POWER UPS — строка 3
var _a3 = row_alphas[3];
var _off3 = row_offset_y[3];
var _fl3 = sin(row_float_timer[3] * 0.5) * 1.5;
if (_a3 > 0 && array_length(powerups_list) > 0) {
    var _n = array_length(powerups_list);
    var _icons_w = _n * _icon_size + (_n - 1) * _icon_gap;
    var _start_x = _cx - _icons_w * 0.5;
    for (var i = 0; i < _n; i++) {
        var _ix = _start_x + i * (_icon_size + _icon_gap) + _icon_size * 0.5;
        var _wave_i = sin(wave_text_timer + i * 0.5) * 2.5;
        var _iy = _y + _icon_size * 0.5 - _off3 + _fl3 + _wave_i;
        if (sprite_exists(powerups_list[i].sprite)) {
            var _pu_frame = min(1, sprite_get_number(powerups_list[i].sprite) - 1);
            draw_sprite_ext(powerups_list[i].sprite, _pu_frame, _ix, _iy, 1, 1, 0, c_white, _a3);
        }
    }
    _y += _icon_size + 8;
}


_y += 20;
// ГЛАЗ — строка 4
var _a4 = row_alphas[4];
var _off4 = row_offset_y[4];
if (_a4 > 0) {
    var _eye_sway_x = sin(sway_timer * 0.7) * 2;
    var _eye_sway_y = sin(sway_timer * 0.5) * 2;
    var _eye_color = hovered ? make_colour_rgb(255, 255, 0) : c_white;
    draw_set_alpha(_a4);
    draw_sprite_ext(EyeMenuS, 1,
        eye_x + _eye_sway_x,
        eye_y + _eye_sway_y + _off4,
        eye_scale * eye_sx,
        eye_scale * eye_sy,
        0, _eye_color, _a4);
    if (hovered) {
        var _eh = sprite_get_height(EyeMenuS) * 0.5 - 90;
        draw_wave_text(eye_text,
            eye_x + _eye_sway_x,
            eye_y + _eye_sway_y + _off4 + _eh,
            _a4);
    }

    if (gp_active) {
        var _arrow_frame = (current_time mod (sprite_get_number(UI_ControllerArrowS) * 100)) / 100;
        var _arrow_x = eye_x + _eye_sway_x;
        var _arrow_y = eye_y + _eye_sway_y + _off4 - 20;
        var _ao = 1;
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x - _ao, _arrow_y, 1, 1, 0, c_black, _a4);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x + _ao, _arrow_y, 1, 1, 0, c_black, _a4);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x, _arrow_y - _ao, 1, 1, 0, c_black, _a4);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x, _arrow_y + _ao, 1, 1, 0, c_black, _a4);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x, _arrow_y, 1, 1, 0, c_white, _a4);
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_color(c_white);