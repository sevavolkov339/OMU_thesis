visible = false;

depth = -1000000

// угол наклона по скорости мыши
current_angle = 0;
target_angle = 0;
angle_speed = 0;
spring_stiffness = 0.4;
spring_damping = 0.6;
prev_mouse_x = mouse_x;

// клик
click_offset = 0;
click_speed = 0;
click_stiffness = 0.4;
click_damping = 0.55;
click_strength = 60;
target_click_offset = 0;

// squish
squish_x = 1;
squish_y = 1;
squish_x_speed = 0;
squish_y_speed = 0;
squish_stiffness = 0.3;
squish_damping = 0.6;
prev_cant_afford = false;

// тряска курсора
cursor_shake_timer = 0;
cursor_shake_duration = room_speed * 0.5;

// глобальный флаг, переживает смену комнат, чтобы курсор не мигал при заходе
if (!variable_global_exists("using_gamepad")) {
    global.using_gamepad = false;
}
prev_mouse_y = mouse_y;