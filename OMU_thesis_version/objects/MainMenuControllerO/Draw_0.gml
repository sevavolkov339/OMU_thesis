var _sway  = sin(sway_timer) * 4;
var _sway2 = sin(sway_timer + 1.2) * 4;
var _sway3 = sin(sway_timer + 2.4) * 4;
var _eye_sway_x = sin(sway_timer * 0.7) * 2;
var _eye_sway_y = sin(sway_timer * 0.5) * 2;

// радио
if (settings_alpha > 0.01) {
    var _settings_color = hovered_settings ? make_colour_rgb(0, 42, 255) : c_white;
    var _settings_frame = hovered_settings ? (current_time mod (sprite_get_number(SettingsMenuS) * 80)) / 80 : 0;
    draw_sprite_ext(SettingsMenuS, _settings_frame,
        settings_cur_x + _sway, settings_cur_y,
        settings_sx, settings_sy, 0, _settings_color, settings_alpha);
    if (hovered_settings) {
        var _sh = sprite_get_height(SettingsMenuS) * 0.5 - 90;
        draw_wave_text(settings_text, settings_cur_x + _sway, settings_cur_y + _sh, settings_alpha);
    }
}

// книга
if (stuff_alpha > 0.01) {
    var _stuff_color = hovered_stuff ? make_colour_rgb(255, 0, 255) : c_white;
    var _stuff_frame = hovered_stuff ? (current_time mod (sprite_get_number(StuffMenuS) * 80)) / 80 : 0;
    draw_sprite_ext(StuffMenuS, _stuff_frame,
        stuff_cur_x + _sway2, stuff_cur_y,
        stuff_sx, stuff_sy, 0, _stuff_color, stuff_alpha);
    if (hovered_stuff) {
        var _bh = sprite_get_height(StuffMenuS) * 0.5 - 90;
        draw_wave_text(stuff_text, stuff_cur_x + _sway2, stuff_cur_y + _bh, stuff_alpha);
    }
}

// выход
if (exit_alpha > 0.01) {
    var _exit_color = hovered_exit ? make_colour_rgb(238, 28, 36) : c_white;
    draw_sprite_ext(ExitMenuS, 0,
        exit_cur_x + _sway3, exit_cur_y,
        exit_sx, exit_sy, 0, _exit_color, exit_alpha);
    if (hovered_exit) {
        var _exh = sprite_get_height(ExitMenuS) * 0.5 - 90;
        draw_wave_text(exit_text, exit_cur_x + _sway3, exit_cur_y + _exh, exit_alpha);
    }
}

// глаз
var _eye_color = hovered ? make_colour_rgb(255, 255, 0) : c_white;
var _eye_frame = items_visible ? 1 : 0;
draw_sprite_ext(EyeMenuS, _eye_frame,
    eye_x + _eye_sway_x, eye_y + _eye_sway_y,
    eye_scale * eye_sx, eye_scale * eye_sy, 0, _eye_color, 1);
if (hovered) {
    var _eh = sprite_get_height(EyeMenuS) * 0.5 - 90;
    draw_wave_text(eye_text, eye_x + _eye_sway_x, eye_y + _eye_sway_y + _eh, 1);
}

// "нажмите любую кнопку", пока меню не раскрыто, дышащий волновой текст под глазом
if (!items_visible) {
    var _breathe_alpha = (sin(breathe_timer) + 1) * 0.5;
    var _prompt_y = eye_y + _eye_sway_y + sprite_get_height(EyeMenuS) * 0.5 + 20;
    draw_wave_text(press_any_button_text, eye_x + _eye_sway_x, _prompt_y, _breathe_alpha);
}

// стрелка геймпада над выбранной кнопкой
if (gp_active && current_page == "none") {
    if (hovered) {
        draw_gp_arrow(eye_x + _eye_sway_x, eye_y + _eye_sway_y - 20, 1);
    } else if (hovered_settings) {
        draw_gp_arrow(settings_cur_x + _sway, settings_cur_y - 20, 1);
    } else if (hovered_stuff) {
        draw_gp_arrow(stuff_cur_x + _sway2, stuff_cur_y - 20, 1);
    } else if (hovered_exit) {
        draw_gp_arrow(exit_cur_x + _sway3, exit_cur_y - 20, 1);
    }
}

