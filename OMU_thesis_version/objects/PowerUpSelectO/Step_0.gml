if (GameControllerO.game_paused) exit;
wave_text_timer += 0.08;
// въезд
if (!entry_done) {
    entry_y_spd += (entry_target_y - entry_y) * entry_stiffness;
    entry_y_spd *= entry_damping;
    entry_y += entry_y_spd;
    center_y = entry_y;
    if (abs(entry_y - entry_target_y) < 0.5 && abs(entry_y_spd) < 0.1) {
        entry_y = entry_target_y;
        center_y = entry_target_y;
        entry_done = true;
    }
}
center_x = room_width * 0.5;
var n = array_length(items);
var _old_x = x;
var _old_y = y;
var _prev_mask = mask_index;

var _gp = 0;
gp_active = gamepad_is_connected(_gp) && variable_global_exists("using_gamepad") && global.using_gamepad;

for (var i = 0; i < n; i++) {
    var ix = center_x + (i - (n - 1) * 0.5) * spacing;
    var iy = center_y;
    // проверка наводки
    x = ix;
    y = iy;
    mask_index = items[i].sprite;
    var hovered = position_meeting(mouse_x, mouse_y, id);
    x = _old_x;
    y = _old_y;
    mask_index = _prev_mask;
    if (gp_active) {
        hovered = gp_nav_active && (i == gp_focus_index);
    }
    // звук при наводе
    if (hovered && !was_hovered[i] && !selection_done) {
        var _snd = audio_play_sound(HoverWhiteTransitionRoom_Snd, 0, false);
        audio_sound_pitch(_snd, random_range(0.85, 1.15));
    }
    was_hovered[i] = hovered;
    // качание при hover
    var angle_target = hovered ? sin(current_time * 0.005 + i) * 15 : 0;
    item_angle_spd[i] += (angle_target - item_angle[i]) * 0.25;
    item_angle_spd[i] *= 0.6;
    item_angle[i] += item_angle_spd[i];
    // цвет — выбранный остаётся белым
    if (selection_done && selected_index == i) {
        item_white[i] = 1;
    } else if (selection_done && selected_index != i) {
        item_white[i] = lerp(item_white[i], -1, 0.15);
        item_scale[i] = lerp(item_scale[i], 0, 0.15);
    } else {
        var white_target = hovered ? 1 : 0;
        item_white[i] = lerp(item_white[i], white_target, 0.25);
    }
    // клик
	if (!selection_done && hovered && !gp_active && mouse_check_button_pressed(mb_left)) {
	    select_powerup(i);
	}
    // масштаб — выбранный не увеличивается
    if (!selection_done) {
        var scale_target = hovered ? 1 : 0.5;
        item_scale_spd[i] += (scale_target - item_scale[i]) * 0.3;
        item_scale_spd[i] *= 0.6;
        item_scale[i] += item_scale_spd[i];
    } else if (selected_index != i) {
        // не выбранные уменьшаются
        item_scale_spd[i] += (0 - item_scale[i]) * 0.3;
        item_scale_spd[i] *= 0.6;
        item_scale[i] += item_scale_spd[i];
    }
    // левитация
    item_float_timer[i] += 0.02;
    item_float_x[i] = sin(item_float_timer[i] * 0.7 + i * 1.3) * 2;
    item_float_y[i] = cos(item_float_timer[i] * 0.5 + i * 2.1) * 2.5;
	// глоу
	if (selection_done && selected_index == i) {
	    item_glow_alpha[i] = lerp(item_glow_alpha[i], 0, 0.15); // быстро фейдится
	} else if (!selection_done) {
	    var glow_target = hovered ? 1 : 0;
	    item_glow_alpha[i] = lerp(item_glow_alpha[i], glow_target, hovered ? 0.15 : 0.4);
	} else {
	    item_glow_alpha[i] = lerp(item_glow_alpha[i], 0, 0.4);
	}
	item_glow_angle[i] += 0.5;
}

// геймпад — навигация влево/вправо и подтверждение кнопкой A
// пока павер апы поднимаются снизу — выбирать нельзя вовсе
if (gp_active && !selection_done && entry_done) {
    var _nav_x = gp_read_nav(_gp);
    var _nav_edge = (_nav_x != 0) && (gp_prev_nav_x == 0);
    gp_prev_nav_x = _nav_x;
    if (_nav_edge) {
        if (!gp_nav_active) {
            // первое нажатие влево/вправо просто включает выбор, стартуя с центрального павер апа
            gp_nav_active = true;
            gp_focus_index = floor((n - 1) * 0.5);
        } else {
            gp_focus_index = clamp(gp_focus_index + _nav_x, 0, n - 1);
        }
    }
    if (gp_nav_active && gamepad_button_check_pressed(_gp, gp_face1)) {
        select_powerup(gp_focus_index);
    }
}

// exit анимация — тряска и подъём одновременно
if (selection_done) {
    // тряска
    if (exit_shake_timer > 0) {
        exit_shake_timer--;
        exit_shake_x = random_range(-4, 4);
        if (exit_shake_timer == 0 && instance_exists(white_fade)) {
            white_fade.start_fade(0.02);
        }
    } else {
        exit_shake_x = 0;
    }
    // подъём всегда
    exit_y_spd -= 0.4;
    exit_y_offset += exit_y_spd;
    // смена комнаты
    if (instance_exists(white_fade) && white_fade.fade_done) {
        GameControllerO.change_room();
    }
}
fade_white = max(fade_white - fade_speed, 0);