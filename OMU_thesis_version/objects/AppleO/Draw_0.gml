var str = "+" + string(apple_count);
draw_set_font(MainFnt);

var apple_w = sprite_get_width(AppleS);
var apple_h = sprite_get_height(AppleS);
var text_w = string_width(str);
var text_h = string_height(str);
var total_w = text_w + 4 + apple_w;
var start_x = x - total_w * 0.5;
var text_y = y - text_h * 0.5 - 2;
var apple_x = start_x + text_w + 4;
var apple_y = y - apple_h * 0.5;

// обводка текста
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_set_alpha(1);
for (var _i = 0; _i < string_length(str); _i++) {
    var _ch = string_char_at(str, _i + 1);
    var _cx = start_x + string_width(string_copy(str, 1, _i));
    draw_text(_cx + 1, text_y, _ch);
    draw_text(_cx - 1, text_y, _ch);
    draw_text(_cx, text_y + 1, _ch);
    draw_text(_cx, text_y - 1, _ch);
}

// текст
draw_set_color(c_white);
for (var _i = 0; _i < string_length(str); _i++) {
    var _ch = string_char_at(str, _i + 1);
    var _cx = start_x + string_width(string_copy(str, 1, _i));
    draw_text(_cx, text_y, _ch);
}

// яблоко
draw_sprite(AppleS, 0, apple_x + sprite_get_xoffset(AppleS), apple_y + sprite_get_yoffset(AppleS));

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);