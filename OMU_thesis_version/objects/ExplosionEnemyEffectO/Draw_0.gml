

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