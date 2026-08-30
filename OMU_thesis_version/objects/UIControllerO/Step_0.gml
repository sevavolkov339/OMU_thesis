// ===== ДЫХАНИЕ И ПОКАЧИВАНИЕ ПОЛОСЫ =====
breath_timer += breath_speed;

bar_wobble_timer += 0.04;
var bar_wobble_target = sin(bar_wobble_timer) * bar_wobble_amplitude;
bar_wobble_speed += (bar_wobble_target - bar_wobble_angle) * bar_wobble_stiffness;
bar_wobble_speed *= bar_wobble_damping;
bar_wobble_angle += bar_wobble_speed;

// ===== АНИМАЦИИ СЕРДЕЦ =====
if (instance_exists(PlayerBallerO)) {
    var p2 = instance_find(PlayerBallerO, 0);

    // триггер сквоша при восстановлении хп
    if (p2.hp != prev_hp) {
        if (p2.hp > prev_hp && prev_hp >= 0) {
            for (var _hi = prev_hp; _hi < p2.hp; _hi++) {
                trigger_heart_squash(_hi);
            }
        }
        prev_hp = p2.hp;
    }

    // расширяем массивы если хп стало больше
    while (array_length(heart_scale_x) < p2.max_hp) {
        array_push(heart_scale_x, 1);
        array_push(heart_scale_y, 1);
        array_push(heart_scale_x_speed, 0);
        array_push(heart_scale_y_speed, 0);
    }

    // пружинная анимация каждого сердечка
    for (var _i = 0; _i < array_length(heart_scale_x); _i++) {
        var _dx = 1 - heart_scale_x[_i];
        heart_scale_x_speed[_i] += _dx * 0.25;
        heart_scale_x_speed[_i] *= 0.6;
        heart_scale_x[_i] += heart_scale_x_speed[_i];
        var _dy = 1 - heart_scale_y[_i];
        heart_scale_y_speed[_i] += _dy * 0.25;
        heart_scale_y_speed[_i] *= 0.6;
        heart_scale_y[_i] += heart_scale_y_speed[_i];
        if (_i < array_length(heart_angle)) {
            heart_angle_speed[_i] += (0 - heart_angle[_i]) * 0.3;
            heart_angle_speed[_i] *= 0.55;
            heart_angle[_i] += heart_angle_speed[_i];
        }
    }

    // плавный счётчик денег
    if (displayed_money != p2.money) {
        displayed_money = lerp(displayed_money, p2.money, 0.15);
        if (abs(displayed_money - p2.money) < 0.5) displayed_money = p2.money;
    }
}

// ===== АНИМАЦИИ ИНВЕНТАРЯ =====
if (instance_exists(InventoryControllerO)) {
    var inv2 = InventoryControllerO.items;
    var inv_count = array_length(inv2);

    // новый предмет — запускаем сквош
    if (inv_count > prev_inv_count) {
        trigger_inv_squash(inv_count - 1);
    }
    prev_inv_count = inv_count;

    while (array_length(inv_scale_x) < inv_count) {
        array_push(inv_scale_x, 1);
        array_push(inv_scale_y, 1);
        array_push(inv_scale_x_speed, 0);
        array_push(inv_scale_y_speed, 0);
    }

    for (var _i = 0; _i < inv_count; _i++) {
        var _dx = 1 - inv_scale_x[_i];
        inv_scale_x_speed[_i] += _dx * 0.3;
        inv_scale_x_speed[_i] *= 0.6;
        inv_scale_x[_i] += inv_scale_x_speed[_i];
        var _dy = 1 - inv_scale_y[_i];
        inv_scale_y_speed[_i] += _dy * 0.3;
        inv_scale_y_speed[_i] *= 0.6;
        inv_scale_y[_i] += inv_scale_y_speed[_i];
    }
}

if (!instance_exists(PlayerBallerO)) exit;
var p = instance_find(PlayerBallerO, 0);

// ===== ПЛАВНОЕ ПОЯВЛЕНИЕ UI =====
if (p.state == PlayerState.CUTSCENE and room != GameControllerO.room_chill) {
    ui_alpha = max(ui_alpha - ui_fade_speed, 0);
} else if (p.state == PlayerState.PLAY) {
    ui_alpha = min(ui_alpha + ui_fade_speed, 1);
}

// ===== АНИМАЦИЯ ЯБЛОКА =====
if (apple_pop_active) {
    apple_scale_x = lerp(apple_scale_x, apple_target_scale_x, apple_anim_speed);
    apple_scale_y = lerp(apple_scale_y, apple_target_scale_y, apple_anim_speed);
    apple_y_offset = lerp(apple_y_offset, apple_target_y_offset, apple_anim_speed);
    if (abs(apple_scale_x - apple_target_scale_x) < 0.01 &&
        abs(apple_scale_y - apple_target_scale_y) < 0.01) {
        apple_target_scale_x = 1;
        apple_target_scale_y = 1;
        apple_target_y_offset = 0;
        apple_pop_active = false;
    }
} else {
    apple_scale_x = lerp(apple_scale_x, 1, apple_anim_speed);
    apple_scale_y = lerp(apple_scale_y, 1, apple_anim_speed);
    apple_y_offset = lerp(apple_y_offset, 0, apple_anim_speed);
}

