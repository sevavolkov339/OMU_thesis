if (!instance_exists(PlayerBallerO)) exit;
if (ui_alpha <= 0) exit;
var p = instance_find(PlayerBallerO, 0);
var gc = CameraControllerO;
var cam = CameraControllerO.cam;
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);
draw_set_alpha(ui_alpha);
var margin  = ui_margin;
var spacing = heart_spacing;

// ===== СЕРДЦА =====
var hearts_y = cy + margin;
for (var i = 0; i < p.hp; i++) {
    var ui_x = cx + margin + i * spacing;
    var heart_breath = sin(breath_timer + i * heart_phase_offset) * breath_amplitude;
    var ui_y = hearts_y + heart_breath;
    var hsx = (i < array_length(heart_scale_x)) ? heart_scale_x[i] : 1;
    var hsy = (i < array_length(heart_scale_y)) ? heart_scale_y[i] : 1;
    var hang = (i < array_length(heart_angle)) ? heart_angle[i] : 0;
    var _hmx = matrix_build(ui_x, ui_y, 0, 0, 0, hang, hsx, hsy, 1);
    var _hprev = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_hmx, _hprev));
    draw_sprite_ext(heart_sprite, 0, 0, 0, 1, 1, 0, c_white, ui_alpha);
    matrix_set(matrix_world, _hprev);
}

// ===== ДЕНЬГИ =====
var apple_breath = sin(breath_timer + p.hp * heart_phase_offset) * breath_amplitude;
var money_y = cy + margin + sprite_get_height(heart_sprite) + space_between;
draw_sprite_ext(
    apple_sprite, 0,
    cx + margin,
    money_y + apple_y_offset + apple_breath,
    apple_scale_x, apple_scale_y,
    0, c_white, ui_alpha
);

// ===== ТЕКСТ ДЕНЕГ =====
draw_set_font(MainFnt);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var money_str = string(round(displayed_money));
var char_x = cx + margin + sprite_get_width(apple_sprite) + money_spacing;
for (var _i = 0; _i < string_length(money_str); _i++) {
    var char_breath = sin(breath_timer + (_i + p.hp + 1) * heart_phase_offset) * breath_amplitude;
    draw_set_alpha(ui_alpha);
    draw_set_color(c_black);
    draw_text(char_x + 1, money_y - 9 + char_breath, string_char_at(money_str, _i + 1));
    draw_text(char_x - 1, money_y - 9 + char_breath, string_char_at(money_str, _i + 1));
    draw_text(char_x, money_y - 9 + char_breath + 1, string_char_at(money_str, _i + 1));
    draw_text(char_x, money_y - 9 + char_breath - 1, string_char_at(money_str, _i + 1));
    draw_set_color(c_white);
    draw_text(char_x, money_y - 9 + char_breath, string_char_at(money_str, _i + 1));
    char_x += string_width(string_char_at(money_str, _i + 1)) + 1;
}

// ===== ИНВЕНТАРЬ =====
var inv_count_draw = 0;
if (instance_exists(InventoryControllerO)) {
    var inv = InventoryControllerO.items;
    var inv_raw_count = array_length(inv);
    var slot_size = 16;
    var slot_padding = 2;
    var inv_margin = 8;
    var max_per_row = floor((CameraControllerO.view_w - inv_margin * 2) / (slot_size + slot_padding));
    var _disp_i = 0;
    for (var _i = 0; _i < inv_raw_count; _i++) {
        if (inv[_i].type == "PowerUp") continue;
        var row = floor(_disp_i / max_per_row);
        var col = _disp_i mod max_per_row;
        var ix = cx + CameraControllerO.view_w - inv_margin - slot_size - col * (slot_size + slot_padding);
        var iy = cy + inv_margin + row * (slot_size + slot_padding);
        var inv_breath = sin(breath_timer + (_disp_i + p.hp + string_length(money_str) + 2) * heart_phase_offset) * breath_amplitude;
        var isx = (_i < array_length(inv_scale_x)) ? inv_scale_x[_i] : 1;
        var isy = (_i < array_length(inv_scale_y)) ? inv_scale_y[_i] : 1;

        // крылья дрожат в полёте (сильнее к концу) и мигают красным/белым на кулдауне
        var _icon_shake_x = 0;
        var _icon_shake_y = 0;
        var _icon_tint = c_white;
        if (inv[_i].name == "Angel Wings" && instance_exists(WingsO)) {
            var _w = WingsO;
            if (_w.fly_state == "flying") {
                var _ft = _w.fly_timer / _w.fly_duration;
                var _shake_amt = lerp(0.3, 2.5, _ft);
                _icon_shake_x = random_range(-_shake_amt, _shake_amt);
                _icon_shake_y = random_range(-_shake_amt, _shake_amt);
            } else if (_w.fly_state == "cooldown") {
                // жёсткое мигание без полутонов — цвет всегда либо чистый белый, либо чистый
                // красный, никакого смешивания; меняется только частота (и во второй части — доля
                // времени в красном), не сама насыщенность цвета
                var _ct = _w.cooldown_timer / _w.cooldown_duration;
                if (_ct < 0.6) {
                    // первая часть кулдауна — 50/50 мигание чистым красным, всё быстрее
                    var _phase = _ct / 0.6;
                    var _blink_spd = lerp(4, 14, _phase);
                    var _blink_on = (sin(current_time * 0.001 * _blink_spd) >= 0);
                    _icon_tint = _blink_on ? c_red : c_white;
                } else {
                    // вторая часть — мигает всё быстрее, но красные вспышки всё короче и реже,
                    // к концу кулдауна остаётся только чистый белый
                    var _phase2 = (_ct - 0.6) / 0.4;
                    var _blink_spd2 = lerp(6, 20, _phase2);
                    var _duty = lerp(0.5, 0.05, _phase2);
                    var _cycle = sin(current_time * 0.001 * _blink_spd2) * 0.5 + 0.5;
                    _icon_tint = (_cycle < _duty) ? c_red : c_white;
                }
            }
        }

        if (sprite_exists(inv[_i].sprite)) {
            draw_set_alpha(ui_alpha);
            var _imx = matrix_build(ix + slot_size * 0.5 + _icon_shake_x, iy + slot_size * 0.5 + inv_breath + _icon_shake_y, 0, 0, 0, 0, isx, isy, 1);
            var _iprev = matrix_get(matrix_world);
            matrix_set(matrix_world, matrix_multiply(_imx, _iprev));
            draw_sprite_stretched_ext(inv[_i].sprite, 0, -slot_size * 0.5, -slot_size * 0.5, slot_size, slot_size, _icon_tint, ui_alpha);
            matrix_set(matrix_world, _iprev);
        }
        _disp_i++;
    }
    inv_count_draw = _disp_i;
}

