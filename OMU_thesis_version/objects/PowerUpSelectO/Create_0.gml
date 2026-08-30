var all_items = EveryItemScr();
var powerup_pool = [];
for (var i = 0; i < array_length(all_items); i++) {
    if (all_items[i].type == "PowerUp") {
        array_push(powerup_pool, all_items[i]);
    }
}
array_shuffle(powerup_pool);
items = [];
for (var i = 0; i < min(3, array_length(powerup_pool)); i++) {
    array_push(items, powerup_pool[i]);
}
// въезд
entry_done = false;
entry_target_y = room_height * 0.5;
entry_start_y = room_height - 50;
entry_y = entry_start_y;
entry_y_spd = 0;
entry_stiffness = 0.1;
entry_damping = 0.5;
center_x = room_width * 0.5;
center_y = entry_start_y;
// анимация для каждого
item_scale     = array_create(array_length(items), 0.5);
item_scale_spd = array_create(array_length(items), 0);
item_angle     = array_create(array_length(items), 0);
item_angle_spd = array_create(array_length(items), 0);
item_white     = array_create(array_length(items), 0);
spacing = 80;
x = room_width * 0.5;
y = entry_start_y;
mask_spr = PowerUpBubbleS;
// левитация
item_float_timer = [];
for (var i = 0; i < array_length(items); i++) {
    array_push(item_float_timer, random(pi * 3));
}
item_float_x = array_create(array_length(items), 0);
item_float_y = array_create(array_length(items), 0);
// фейд появления
fade_white = 1;
fade_speed = 0.008;
// hover
was_hovered = array_create(array_length(items), false);
item_glow_alpha = array_create(array_length(items), 0);
item_glow_angle = array_create(array_length(items), 0);
selected_index = -1;
selection_done = false;
// exit анимация
exit_y_offset = 0;
exit_y_spd = 0;
exit_shake_x = 0;
exit_shake_timer = 0;
exit_white = 0;
white_fade = instance_create_layer(0, 0, "UIL", WhiteFadeO);

wave_text_timer = 0;

// геймпад
gp_active = false;
gp_nav_active = false; // становится true после первого нажатия влево/вправо
gp_focus_index = 0;
gp_prev_nav_x = 0;

function gp_read_nav(_gp) {
    var _x = 0;
    if (gamepad_button_check(_gp, gp_padl)) _x = -1;
    else if (gamepad_button_check(_gp, gp_padr)) _x = 1;

    if (_x == 0) {
        var _lx = gamepad_axis_value(_gp, gp_axislh);
        var _rx = gamepad_axis_value(_gp, gp_axisrh);
        if (abs(_rx) > abs(_lx)) _lx = _rx;
        if (abs(_lx) > 0.5) _x = sign(_lx);
    }
    return _x;
}

function select_powerup(_i) {
    if (instance_exists(PowerUpControllerO)) {
        PowerUpControllerO.add_powerup(items[_i]);
    }
    selected_index = _i;
    selection_done = true;
    exit_y_offset = 0;
    exit_shake_timer = 20;
    if (instance_exists(InventoryControllerO)) {
        InventoryControllerO.add_item(items[_i]);
    }
    audio_play_sound(SelectWhiteTransitionRoom_Snd, 0, false);
}

function draw_item_description(_desc, _dx, _dy) {
    var _lines = string_split(_desc, "|");
    draw_set_font(SmallFnt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _line_h = string_height("Ay") + 2;
    for (var _li = 0; _li < array_length(_lines); _li++) {
        var _line = _lines[_li];
        var _ly = _dy + _li * _line_h;
        var _total_w = string_width(_line);
        var _cx = _dx - _total_w * 0.5;
        for (var _ci = 0; _ci < string_length(_line); _ci++) {
            var _ch = string_char_at(_line, _ci + 1);
            var _wave_y = sin(wave_text_timer + _ci * 0.5 + _li) * 2.5;
            var _chy = _ly + _wave_y;
            draw_set_color(c_black);
            draw_text(_cx + 1, _chy,     _ch);
            draw_text(_cx - 1, _chy,     _ch);
            draw_text(_cx,     _chy + 1, _ch);
            draw_text(_cx,     _chy - 1, _ch);
            draw_set_color(c_white);
            draw_text(_cx, _chy, _ch);
            _cx += string_width(_ch);
        }
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

function draw_gp_arrow(_x, _y) {
    var _frame = (current_time mod (sprite_get_number(UI_ControllerArrowS) * 100)) / 100;
    var _o = 1;
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x - _o, _y, 1, 1, 0, c_black, 1);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x + _o, _y, 1, 1, 0, c_black, 1);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x, _y - _o, 1, 1, 0, c_black, 1);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x, _y + _o, 1, 1, 0, c_black, 1);
    draw_sprite_ext(UI_ControllerArrowS, _frame, _x, _y, 1, 1, 0, c_white, 1);
}