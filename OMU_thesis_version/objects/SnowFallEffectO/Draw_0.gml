for (var i = 0; i < array_length(flakes); i++) {
    var _f = flakes[i];
    var _spr = _f.is_flake ? SnowFlakeS : SnowBallsS;
    var _frame = _f.frame;
    var _fx = _f.base_x + sin(_f.sway_phase) * _f.sway_amplitude;
    var _fy = _f.y;

    // чёрная обводка в 1 пиксель
    draw_sprite_ext(_spr, _frame, _fx - 1, _fy,     1, 1, 0, c_black, 1);
    draw_sprite_ext(_spr, _frame, _fx + 1, _fy,     1, 1, 0, c_black, 1);
    draw_sprite_ext(_spr, _frame, _fx,     _fy - 1, 1, 1, 0, c_black, 1);
    draw_sprite_ext(_spr, _frame, _fx,     _fy + 1, 1, 1, 0, c_black, 1);
    // сама снежинка/снег поверх
    draw_sprite_ext(_spr, _frame, _fx, _fy, 1, 1, 0, c_white, 1);
}
