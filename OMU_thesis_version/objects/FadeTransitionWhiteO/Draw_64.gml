var _w = display_get_gui_width();
var _h = display_get_gui_height();

if (!surface_exists(fade_surface)) {
    fade_surface = surface_create(_w, _h);
}

surface_set_target(fade_surface);
draw_clear_alpha(c_white, 0);

// рисуем дизер по всему экрану
var threshold = fade_progress * 16;
for (var _y = 0; _y < _h; _y++) {
    for (var _x = 0; _x < _w; _x++) {
        var bayer_val = bayer[(_x mod 4) + (_y mod 4) * 4];
        if (bayer_val < threshold) {
            draw_set_color(c_white);
            draw_point(_x, _y);
        }
    }
}

surface_reset_target();
draw_surface(fade_surface, 0, 0);
draw_set_color(c_white);