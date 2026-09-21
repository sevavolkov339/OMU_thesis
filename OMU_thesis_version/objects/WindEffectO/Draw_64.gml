// рисуем в Draw GUI, чтобы полосы ветра были видны всегда, поверх всего

for (var i = 0; i < array_length(lines); i++) {
    var _l = lines[i];
    var _x2 = _l.x - lengthdir_x(_l.len, _l.dir);
    var _y2 = _l.y - lengthdir_y(_l.len, _l.dir);

    // плавно появляются и плавно пропадают
    var _p = 1 - (_l.life / _l.life_max);
    var _fade_in = clamp(_p / 0.4, 0, 1);
    var _fade_out = clamp((1 - _p) / 0.7, 0, 1);
    var _a = min(_fade_in, _fade_out) * wind_strength;
    if (_a <= 0.01) continue;

    draw_set_alpha(_a);
    // чёрная обводка в 1 пиксель, толще чёрная линия снизу, тоньше белая сверху
    draw_set_color(c_black);
    draw_line_width(_l.x, _l.y, _x2, _y2, 3);
    draw_set_color(c_white);
    draw_line_width(_l.x, _l.y, _x2, _y2, 1);
}

draw_set_alpha(1);
draw_set_color(c_white);
