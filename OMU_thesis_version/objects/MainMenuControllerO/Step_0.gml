sway_timer += 0.03;
wave_text_timer += 0.08;
breathe_timer += 0.05;

var _gp = 0;
gp_active = gamepad_is_connected(_gp) && variable_global_exists("using_gamepad") && global.using_gamepad;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);
var _eye_gui_x = eye_x - _cam_x;
var _eye_gui_y = eye_y - _cam_y;
var _dist = point_distance(_mx, _my, _eye_gui_x, _eye_gui_y);
hovered = (_dist < 50);

var _settings_close = point_distance(settings_cur_x, settings_cur_y, settings_x, settings_target_y) < 4;
var _stuff_close    = point_distance(stuff_cur_x, stuff_cur_y, stuff_x, stuff_target_y) < 4;
if (items_visible && _settings_close && _stuff_close) {
    items_ready = true;
} else if (!items_visible) {
    items_ready = false;
}

var _on_settings = false;
var _on_stuff    = false;
var _on_exit     = false;
if (items_ready) {
    _on_settings = point_distance(_mx, _my,
        settings_cur_x - _cam_x,
        settings_cur_y - _cam_y) < 30;
    _on_stuff = point_distance(_mx, _my,
        stuff_cur_x - _cam_x,
        stuff_cur_y - _cam_y) < 30;
    _on_exit = point_distance(_mx, _my,
        exit_cur_x - _cam_x,
        exit_cur_y - _cam_y) < 30;
}
hovered_settings = _on_settings;
hovered_stuff    = _on_stuff;
hovered_exit     = _on_exit;

if (gp_active && current_page == "none") {
    hovered          = (gp_focus == "eye");
    hovered_settings = items_ready && (gp_focus == "settings");
    hovered_stuff    = items_ready && (gp_focus == "stuff");
    hovered_exit     = items_ready && (gp_focus == "exit");
    _on_settings = hovered_settings;
    _on_stuff    = hovered_stuff;
    _on_exit     = hovered_exit;
}

if (hovered || (gp_active && current_page == "none")) {
    items_visible = true;
    eye_target_scale = 1.12;
} else {
    var _zone_dist = point_distance(_mx, _my, _eye_gui_x, _eye_gui_y);
    if (_zone_dist > 130) {
        items_visible = false;
    }
    eye_target_scale = 1.0;
}

eye_scale = lerp(eye_scale, eye_target_scale, 0.15);

if (items_visible) {
    settings_cur_x = lerp(settings_cur_x, settings_x, 0.14);
    settings_cur_y = lerp(settings_cur_y, settings_target_y, 0.14);
    stuff_cur_x    = lerp(stuff_cur_x, stuff_x, 0.14);
    stuff_cur_y    = lerp(stuff_cur_y, stuff_target_y, 0.14);
    exit_cur_x     = lerp(exit_cur_x, exit_x, 0.14);
    exit_cur_y     = lerp(exit_cur_y, exit_target_y, 0.14);
    settings_alpha = lerp(settings_alpha, 1, 0.14);
    stuff_alpha    = lerp(stuff_alpha, 1, 0.14);
    exit_alpha     = lerp(exit_alpha, 1, 0.14);
} else {
    settings_cur_x = lerp(settings_cur_x, settings_start_x, 0.14);
    settings_cur_y = lerp(settings_cur_y, settings_hide_y, 0.14);
    stuff_cur_x    = lerp(stuff_cur_x, stuff_start_x, 0.14);
    stuff_cur_y    = lerp(stuff_cur_y, stuff_hide_y, 0.14);
    exit_cur_x     = lerp(exit_cur_x, exit_start_x, 0.14);
    exit_cur_y     = lerp(exit_cur_y, exit_hide_y, 0.14);
    settings_alpha = lerp(settings_alpha, 0, 0.25);
    stuff_alpha    = lerp(stuff_alpha, 0, 0.25);
    exit_alpha     = lerp(exit_alpha, 0, 0.25);
}

// при открытии страницы сейвов
if (current_page == "save_files" && prev_page != "save_files") {
    save_intro_done = false;
    gp_save_focus = 0;
    gp_on_delete = false;
    for (var i = 0; i < save_file_count; i++) {
        save_squash_frame[i] = 1;
        save_sx[i] = 1.0;
        save_sy[i] = 1.0;
    }
}
prev_page = current_page;

