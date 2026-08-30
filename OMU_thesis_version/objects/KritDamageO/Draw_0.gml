draw_set_font(MainFnt);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _total_w = string_width(text);
var _cx = x - _total_w * 0.5;

for (var i = 0; i < string_length(text); i++) {
    var _ch = string_char_at(text, i + 1);
    var _wave_y = sin(wave_timer + i * 0.5) * 2.5;
    var _chx = _cx;
    var _chy = y + _wave_y;

    draw_set_color(c_black);
    draw_text(_chx + 1, _chy,     _ch);
    draw_text(_chx - 1, _chy,     _ch);
    draw_text(_chx,     _chy + 1, _ch);
    draw_text(_chx,     _chy - 1, _ch);

    draw_set_color(text_color);
    draw_text(_chx, _chy, _ch);

    _cx += string_width(_ch);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