// ===== PAUSE MENU =====
if (pause_alpha > 0) {
    draw_set_alpha(pause_alpha);
    draw_set_color(c_black);
    draw_rectangle(cx, cy, cx + global.gameWidth, cy + global.gameHeight, false);

    var _title_x = cx + global.gameWidth * 0.5;
    var _title_y = cy + global.gameHeight * 0.18;
    draw_pause_wave_text(pause_title_text, _title_x, _title_y, pause_alpha);

    var _eye_x = cx + global.gameWidth * 0.5;
    var _eye_y = cy + global.gameHeight * 0.55;
    var _eye_sway_x = sin(pause_sway_timer * 0.7) * 2;
    var _eye_sway_y = sin(pause_sway_timer * 0.5) * 2;
    var _eye_color = pause_hovered ? make_colour_rgb(255, 255, 0) : c_white;

    draw_set_alpha(pause_alpha);
    draw_sprite_ext(EyeMenuS, 1,
        _eye_x + _eye_sway_x,
        _eye_y + _eye_sway_y,
        pause_eye_scale * pause_eye_sx,
        pause_eye_scale * pause_eye_sy,
        0, _eye_color, pause_alpha);

    if (pause_hovered) {
        var _eh = sprite_get_height(EyeMenuS) * 0.5 - 90;
        draw_pause_wave_text(pause_eye_text,
            _eye_x + _eye_sway_x,
            _eye_y + _eye_sway_y + _eh,
            pause_alpha);
    }

    if (pause_gp_active) {
        var _arrow_frame = (current_time mod (sprite_get_number(UI_ControllerArrowS) * 100)) / 100;
        var _arrow_x = _eye_x + _eye_sway_x;
        var _arrow_y = _eye_y + _eye_sway_y - 20;
        var _ao = 1;
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x - _ao, _arrow_y, 1, 1, 0, c_black, pause_alpha);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x + _ao, _arrow_y, 1, 1, 0, c_black, pause_alpha);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x, _arrow_y - _ao, 1, 1, 0, c_black, pause_alpha);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x, _arrow_y + _ao, 1, 1, 0, c_black, pause_alpha);
        draw_sprite_ext(UI_ControllerArrowS, _arrow_frame, _arrow_x, _arrow_y, 1, 1, 0, c_white, pause_alpha);
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ===== COMBO =====
if (instance_exists(ComboControllerO) && combo_alpha > 0) {
    var cc = ComboControllerO;

    var combo_text = "";
    if (cc.combo >= 1) {
        combo_text = string(cc.combo) + "x";
    } else if (combo_show_zero) {
        combo_text = "0";
    }

    if (combo_text != "") {
        var _inv_margin = 8;
        var _slot_size = 16;
        var combo_x = cx + CameraControllerO.view_w - _inv_margin - _slot_size * 0.5;

        // если инвентарь пустой — комбо на уровне сердец, иначе — на уровне денег
        var combo_y = (inv_count_draw == 0) ? hearts_y : money_y;

        draw_set_font(MainFnt);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var text_alpha = combo_alpha;
        draw_set_alpha(text_alpha);

        var _mx = matrix_build(
            combo_x + combo_shake_x,
            combo_y + combo_shake_y,
            0, 0, 0, combo_angle,
            combo_scale, combo_scale, 1
        );
        var _prev = matrix_get(matrix_world);
        matrix_set(matrix_world, matrix_multiply(_mx, _prev));

        draw_set_color(c_black);
        draw_text( 1,  0, combo_text);
        draw_text(-1,  0, combo_text);
        draw_text( 0,  1, combo_text);
        draw_text( 0, -1, combo_text);
        draw_set_color(c_white);
        draw_text(0, 0, combo_text);

        matrix_set(matrix_world, _prev);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

draw_set_alpha(1);
draw_set_font(-1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);