var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

eye_x = x;
eye_y = y;

settings_start_x = eye_x;
stuff_start_x    = eye_x;
exit_start_x     = eye_x;
settings_cur_x   = eye_x;
stuff_cur_x      = eye_x;
exit_cur_x       = eye_x;

// радио
settings_x        = eye_x + 60;
settings_target_y = eye_y + 60;
settings_hide_y   = eye_y;

// книга
stuff_x        = eye_x + 60;
stuff_target_y = eye_y - 60;
stuff_hide_y   = eye_y;

// выход
exit_x        = eye_x - 60;
exit_target_y = eye_y + 60;
exit_hide_y   = eye_y;

settings_cur_y = settings_hide_y;
stuff_cur_y    = stuff_hide_y;
exit_cur_y     = exit_hide_y;

// состояние
hovered          = false;
hovered_settings = false;
hovered_stuff    = false;
hovered_exit     = false;
items_visible    = false;

// анимация
settings_alpha = 0;
stuff_alpha    = 0;
exit_alpha     = 0;

// масштаб глаза
eye_scale        = 1.0;
eye_target_scale = 1.0;

// покачивание
sway_timer = 0;
alarm_set(0, 30);

// squash and stretch
eye_sx      = 1.0; eye_sy      = 1.0;
eye_vx      = 0.0; eye_vy      = 0.0;
settings_sx = 1.0; settings_sy = 1.0;
settings_vx = 0.0; settings_vy = 0.0;
stuff_sx    = 1.0; stuff_sy    = 1.0;
stuff_vx    = 0.0; stuff_vy    = 0.0;
exit_sx     = 1.0; exit_sy     = 1.0;

prev_hovered          = false;
prev_hovered_settings = false;
prev_hovered_stuff    = false;
prev_hovered_exit     = false;

squash_timer = 0;
squash_fps   = 6;
squash_step  = 1.0 / squash_fps;

eye_squash_frame      = 0;
eye_sx = 1.0; eye_sy = 1.0;
settings_squash_frame = 0;
settings_sx = 1.0; settings_sy = 1.0;
stuff_squash_frame    = 0;
stuff_sx = 1.0; stuff_sy = 1.0;
exit_squash_frame     = 0;
exit_sx = 1.0; exit_sy = 1.0;

prev_hovered          = false;
prev_hovered_settings = false;
prev_hovered_stuff    = false;
prev_hovered_exit     = false;

items_ready = false;

// тексты кнопок
eye_text      = Text("Main_Menu_Start_Button_Text");
settings_text = Text("Main_Menu_Settings_Button_Text");
stuff_text    = Text("Main_Menu_Diary_Button_Text");
exit_text     = Text("Death_Screen_Exit_Button_Text");

// "нажмите любую кнопку", дышащий текст под глазом, пока меню не раскрыто
press_any_button_text = Text("Main_Menu_Press_Any_Button_Text");
breathe_timer = 0;

// геймпад, навигация по меню
gp_active        = false;
gp_focus         = "eye"; // eye / settings / stuff / exit
gp_save_focus    = 0;
gp_on_delete     = false;
gp_prev_nav_x    = 0;
gp_prev_nav_y    = 0;

function gp_read_nav(_gp) {
    var _x = 0, _y = 0;
    if (gamepad_button_check(_gp, gp_padl)) _x = -1;
    else if (gamepad_button_check(_gp, gp_padr)) _x = 1;
    if (gamepad_button_check(_gp, gp_padu)) _y = -1;
    else if (gamepad_button_check(_gp, gp_padd)) _y = 1;

    if (_x == 0 && _y == 0) {
        var _lx = gamepad_axis_value(_gp, gp_axislh);
        var _ly = gamepad_axis_value(_gp, gp_axislv);
        var _rx = gamepad_axis_value(_gp, gp_axisrh);
        var _ry = gamepad_axis_value(_gp, gp_axisrv);
        // берём стик с наибольшим отклонением (левый или правый)
        if (point_distance(0, 0, _rx, _ry) > point_distance(0, 0, _lx, _ly)) {
            _lx = _rx;
            _ly = _ry;
        }
        var _dz = 0.5;
        if (abs(_lx) > abs(_ly)) {
            if (abs(_lx) > _dz) _x = sign(_lx);
        } else {
            if (abs(_ly) > _dz) _y = sign(_ly);
        }
    }
    return [_x, _y];
}

