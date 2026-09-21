if (GameControllerO.game_paused) exit;

// smooth move
if (moving) {
    move_time++;
    var t = clamp(move_time / move_duration, 0, 1);
    var eased_t = t * t * (3 - 2 * t);
    clean_cam_x = lerp(start_x, target_x, eased_t);
    clean_cam_y = lerp(start_y, target_y, eased_t);
    if (t >= 1) {
        moving = false;
        following = true;
    }
}

// following
if (following && instance_exists(follow_target)) {
    clean_cam_x = follow_target.x - view_w * 0.5;
    clean_cam_y = follow_target.y - view_h * 0.5;
}

// шейк поверх чистой позиции
var shake_x = 0;
var shake_y = 0;
if (cam_shake_timer > 0) {
    var st = cam_shake_timer / cam_shake_duration;
    shake_x = random_range(-cam_shake_strength * st, cam_shake_strength * st);
    shake_y = random_range(-cam_shake_strength * st, cam_shake_strength * st);
    cam_shake_timer--;
}

// применяем, clean_cam_x/y никогда не трогаем шейком
camera_set_view_pos(cam, clean_cam_x + shake_x, clean_cam_y + shake_y);