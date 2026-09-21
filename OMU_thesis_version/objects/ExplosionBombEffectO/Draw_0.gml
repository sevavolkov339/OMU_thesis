// волна, кольцо с обводкой
if (wave_alpha > 0) {
    draw_set_alpha(wave_alpha);
    // черная обводка кольца (снаружи и внутри)
    draw_set_color(c_black);
    for (var _i = 0; _i < wave_width + 2; _i++) {
        draw_circle(x, y, wave_radius + _i - 1, true);
    }
    // белое кольцо
    draw_set_color(c_white);
    for (var _i = 0; _i < wave_width; _i++) {
        draw_circle(x, y, wave_radius + _i, true);
    }
    // внутренняя обводка
    draw_set_color(c_black);
    draw_circle(x, y, wave_radius - 1, true);
}

// основной круг с обводкой
if (!blinking) {
    draw_set_alpha(1);
    // обводка
    draw_set_color(c_black);
    draw_circle(x, y, radius + 1, false);
    // круг
    draw_set_color(c_white);
    draw_circle(x, y, radius, false);
} else {
    var _blink = (blink_timer mod 4) < 2;
    if (_blink) {
        var _a = 1 - blink_timer / blink_duration;
        draw_set_alpha(_a);
        // обводка
        draw_set_color(c_black);
        draw_circle(x, y, radius + 1, false);
        // круг
        draw_set_color(c_white);
        draw_circle(x, y, radius, false);
    }
}
draw_set_alpha(1);