// ===== ПАУЗА =====
if (GameControllerO.game_paused) {
    pause_alpha = 1;
} else {
    pause_alpha = 0;
}

// ===== КОМБО =====
if (instance_exists(ComboControllerO)) {
    var cc = ComboControllerO;

    // комбо сброшено — показываем ноль с морганием
    if (cc.combo == 0 && cc.combo_bar == 0 && prev_combo > 0) {
        combo_show_zero = true;
        combo_zero_timer = combo_zero_duration;
        combo_zero_alpha = 1;
    }
    if (combo_zero_timer > 0) {
        combo_zero_timer--;
        combo_zero_alpha = combo_zero_timer / combo_zero_duration;
    } else {
        combo_show_zero = false;
        combo_zero_alpha = 0;
    }

    // новое значение комбо — запускаем анимацию
    if (cc.combo != prev_combo) {
        var strength = cc.combo;
        combo_scale = 1.0 + strength * 0.6;
        combo_scale_speed = strength * 0.4;
        combo_target_scale = 1;
        combo_angle_speed = choose(-1, 1) * (20 + strength * 18);
        prev_combo = cc.combo;
    }

    // пружинная анимация масштаба и угла
    var scale_diff = combo_target_scale - combo_scale;
    combo_scale_speed += scale_diff * combo_scale_stiffness;
    combo_scale_speed *= combo_scale_damping;
    combo_scale += combo_scale_speed;
    combo_angle_speed += (0 - combo_angle) * combo_angle_stiffness;
    combo_angle_speed *= combo_angle_damping;
    combo_angle += combo_angle_speed;

    // тряска пропорциональна уровню комбо
    var shake_amt = cc.combo * 0.4;
    combo_shake_x = random_range(-shake_amt, shake_amt);
    combo_shake_y = random_range(-shake_amt, shake_amt);

    // прозрачность комбо
    if (cc.combo >= 1) {
        combo_alpha = min(combo_alpha + combo_fade_speed, 1);
        combo_blink_active = false;
        combo_blink_timer = 0;
    } else if (combo_show_zero) {
        // мигание ускоряется к концу
        combo_blink_timer++;
        var blink_speed = floor(lerp(10, 2, 1 - (combo_zero_timer / combo_zero_duration)));
        combo_alpha = ((combo_blink_timer mod (blink_speed * 2)) < blink_speed) ? 1 : 0;
    } else {
        combo_alpha = 0;
        combo_blink_timer = 0;
    }
}

// ===== КНОПКА ГЛАЗА В ПАУЗЕ =====
pause_sway_timer += 0.03;
pause_wave_timer += 0.08;

// проверяем ховер только если пауза активна
var _pause_gp = instance_exists(PlayerBallerO) ? PlayerBallerO.gamepad_index : 0;
pause_gp_active = gamepad_is_connected(_pause_gp) && variable_global_exists("using_gamepad") && global.using_gamepad;
if (pause_alpha > 0.05 && !pause_transitioning) {
    var cam_p = CameraControllerO.cam;
    var cx_p = camera_get_view_x(cam_p);
    var cy_p = camera_get_view_y(cam_p);
    var _eye_screen_x = global.gameWidth * 0.5;
    var _eye_screen_y = global.gameHeight * 0.55;
    var _dist_p = point_distance(mouse_x - cx_p, mouse_y - cy_p, _eye_screen_x, _eye_screen_y);
    pause_hovered = (_dist_p < 30) || pause_gp_active;
} else {
    pause_hovered = false;
}

if (pause_hovered) {
    pause_eye_target_scale = 1.12;
} else {
    pause_eye_target_scale = 1.0;
}
pause_eye_scale = lerp(pause_eye_scale, pause_eye_target_scale, 0.15);

// триггер сквоша при наведении
if (pause_hovered && !pause_prev_hovered) pause_eye_squash_frame = 1;

// покадровый сквош
pause_eye_squash_timer += delta_time / 1000000;
if (pause_eye_squash_timer >= pause_eye_squash_step) {
    pause_eye_squash_timer -= pause_eye_squash_step;
    if (pause_eye_squash_frame > 0) pause_eye_squash_frame++;
    switch (pause_eye_squash_frame) {
        case 1: pause_eye_sx = 1.6;  pause_eye_sy = 0.4;  break;
        case 2: pause_eye_sx = 0.5;  pause_eye_sy = 1.7;  break;
        case 3: pause_eye_sx = 1.2;  pause_eye_sy = 0.85; break;
        case 4: pause_eye_sx = 1.0;  pause_eye_sy = 1.0;  pause_eye_squash_frame = 0; break;
    }
    pause_prev_hovered = pause_hovered;
}

// клик по глазу — выход в меню с сохранением
if (pause_hovered && !pause_transitioning && (mouse_check_button_pressed(mb_left) || (pause_gp_active && gamepad_button_check_pressed(_pause_gp, gp_face1)))) {
    pause_transitioning = true;
    if (instance_exists(FadeTransitionO)) {
        FadeTransitionO.fade_in(0.03);
    } else {
        var _f = instance_create_layer(0, 0, "DeadL", FadeTransitionO);
        _f.fade_progress = 0;
        _f.fade_in(0.03);
    }
    alarm_set(0, 30);
}