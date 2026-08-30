if (GameControllerO.game_paused) exit;
sway_timer += 0.03;
wave_text_timer += 0.08;
// анимация появления
appear_timer += delta_time / 1000000;
for (var _ri = 0; _ri < array_length(row_alphas); _ri++) {
    if (appear_timer > row_delays[_ri]) {
        row_alphas[_ri] = min(row_alphas[_ri] + 0.04, 1);
        row_offset_y_spd[_ri] += (0 - row_offset_y[_ri]) * 0.1;
        row_offset_y_spd[_ri] *= 0.78;
        row_offset_y[_ri] += row_offset_y_spd[_ri];
        row_float_timer[_ri] += 0.03;
    }
}
// счётчик
if (appear_timer > row_delays[0]) {
    counter_progress = min(counter_progress + counter_speed, 1);
    counter_time  = run_time * counter_progress;
    counter_money = round(money * counter_progress);
}
// hover глаза
var _gp = 0;
gp_active = gamepad_is_connected(_gp) && variable_global_exists("using_gamepad") && global.using_gamepad;
var _dist = point_distance(mouse_x, mouse_y, eye_x, eye_y);
hovered = (_dist < 30) || gp_active;
if (hovered) {
    eye_target_scale = 1.12;
} else {
    eye_target_scale = 1.0;
}
eye_scale = lerp(eye_scale, eye_target_scale, 0.15);
if (hovered && !prev_hovered) eye_squash_frame = 1;
squash_timer += delta_time / 1000000;
if (squash_timer >= squash_step) {
    squash_timer -= squash_step;
    if (eye_squash_frame > 0) eye_squash_frame++;
    switch (eye_squash_frame) {
        case 1: eye_sx = 1.6;  eye_sy = 0.4;  break;
        case 2: eye_sx = 0.5;  eye_sy = 1.7;  break;
        case 3: eye_sx = 1.2;  eye_sy = 0.85; break;
        case 4: eye_sx = 1.0;  eye_sy = 1.0;  eye_squash_frame = 0; break;
    }
    prev_hovered = hovered;
}
if ((mouse_check_button_pressed(mb_left) && hovered) || (gp_active && gamepad_button_check_pressed(_gp, gp_face1))) {
    // сохраняем цветы
    GameControllerO.total_flowers += money;
    // удаляем сейв так как ран закончился смертью
    if (GameControllerO.save_slot >= 0) {
        GameControllerO.delete_save(GameControllerO.save_slot);
    }
    // сбрасываем ран
    GameControllerO.reset_run();
    GameControllerO.save_slot = -1;
    // переход как между уровнями
    if (instance_exists(FadeTransitionO)) {
	    FadeTransitionO.fade_in(0.03);
	} else {
	    var _f = instance_create_layer(0, 0, "DeadL", FadeTransitionO);
	    _f.fade_progress = 0;
	    _f.fade_in(0.03);
	}
    alarm_set(0, 30);
}