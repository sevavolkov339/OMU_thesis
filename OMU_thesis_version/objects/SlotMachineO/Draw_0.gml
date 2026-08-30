draw_self();

// конфети
for (var _i = 0; _i < array_length(confetti); _i++) {
    var c = confetti[_i];
    var _mx = matrix_build(c.x, c.y, 0, 0, 0, c.angle, 1, 1, 1);
    var _prev = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_mx, _prev));
    
    // обводка
    draw_set_alpha(c.alpha);
    draw_set_color(c_black);
    draw_rectangle(-c.w * 0.5 - 1, -c.h * 0.5 - 1, c.w * 0.5 + 1, c.h * 0.5 + 1, false);
    
    // сама конфетина
    draw_set_color(c.col);
    draw_rectangle(-c.w * 0.5, -c.h * 0.5, c.w * 0.5, c.h * 0.5, false);
    
    matrix_set(matrix_world, _prev);
}

//draw_set_color(c_red);
//draw_circle(x, origin_y - 30, 3, false);
//draw_set_color(c_white);

//draw_set_font(MainFnt);
//draw_set_color(c_red);
//draw_text(x, y - 40, layer_get_name(layer));
//draw_set_color(c_white);

draw_set_alpha(1);
draw_set_color(c_white);