// файлы сохранения, hover, float, delete
if (current_page == "save_files") {
    var _center_x = _cw * 0.5;
    var _center_y = _ch * 0.5;
    var _spr_h = sprite_get_height(SaveFileMenuS);
    var _new_delete_visible_index = delete_visible_index;
    var _direct_delete_slot = -1;

    for (var i = 0; i < save_file_count; i++) {
        save_float_timer[i] += 0.03;

        var _fx = _center_x + (i - (save_file_count - 1) * 0.5) * save_spacing;
        var _fy = _center_y + sin(save_float_timer[i] * 0.5) * 3;
        if (gp_active) {
            save_hovered[i] = save_intro_done && (i == gp_save_focus);
        } else {
            var _fdist = point_distance(_mx, _my, _fx, _fy);
            save_hovered[i] = save_intro_done && (_fdist < save_hover_radius);
        }

        if (save_hovered[i] && !save_prev_hovered[i] && save_intro_done) {
            save_squash_frame[i] = 1;
        }
        save_prev_hovered[i] = save_hovered[i];

        delete_prev_hovered[i] = delete_hovered[i];
        delete_hovered[i] = false;

        if (save_hovered[i] && GameControllerO.save_exists(i) && !save_selected) {
            _new_delete_visible_index = i;
            _direct_delete_slot = i;
        }
    }

    if (save_selected) {
        _new_delete_visible_index = -1;
    }

    if (_new_delete_visible_index != -1) {
        if (!GameControllerO.save_exists(_new_delete_visible_index)) {
            _new_delete_visible_index = -1;
        } else {
            var _di = _new_delete_visible_index;
            var _dfx = _center_x + (_di - (save_file_count - 1) * 0.5) * save_spacing;
            var _dfy = _center_y + sin(save_float_timer[_di] * 0.5) * 3;
            var _del_y = _dfy + _spr_h * 0.5 - 70;

            draw_set_font(SmallFnt);
            var _del_w = string_width(delete_text);
            var _del_h = string_height(delete_text);
            draw_set_font(-1);

            var _over_delete = (_mx >= _dfx - _del_w * 0.5 - delete_text_pad_x)
                && (_mx <= _dfx + _del_w * 0.5 + delete_text_pad_x)
                && (_my >= _del_y - delete_text_pad_y)
                && (_my <= _del_y + _del_h + delete_text_pad_y);
            var _near_file = point_distance(_mx, _my, _dfx, _dfy) < delete_keep_radius;

            if (!_near_file && !_over_delete && _direct_delete_slot == -1) {
                _new_delete_visible_index = -1;
            } else {
                delete_hovered[_di] = _over_delete;
            }

            if (gp_active) {
                delete_hovered[_di] = gp_on_delete;
            }
        }
    }

    delete_visible_index = _new_delete_visible_index;

    if (mouse_check_button_pressed(mb_left) && delete_visible_index != -1 && delete_hovered[delete_visible_index] && !save_selected) {
        GameControllerO.delete_save(delete_visible_index);
        delete_hovered[delete_visible_index] = false;
        delete_visible_index = -1;
    }
}

// триггеры сквоша
if (hovered && !prev_hovered)                   eye_squash_frame = 1;
if (hovered_settings && !prev_hovered_settings) settings_squash_frame = 1;
if (hovered_stuff && !prev_hovered_stuff)       stuff_squash_frame = 1;
if (hovered_exit && !prev_hovered_exit)         exit_squash_frame = 1;

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
    if (settings_squash_frame > 0) settings_squash_frame++;
    switch (settings_squash_frame) {
        case 1: settings_sx = 1.6;  settings_sy = 0.4;  break;
        case 2: settings_sx = 0.5;  settings_sy = 1.7;  break;
        case 3: settings_sx = 1.2;  settings_sy = 0.85; break;
        case 4: settings_sx = 1.0;  settings_sy = 1.0;  settings_squash_frame = 0; break;
    }
    if (stuff_squash_frame > 0) stuff_squash_frame++;
    switch (stuff_squash_frame) {
        case 1: stuff_sx = 1.6;  stuff_sy = 0.4;  break;
        case 2: stuff_sx = 0.5;  stuff_sy = 1.7;  break;
        case 3: stuff_sx = 1.2;  stuff_sy = 0.85; break;
        case 4: stuff_sx = 1.0;  stuff_sy = 1.0;  stuff_squash_frame = 0; break;
    }
    if (exit_squash_frame > 0) exit_squash_frame++;
    switch (exit_squash_frame) {
        case 1: exit_sx = 1.6;  exit_sy = 0.4;  break;
        case 2: exit_sx = 0.5;  exit_sy = 1.7;  break;
        case 3: exit_sx = 1.2;  exit_sy = 0.85; break;
        case 4: exit_sx = 1.0;  exit_sy = 1.0;  exit_squash_frame = 0; break;
    }
    var _all_done = true;
    for (var i = 0; i < save_file_count; i++) {
        if (save_squash_frame[i] > 0) {
            save_squash_frame[i]++;
            _all_done = false;
        }
        switch (save_squash_frame[i]) {
            case 1: save_sx[i] = 1.6;  save_sy[i] = 0.4;  break;
            case 2: save_sx[i] = 0.5;  save_sy[i] = 1.7;  break;
            case 3: save_sx[i] = 1.2;  save_sy[i] = 0.85; break;
            case 4: save_sx[i] = 1.0;  save_sy[i] = 1.0;  save_squash_frame[i] = 0; break;
        }
    }
    if (_all_done && current_page == "save_files") save_intro_done = true;

    prev_hovered          = hovered;
    prev_hovered_settings = hovered_settings;
    prev_hovered_stuff    = hovered_stuff;
    prev_hovered_exit     = hovered_exit;
}

