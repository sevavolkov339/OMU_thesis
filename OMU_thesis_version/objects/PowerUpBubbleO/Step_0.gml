if (GameControllerO.game_paused) exit;

// лопание
if (popped) {
    pop_timer += sprite_get_speed(PowerUpBubbleS) / game_get_speed(gamespeed_fps);
    var _frames = sprite_get_number(PowerUpBubbleS);
    image_index = min(floor(pop_timer), _frames - 1);
    image_speed = 0;
    if (pop_timer >= _frames) {
        instance_destroy();
    }
    exit;
}

// squash stretch, медленное дыхание
float_timer += 0.02;
var breath_target_x = sin(float_timer) * 0.15 + 1;
var breath_target_y = cos(float_timer) * 0.15 + 1;
bubble_scale_x_speed += (breath_target_x - bubble_scale_x) * 0.08;
bubble_scale_x_speed *= 0.75;
bubble_scale_x += bubble_scale_x_speed;
bubble_scale_y_speed += (breath_target_y - bubble_scale_y) * 0.08;
bubble_scale_y_speed *= 0.75;
bubble_scale_y += bubble_scale_y_speed;

// движение
x += vel_x;
y += vel_y;

// отскок от стен
var _hw = (bbox_right - bbox_left) * 0.5;
var _hh = (bbox_bottom - bbox_top) * 0.5;

if (place_meeting(x + vel_x, y, wall)) {
    vel_x *= -1;
} else if (x - _hw < 0 || x + _hw > room_width) {
    vel_x *= -1;
}

if (place_meeting(x, y + vel_y, wall)) {
    vel_y *= -1;
} else if (y - _hh < 0 || y + _hh > room_height) {
    vel_y *= -1;
}

// касание игрока
if (!popped && instance_exists(PlayerBallerO)) {
    if (place_meeting(x, y, PlayerBallerO)) {
        pop();
    }
}

image_index = 0;
image_speed = 0;