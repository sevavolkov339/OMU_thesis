// текст берём по id, как и остальные тексты в игре (Text() -> BallerDialogues.csv)
text_id = "World_2_Title_2";
var _full = Text(text_id);
var _parts = string_split(_full, "|");
part1 = array_length(_parts) > 0 ? _parts[0] : "";
part2 = array_length(_parts) > 1 ? _parts[1] : "";

font1 = MainFnt; // первая часть, крупный шрифт
font2 = SmallFnt; // вторая часть, мелкий шрифт

phase = "intro_delay"; // intro_delay -> typing1 -> pause -> typing2 -> done

// задержка перед началом печати текста
intro_delay_duration = round(room_speed * 1);
intro_delay_timer = 0;

// печать первой части
print_speed1 = 4; // кадров на букву
print_timer1 = 0;
visible_chars1 = 0;

// печать второй части
print_speed2 = 3;
print_timer2 = 0;
visible_chars2 = 0;

// пауза между частями
pause_duration = round(room_speed * 3);
pause_timer = 0;

// пауза после того, как весь текст дописан, после неё сообщаем GameControllerO
post_done_duration = round(room_speed * 3);
post_done_timer = 0;

// тряска букв первой части, сильная, но быстро затухающая
char1_shake_timer = [];
char1_shake_duration = round(room_speed * 0.35);
char1_shake_strength = 10;

// тряска букв второй части, послабее
char2_shake_timer = [];
char2_shake_duration = round(room_speed * 0.3);
char2_shake_strength = 4;

wave_timer = 0;
wave_amplitude = 2.5;
wave_speed_per_char = 0.5;

function draw_typed_wave_text(_str, _visible_chars, _shake_timers, _shake_duration, _shake_strength, _font, _cx, _cy) {
    if (_visible_chars <= 0) exit;

    draw_set_font(_font);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _visible_str = string_copy(_str, 1, _visible_chars);
    var _total_w = string_width(_visible_str);
    var _draw_x = _cx - _total_w * 0.5;

    for (var _i = 0; _i < _visible_chars; _i++) {
        var _ch = string_char_at(_str, _i + 1);

        // волна, общая для всех видимых букв
        var _wave_y = sin(wave_timer + _i * wave_speed_per_char) * wave_amplitude;

        // тряска, только для недавно появившихся букв, быстро гаснет
        var _shake_x = 0;
        var _shake_y = 0;
        if (_i < array_length(_shake_timers) && _shake_timers[_i] > 0) {
            var _t = _shake_timers[_i] / _shake_duration;
            var _cur = _shake_strength * _t * _t; // квадратичное затухание, быстро угасает
            _shake_x = random_range(-_cur, _cur);
            _shake_y = random_range(-_cur, _cur);
        }

        var _chx = _draw_x + _shake_x;
        var _chy = _cy + _wave_y + _shake_y;

        draw_set_color(c_black);
        draw_text(_chx + 1, _chy,     _ch);
        draw_text(_chx - 1, _chy,     _ch);
        draw_text(_chx,     _chy + 1, _ch);
        draw_text(_chx,     _chy - 1, _ch);
        draw_set_color(c_white);
        draw_text(_chx, _chy, _ch);

        _draw_x += string_width(_ch);
    }

    draw_set_font(-1);
    draw_set_color(c_white);
}
