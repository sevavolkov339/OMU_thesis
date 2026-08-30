draw_set_font(MainFnt);

// считаем общую ширину поп-апа (текстовые и спрайтовые части подряд)
var total_w = 0;
for (var i = 0; i < array_length(parts); i++) {
    var _p = parts[i];
    if (_p.type == "text") {
        total_w += string_width(_p.value);
    } else if (_p.type == "sprite") {
        total_w += sprite_get_width(_p.value);
    }
}

var cursor_x = x - total_w * 0.5;

draw_set_halign(fa_left);
draw_set_valign(fa_top);

for (var i = 0; i < array_length(parts); i++) {
    var _p = parts[i];

    if (_p.type == "text") {
        var _str = _p.value;
        var _text_h = string_height(_str);
        var _text_y = y - _text_h * 0.5;

        // обводка текста
        draw_set_color(c_black);
        for (var _c = 0; _c < string_length(_str); _c++) {
            var _ch = string_char_at(_str, _c + 1);
            var _cx = cursor_x + string_width(string_copy(_str, 1, _c));
            draw_text(_cx + 1, _text_y, _ch);
            draw_text(_cx - 1, _text_y, _ch);
            draw_text(_cx, _text_y + 1, _ch);
            draw_text(_cx, _text_y - 1, _ch);
        }

        // сам текст
        draw_set_color(c_white);
        for (var _c = 0; _c < string_length(_str); _c++) {
            var _ch = string_char_at(_str, _c + 1);
            var _cx = cursor_x + string_width(string_copy(_str, 1, _c));
            draw_text(_cx, _text_y, _ch);
        }

        cursor_x += string_width(_str);
    } else if (_p.type == "sprite") {
        var _spr = _p.value;
        var _sh = sprite_get_height(_spr);
        var _sy = y - _sh * 0.5;
        draw_sprite(_spr, 0, cursor_x + sprite_get_xoffset(_spr), _sy + sprite_get_yoffset(_spr) + 3);
        cursor_x += sprite_get_width(_spr);
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