function draw_gp_arrow(_x, _y, _alpha) {
    var _frame = (current_time mod (sprite_get_number(UI_ControllerArrowS) * 100)) / 100;
    var _o = 1;
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x - _o, _y, 1, 1, 0, c_black, _alpha);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x + _o, _y, 1, 1, 0, c_black, _alpha);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x, _y - _o, 1, 1, 0, c_black, _alpha);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x, _y + _o, 1, 1, 0, c_black, _alpha);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x, _y, 1, 1, 0, c_white, _alpha);
}

function select_save_file(_i) {
    save_selected = true;
    save_selected_index = _i;
    save_select_timer = 0;
    save_blink_timer = 0;
    GameControllerO.run_active = true;
    if (GameControllerO.save_exists(_i)) {
        GameControllerO.load_game(_i);
        // LevelControllerO обычно разбирает pending_inventory_names/pending_powerup_names
        GameControllerO.apply_pending_inventory_and_powerups();
    } else {
        GameControllerO.save_slot = _i;
        GameControllerO.reset_run();
        if (instance_exists(PipelineValidationO) && variable_instance_exists(PipelineValidationO, "start_new_run")) PipelineValidationO.start_new_run();
    }
    if (instance_exists(FadeTransitionO)) {
        FadeTransitionO.fade_in(0.03);
    } else {
        var _f = instance_create_layer(0, 0, "DeadL", FadeTransitionO);
        _f.fade_progress = 0;
        _f.fade_in(0.03);
    }
    alarm_set(1, 30);
}

page_just_opened = false;

function get_save_file_text(_slot) {
    if (GameControllerO.save_exists(_slot)) {
        return Text("Main_Menu_Save_File_Text_Exist_" + string(_slot + 1));
    } else {
        return Text("Main_Menu_Save_File_Text");
    }
}

wave_text_timer = 0;

function draw_wave_text(str, dx, dy, alpha) {
    if (alpha <= 0.01) exit;
    draw_set_font(SmallFnt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _total_w = string_width(str);
    var _cx = dx - _total_w * 0.5;
    for (var _i = 0; _i < string_length(str); _i++) {
        var _ch = string_char_at(str, _i + 1);
        var _wave_y = sin(wave_text_timer + _i * 0.5) * 2.5;
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

// страницы
current_page     = "none";
prev_page        = "none";
page_alpha       = 0;
page_fade_speed  = 1;

// файлы сохранения
save_file_count    = 3;
save_hovered       = array_create(save_file_count, false);
save_prev_hovered  = array_create(save_file_count, false);
save_sx            = array_create(save_file_count, 1.0);
save_sy            = array_create(save_file_count, 1.0);
save_squash_frame  = array_create(save_file_count, 0);
save_float_timer   = [];
for (var i = 0; i < save_file_count; i++) {
    array_push(save_float_timer, random(pi * 2));
}
save_spacing      = 80;
save_hover_radius = 20;
save_intro_done   = false;

// выбор сохранения
save_selected       = false;
save_selected_index = -1;
save_select_timer   = 0;
save_blink_timer    = 0;


delete_hovered      = array_create(save_file_count, false);
delete_prev_hovered = array_create(save_file_count, false);
delete_text         = Text("Main_Menu_Delete_Save_File");
delete_visible_index = -1;
delete_text_pad_x = 4;
delete_text_pad_y = 3;
delete_keep_radius = 72;