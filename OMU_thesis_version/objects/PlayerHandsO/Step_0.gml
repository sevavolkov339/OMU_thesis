if (!instance_exists(PlayerBallerO)) {
    instance_destroy();
    exit;
}

var _p = PlayerBallerO;
//x = _p.x;
//y = _p.y;


if (instance_exists(held_item)) {
    if (throw_state == "idle") {
        held_item.x = _p.x;
        held_item.y = _p.y;
        image_index = 0;
    } else if (throw_state == "windup") {
        var _back_dir = image_angle + 180;
        held_item.x = lerp(held_item.x, _p.x + lengthdir_x(8, _back_dir), 0.3);
        held_item.y = lerp(held_item.y, _p.y + lengthdir_y(8, _back_dir), 0.3);
        throw_timer--;
        if (throw_timer <= 0) {
            throw_state = "throw";
            image_index = 2;
            with (BulletBounceO) {
                if (place_meeting(x, y, BallerHitAreaO)) {
                    audio_play_sound(Ball_Kick_Snd, 0, 0);
                    speed = 4;
                    spin = 85;
                    direction = point_direction(x, y, mouse_x, mouse_y);
                }
            }
            held_item.item_state = "free";
            held_item.speed = 4;
            held_item.direction = image_angle;
            held_item = noone;
            throw_timer = room_speed * 2;
        }
    } else if (throw_state == "throw") {
        throw_timer--;
        if (throw_timer <= 0) {
            instance_destroy();
        }
    }
}

// пробел — бросок
if (keyboard_check_pressed(vk_space) && instance_exists(held_item) && throw_state == "idle") {
    throw_state = "windup";
    image_index = 1;
    throw_timer = room_speed * 1;
}