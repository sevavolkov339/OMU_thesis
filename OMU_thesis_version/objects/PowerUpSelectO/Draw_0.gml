var n = array_length(items);
for (var i = 0; i < n; i++) {
    var ix = center_x + (i - (n - 1) * 0.5) * spacing;
    var iy = center_y;
    var draw_scale = item_scale[i];
    var draw_float_x = item_float_x[i];
    var draw_float_y = item_float_y[i];
    var draw_angle = item_angle[i];
    var draw_alpha = 1;
    if (selection_done && selected_index == i) {
        draw_float_y = item_float_y[i] + exit_y_offset;
        draw_float_x = item_float_x[i] + exit_shake_x;
        draw_angle = 0;
        draw_alpha = 1;
    } else if (selection_done) {
        draw_alpha = max(item_scale[i], 0);
    }
    var col = merge_colour(c_black, c_white, item_white[i]);
	//глоу
	if (item_glow_alpha[i] > 0.01) {
	    var _gmx = matrix_build(ix + draw_float_x, iy + draw_float_y, 0, 0, 0, item_glow_angle[i], draw_scale, draw_scale, 1);
	    var _gprev = matrix_get(matrix_world);
	    matrix_set(matrix_world, matrix_multiply(_gmx, _gprev));
	    // чёрная обводка глоу
	    draw_sprite_ext(TransitionRoomGlowS, 0, -1,  0, 1, 1, 0, c_black, item_glow_alpha[i] * draw_alpha);
	    draw_sprite_ext(TransitionRoomGlowS, 0,  1,  0, 1, 1, 0, c_black, item_glow_alpha[i] * draw_alpha);
	    draw_sprite_ext(TransitionRoomGlowS, 0,  0, -1, 1, 1, 0, c_black, item_glow_alpha[i] * draw_alpha);
	    draw_sprite_ext(TransitionRoomGlowS, 0,  0,  1, 1, 1, 0, c_black, item_glow_alpha[i] * draw_alpha);
	    // сам глоу
	    draw_sprite_ext(TransitionRoomGlowS, 0, 0, 0, 1, 1, 0, c_white, item_glow_alpha[i] * draw_alpha);
	    matrix_set(matrix_world, _gprev);
	}
    // айтем
    var _mx = matrix_build(ix + draw_float_x, iy + draw_float_y, 0, 0, 0, draw_angle, draw_scale, draw_scale, 1);
    var _prev = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_mx, _prev));
    draw_sprite_ext(items[i].sprite, 0, 0, 0, 1, 1, 0, col, draw_alpha);
    matrix_set(matrix_world, _prev);

    // описание под наведённым павер апом — позиция фиксированная, не зависит от левитации/масштаба
    if (!selection_done && was_hovered[i]) {
        draw_item_description(items[i].description, ix, iy + 18);
    }

    // стрелка геймпада над выбранным павер апом — тоже фиксированная позиция, намного ниже/ближе к нему
    if (gp_active && gp_nav_active && !selection_done && i == gp_focus_index) {
        draw_gp_arrow(ix, iy - 20);
    }
}
// белый экран
var total_white = max(fade_white, exit_white);
if (total_white > 0) {
    var cam = CameraControllerO.cam;
    var cx = camera_get_view_x(cam);
    var cy = camera_get_view_y(cam);
    draw_set_alpha(total_white);
    draw_set_color(c_white);
    draw_rectangle(cx, cy, cx + CameraControllerO.view_w, cy + CameraControllerO.view_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}