page_just_opened = false;

if (mouse_check_button_pressed(mb_left) && current_page == "none") {
    if (hovered) {
        current_page = "save_files";
        page_just_opened = true;
    }
    if (items_ready && _on_settings) {
        current_page = "settings";
    }
    if (items_ready && _on_stuff) {
        current_page = "diary";
    }
    if (items_ready && _on_exit) {
        game_end();
    }
}

// клик по файлу сохранения
if (current_page == "save_files" && mouse_check_button_pressed(mb_left) && save_intro_done && !page_just_opened) {
    for (var i = 0; i < save_file_count; i++) {
        if (delete_hovered[i]) continue;
        if (save_hovered[i] && !save_selected) {
            select_save_file(i);
        }
    }
}

// геймпад, навигация по меню (крестовина / левый или правый стик)
if (gp_active) {
    var _nav = gp_read_nav(_gp);
    var _nav_x = _nav[0];
    var _nav_y = _nav[1];
    var _nav_edge = (_nav_x != 0 || _nav_y != 0) && (gp_prev_nav_x == 0 && gp_prev_nav_y == 0);
    gp_prev_nav_x = _nav_x;
    gp_prev_nav_y = _nav_y;

    if (_nav_edge) {
        if (current_page == "none" && items_ready) {
            var _names = ["eye", "settings", "stuff", "exit"];
            var _xs = [eye_x, settings_x, stuff_x, exit_x];
            var _ys = [eye_y, settings_target_y, stuff_target_y, exit_target_y];
            var _cur_i = 0;
            for (var i = 0; i < 4; i++) {
                if (_names[i] == gp_focus) { _cur_i = i; break; }
            }
            var _best_i = -1;
            var _best_score = -infinity;
            for (var i = 0; i < 4; i++) {
                if (i == _cur_i) continue;
                var _dx = _xs[i] - _xs[_cur_i];
                var _dy = _ys[i] - _ys[_cur_i];
                var _ddist = point_distance(0, 0, _dx, _dy);
                if (_ddist < 1) continue;
                var _dot = (_dx * _nav_x + _dy * _nav_y) / _ddist;
                if (_dot > 0.35) {
                    var _score = _dot / _ddist;
                    if (_score > _best_score) {
                        _best_score = _score;
                        _best_i = i;
                    }
                }
            }
            if (_best_i != -1) gp_focus = _names[_best_i];
        } else if (current_page == "save_files" && save_intro_done && !save_selected) {
            if (_nav_x != 0) {
                gp_save_focus = clamp(gp_save_focus + _nav_x, 0, save_file_count - 1);
                gp_on_delete = false;
            } else if (_nav_y > 0 && !gp_on_delete && GameControllerO.save_exists(gp_save_focus)) {
                gp_on_delete = true;
            } else if (_nav_y < 0 && gp_on_delete) {
                gp_on_delete = false;
            }
        }
    }

    // подтверждение, A
    if (gamepad_button_check_pressed(_gp, gp_face1)) {
        if (current_page == "none") {
            switch (gp_focus) {
                case "eye":
                    current_page = "save_files";
                    page_just_opened = true;
                    break;
                case "settings":
                    if (items_ready) current_page = "settings";
                    break;
                case "stuff":
                    if (items_ready) current_page = "diary";
                    break;
                case "exit":
                    if (items_ready) game_end();
                    break;
            }
        } else if (current_page == "save_files" && save_intro_done && !page_just_opened && !save_selected) {
            if (gp_on_delete && delete_visible_index == gp_save_focus) {
                GameControllerO.delete_save(gp_save_focus);
                delete_hovered[gp_save_focus] = false;
                delete_visible_index = -1;
                gp_on_delete = false;
            } else if (!delete_hovered[gp_save_focus]) {
                select_save_file(gp_save_focus);
            }
        }
    }
}

if (save_selected) {
    save_select_timer += delta_time / 1000000;
    save_blink_timer  += delta_time / 1000000;
}

if ((keyboard_check_pressed(vk_escape) || (gp_active && gamepad_button_check_pressed(_gp, gp_face2))) && current_page != "none") {
    current_page = "none";
}

var _page_target = (current_page != "none") ? 1 : 0;
page_alpha = lerp(page_alpha, _page_target, page_fade_speed);