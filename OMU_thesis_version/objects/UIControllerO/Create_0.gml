// ===== UI ОТСТУПЫ И СПРАЙТЫ =====
pause_alpha = 0;
pause_fade_speed = 0.12;
ui_margin = 15; // отступ от края экрана
heart_spacing = 15; // расстояние между сердечками
heart_sprite = HealthS;
space_between = 5; // отступ между сердцами и деньгами
apple_sprite = AppleS;
money_spacing = 0; // отступ между яблоком и текстом денег
ui_alpha = 0; // текущая прозрачность UI
ui_fade_speed = 0.08; // скорость появления/исчезновения UI

// ===== АНИМАЦИЯ ЯБЛОКА =====
apple_scale_x = 1;
apple_scale_y = 1;
apple_target_scale_x = 1;
apple_target_scale_y = 1;
apple_y_offset = 0;
apple_target_y_offset = 0;
apple_anim_speed = 0.5;
apple_pop_scale_x = 0.7; // сжатие по x при подпрыгивании
apple_pop_scale_y = 1.5; // растяжение по y при подпрыгивании
apple_pop_y_offset = -10; // смещение вверх при подпрыгивании
apple_pop_active = false;

// ===== КОМБО =====
combo_blink_active = false;
combo_blink_timer = 0;
combo_scale = 1;
combo_target_scale = 1;
combo_angle = 0;
combo_angle_speed = 0;
combo_angle_stiffness = 0.3;
combo_angle_damping = 0.55;
combo_scale_speed = 0;
combo_scale_stiffness = 0.25;
combo_scale_damping = 0.6;
prev_combo = 0;
combo_shake_x = 0;
combo_shake_y = 0;
combo_bar_x = 0;
combo_bar_y = 0;
combo_alpha = 0;
combo_fade_speed = 0.05;
combo_show_zero = false; // показывать ли ноль после сброса комбо
combo_zero_timer = 0;
combo_zero_duration = 60; // сколько кадров показывать ноль
combo_zero_alpha = 0;

// ===== ДЫХАНИЕ UI =====
breath_timer = 0;
breath_speed = 0.05;
breath_amplitude = 1.5; // сила покачивания
heart_phase_offset = 0.4; // сдвиг фазы между элементами

// ===== ПОКАЧИВАНИЕ ПОЛОСЫ КОМБО =====
bar_wobble_angle = 0;
bar_wobble_speed = 0;
bar_wobble_stiffness = 0.02;
bar_wobble_damping = 0.95;
bar_wobble_amplitude = 3;
bar_wobble_timer = 0;

// ===== АНИМАЦИИ СЕРДЕЦ =====
heart_scale_x = [];
heart_scale_y = [];
heart_scale_x_speed = [];
heart_scale_y_speed = [];
heart_angle = [];
heart_angle_speed = [];
prev_hp = -1;

// ===== СЧЁТЧИК ДЕНЕГ =====
displayed_money = 0; // отображаемое значение (плавно догоняет реальное)
prev_money = 0;

// ===== АНИМАЦИИ ИНВЕНТАРЯ =====
inv_scale_x = [];
inv_scale_y = [];
inv_scale_x_speed = [];
inv_scale_y_speed = [];
prev_inv_count = 0;

depth = -10; // рисуется под курсором

// ===== ФУНКЦИИ СКВОША =====
function trigger_heart_squash(_i) {
    while (array_length(heart_scale_x) <= _i) {
        array_push(heart_scale_x, 1);
        array_push(heart_scale_y, 1);
        array_push(heart_scale_x_speed, 0);
        array_push(heart_scale_y_speed, 0);
        array_push(heart_angle, 0);
        array_push(heart_angle_speed, 0);
    }
    heart_scale_x[_i] = 1.8;
    heart_scale_y[_i] = 1.8;
    heart_scale_x_speed[_i] = 0;
    heart_scale_y_speed[_i] = 0;
    heart_angle[_i] = choose(-1, 1) * 25;
    heart_angle_speed[_i] = choose(-1, 1) * 15;
}

function trigger_inv_squash(_i) {
    while (array_length(inv_scale_x) <= _i) {
        array_push(inv_scale_x, 1);
        array_push(inv_scale_y, 1);
        array_push(inv_scale_x_speed, 0);
        array_push(inv_scale_y_speed, 0);
    }
    inv_scale_x[_i] = 0.2;
    inv_scale_y[_i] = 0.2;
    inv_scale_x_speed[_i] = 0.4;
    inv_scale_y_speed[_i] = -0.4;
}

// ===== КНОПКА ГЛАЗА В ПАУЗЕ =====
pause_eye_scale = 1.0;
pause_eye_target_scale = 1.0;
pause_eye_sx = 1.0;
pause_eye_sy = 1.0;
pause_eye_squash_frame = 0;
pause_eye_squash_timer = 0;
pause_eye_squash_fps = 6; // кадров в секунду для сквоша
pause_eye_squash_step = 1.0 / pause_eye_squash_fps;
pause_hovered = false;
pause_prev_hovered = false;
pause_eye_text = Text("Pause_Menu_Exit_Text");
pause_title_text = Text("Pause_Menu_Pause_Text");
pause_sway_timer = random(pi * 2); // случайный старт покачивания
pause_wave_timer = 0;
pause_transitioning = false; // идёт ли переход в меню
pause_gp_active = false;

// ===== ВОЛНОВОЙ ТЕКСТ ДЛЯ ПАУЗЫ =====
function draw_pause_wave_text(str, dx, dy, alpha) {
    if (alpha <= 0.01) exit;
    draw_set_font(SmallFnt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _total_w = string_width(str);
    var _cx = dx - _total_w * 0.5;
    for (var _i = 0; _i < string_length(str); _i++) {
        var _ch = string_char_at(str, _i + 1);
        var _wave_y = sin(pause_wave_timer + _i * 0.5) * 2.5;
        var _chx = _cx;
        var _chy = dy + _wave_y;
        draw_set_alpha(alpha);
        draw_set_color(c_black);
        draw_text(_chx + 1, _chy,     _ch);
        draw_text(_chx - 1, _chy,     _ch);
        draw_text(_chx,     _chy + 1, _ch);
        draw_text(_chx,     _chy - 1, _ch);
        draw_set_color(c_white);
        draw_text(_chx, _chy, _ch);
        _cx += string_width(_ch);
    }
    draw_set_alpha(1);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}