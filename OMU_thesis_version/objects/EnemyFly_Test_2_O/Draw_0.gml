// обводка по позиции без shake
//draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_red, 1);
//draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_red, 1);
//draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_red, 1);
//draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, c_red, 1);

// спрайт с shake
draw_sprite_ext(
    sprite_index,
    image_index,
    x + shake_offset_x,
    y + shake_offset_y,
    image_xscale,
    image_yscale,
    image_angle,
    c_white,
    image_alpha
);

if (path_exists(path)) {
    draw_set_alpha(0.8);
    draw_set_color(c_yellow);
    draw_path(path, 0, 0, true);
    draw_set_alpha(1);
}

// анимация ходьбы
//walk_timer += walk_speed;

// bounce - синус от 0 до 1 (только вверх)
//var _bounce = abs(sin(walk_timer));
//var _tilt = sin(walk_timer) * walk_tilt_amount;

// squash при приземлении (когда bounce близко к 0)
//var _grounded = 1 - _bounce;
//var _sx_walk = 1 + _grounded * 0.25;
//var _sy_walk = 1 - _grounded * 0.25;

//var _y_off = -_bounce * walk_bounce_height;

//var _sx = image_xscale * _sx_walk;
//var _sy = image_yscale * _sy_walk;
//var _angle = image_angle + _tilt;
//var _x = x + shake_offset_x;
//var _y = y + shake_offset_y + _y_off;

//draw_sprite_ext(sprite_index, image_index, _x, _y, _sx, _sy, _angle, c_white, image_alpha);
