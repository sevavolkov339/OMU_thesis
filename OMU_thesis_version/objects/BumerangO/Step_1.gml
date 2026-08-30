if (held) {
    speed = 0;
    boom_state = "idle";
    wall_bounce_enabled = false;
    mask_index = -1;
    if (instance_exists(PlayerBallerO) && !keyboard_check(vk_space)) {
        x = -9999;
        y = -9999;
    }
    exit;
}

mask_index = sprite_index;

if (GameControllerO.game_paused) {
    if (!paused) {
        saved_speed = speed;
        saved_direction = direction;
        saved_boom_state = boom_state;
        saved_heading = heading;
        saved_arc_angle_traveled = arc_angle_traveled;
        saved_max_dist_from_origin = max_dist_from_origin;
        paused = true;
    }
    speed = 0;
    exit;
} else if (paused) {
    speed = saved_speed;
    direction = saved_direction;
    boom_state = saved_boom_state;
    heading = saved_heading;
    arc_angle_traveled = saved_arc_angle_traveled;
    max_dist_from_origin = saved_max_dist_from_origin;
    paused = false;
}