// страницы
if (page_alpha > 0.01) {
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);
    var _cw = camera_get_view_width(view_camera[0]);
    var _ch = camera_get_view_height(view_camera[0]);
    var _pw = 1280;
    var _ph = 720;
    var _px = _cam_x + (_cw - _pw) * 0.5;
    var _py = _cam_y + (_ch - _ph) * 0.5;
    draw_set_alpha(page_alpha);
    draw_set_color(c_black);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_alpha(1);

    if (current_page == "settings") {
        draw_wave_text("settings page.", _px + _pw * 0.5, _py + _ph * 0.5, page_alpha);
    }
    if (current_page == "diary") {
        draw_wave_text("game by Seva 'rexent' Volkov.", _px + _pw * 0.5, _py + _ph * 0.5, page_alpha);
    }
    if (current_page == "save_files") {
        var _center_x = _cam_x + _cw * 0.5;
        var _center_y = _cam_y + _ch * 0.5;
        var _spr_h = sprite_get_height(SaveFileMenuS);
        for (var i = 0; i < save_file_count; i++) {
            if (save_selected && i != save_selected_index) continue;
            var _fx = _center_x + (i - (save_file_count - 1) * 0.5) * save_spacing;
            var _float_y = sin(save_float_timer[i] * 0.5) * 3;
            var _fy = _center_y + _float_y;
            var _shake_x = 0;
            var _shake_y = 0;
            var _file_alpha = page_alpha;

            if (save_selected && i == save_selected_index) {
                var _shake_t = clamp(save_select_timer / 0.3, 0, 1);
                var _shake_amt = lerp(3, 0, _shake_t);
                _shake_x = random_range(-_shake_amt, _shake_amt);
                _shake_y = random_range(-_shake_amt * 0.7, _shake_amt * 0.7);
                var _blink = (floor(save_blink_timer * 8) mod 2 == 0);
                _file_alpha = _blink ? page_alpha : 0;
            }

            var _fcol = save_hovered[i] ? make_colour_rgb(0x77, 0xFF, 0x4C) : c_white;
            draw_set_alpha(_file_alpha);
            draw_sprite_ext(SaveFileMenuS, 0,
                _fx + _shake_x, _fy + _shake_y,
                save_sx[i], save_sy[i], 0, _fcol, _file_alpha);

            // текст названия сейва
            var _text_y = _fy + _spr_h * 0.5 + 6;
            draw_wave_text(get_save_file_text(i), _fx + _shake_x, _text_y - 96, _file_alpha);

            // стрелка геймпада над выбранным сейвом
            if (gp_active && save_hovered[i] && !(gp_on_delete && gp_save_focus == i)) {
                draw_gp_arrow(_fx + _shake_x, _fy + _shake_y - 20, _file_alpha);
            }

            // текст удаления
            if (delete_visible_index == i && GameControllerO.save_exists(i) && !save_selected && save_intro_done) {
                var _del_y = _fy + _spr_h * 0.5 - 70 ;
                var _del_color = delete_hovered[i] ? make_colour_rgb(238, 28, 36) : c_white;
                draw_set_font(SmallFnt);
                var _del_w = string_width(delete_text);
                var _cx2 = _fx - _del_w * 0.5;
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                for (var _ci = 0; _ci < string_length(delete_text); _ci++) {
                    var _dch = string_char_at(delete_text, _ci + 1);
                    var _wave_y2 = sin(wave_text_timer + _ci * 0.5) * 2.5;
                    draw_set_alpha(page_alpha);
                    draw_set_color(c_black);
                    draw_text(_cx2 + 1, _del_y + _wave_y2,     _dch);
                    draw_text(_cx2 - 1, _del_y + _wave_y2,     _dch);
                    draw_text(_cx2,     _del_y + _wave_y2 + 1, _dch);
                    draw_text(_cx2,     _del_y + _wave_y2 - 1, _dch);
                    draw_set_color(_del_color);
                    draw_text(_cx2, _del_y + _wave_y2, _dch);
                    _cx2 += string_width(_dch);
                }
                draw_set_font(-1);

                // стрелка геймпада над кнопкой удаления
                if (gp_active && gp_on_delete && gp_save_focus == i) {
                    draw_gp_arrow(_fx, _del_y - 3, page_alpha);
                }
            }
        }
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);