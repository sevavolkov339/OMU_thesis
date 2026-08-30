var mouse_vel_x = mouse_x - prev_mouse_x;
var mouse_vel_y = mouse_y - prev_mouse_y;
prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;
target_angle = clamp(mouse_vel_x * 3, -30, 30);
var diff = angle_difference(target_angle, current_angle);
angle_speed += diff * spring_stiffness;
angle_speed *= spring_damping;
current_angle += angle_speed;
if (mouse_check_button_pressed(mb_left)) {
    click_speed += 25;
    target_click_offset = click_strength;
}
var click_diff = target_click_offset - click_offset;
click_speed += click_diff * click_stiffness;
click_speed *= click_damping;
click_offset += click_speed;
target_click_offset *= 0.85;
image_angle = -current_angle + click_offset;
// пружина squish
var _dsx = 1 - squish_x;
squish_x_speed += _dsx * squish_stiffness;
squish_x_speed *= squish_damping;
squish_x += squish_x_speed;
var _dsy = 1 - squish_y;
squish_y_speed += _dsy * squish_stiffness;
squish_y_speed *= squish_damping;
squish_y += squish_y_speed;
image_xscale = squish_x;
image_yscale = squish_y;
if (cursor_shake_timer > 0) cursor_shake_timer--;
var cursor_shake_x = 0;
var cursor_shake_y = 0;
if (cursor_shake_timer > 0) {
    cursor_shake_x = irandom_range(-3, 3);
    cursor_shake_y = irandom_range(-3, 3);
}

// visibility
var _gp = instance_exists(PlayerBallerO) ? PlayerBallerO.gamepad_index : 0;

// проверяем ввод геймпада
var _gp_any_input = false;
if (gamepad_is_connected(_gp)) {
    var _ax_lh = gamepad_axis_value(_gp, gp_axislh);
    var _ax_lv = gamepad_axis_value(_gp, gp_axislv);
    var _ax_rh = gamepad_axis_value(_gp, gp_axisrh);
    var _ax_rv = gamepad_axis_value(_gp, gp_axisrv);
    if (abs(_ax_lh) > 0.2 || abs(_ax_lv) > 0.2 || abs(_ax_rh) > 0.2 || abs(_ax_rv) > 0.2) {
        _gp_any_input = true;
    }
    if (gamepad_button_check(_gp, gp_face1) ||
        gamepad_button_check(_gp, gp_face2) ||
        gamepad_button_check(_gp, gp_face3) ||
        gamepad_button_check(_gp, gp_face4) ||
        gamepad_button_check(_gp, gp_shoulderr) ||
        gamepad_button_check(_gp, gp_shoulderl) ||
        gamepad_button_check(_gp, gp_padr) ||
        gamepad_button_check(_gp, gp_padl) ||
        gamepad_button_check(_gp, gp_padu) ||
        gamepad_button_check(_gp, gp_padd)) {
        _gp_any_input = true;
    }
}

// проверяем ввод мыши и клавиатуры
var _kb_any = keyboard_check_pressed(vk_anykey);
var _mouse_moved = (abs(mouse_vel_x) >= 1) || (abs(mouse_vel_y) >= 1);
var _mouse_any = mouse_check_button_pressed(mb_any) || _mouse_moved;

if (_gp_any_input) global.using_gamepad = true;
if (_kb_any || _mouse_any) global.using_gamepad = false;

if (global.using_gamepad) {
    visible = false;
    window_set_cursor(cr_none);
} else {
    x = mouse_x + cursor_shake_x;
    y = mouse_y + cursor_shake_y;
    sprite_index = HandS;
    visible = true;
    window_set_cursor(cr_none);
}