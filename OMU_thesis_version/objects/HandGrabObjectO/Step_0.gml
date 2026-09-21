if (GameControllerO.game_paused) exit;
if (!instance_exists(door_ref) or instance_exists(PlayerEnterDoorO)) {
    instance_destroy();
    exit;
}
base_x = door_ref.x;
base_y = door_ref.y;
// squash пружина, всегда считается
var _dsx = 1 - grab_squash_x;
grab_squash_x_speed += _dsx * grab_squash_stiffness;
grab_squash_x_speed *= grab_squash_damping;
grab_squash_x += grab_squash_x_speed;
var _dsy = 1 - grab_squash_y;
grab_squash_y_speed += _dsy * grab_squash_stiffness;
grab_squash_y_speed *= grab_squash_damping;
grab_squash_y += grab_squash_y_speed;
// фазы захвата
switch (grab_phase) {
    case "squash":
        grab_timer++;
        if (instance_exists(grabbed_obj_ref)) {
            grabbed_obj_ref.x = lerp(grabbed_obj_ref.x, x, 0.3);
            grabbed_obj_ref.y = lerp(grabbed_obj_ref.y, y, 0.3);
            grabbed_obj_ref.image_xscale = lerp(grabbed_obj_ref.image_xscale, 0, 0.2);
            grabbed_obj_ref.image_yscale = lerp(grabbed_obj_ref.image_yscale, 0, 0.2);
        }
		if (grab_timer >= 25) {
		    grab_phase = "slide";
		    grab_timer = 0;
		    if (instance_exists(grabbed_obj_ref)) {
		        GameControllerO.carried_object = grabbed_obj_ref.object_index;
		        GameControllerO.mark_object_carried(); // ← добавить
		        instance_destroy(grabbed_obj_ref);
		    }
		}
    break;
    case "slide":
        if (grab_timer == 0) {
            audio_stop_sound(HandAppear_Snd);
            audio_play_sound(HandDissapear_Snd, 0, false);
        }
        grab_timer++;
        target_scale = 0;
        visible_scale = lerp(visible_scale, target_scale, 0.12);
        image_xscale = visible_scale * grab_squash_x;
        image_yscale = visible_scale * grab_squash_y;
        if (visible_scale < 0.02) {
            grab_phase = "done";
            instance_destroy();
        }
    break;
    case "none":
        var dist = 999;
        if (instance_exists(PlayerBallerO)) {
            dist = point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y);
        }
        if (dist < hide_distance) {
            target_scale = 0;
            can_grab = false;
        } else if (dist > show_distance) {
            target_scale = 1;
            can_grab = true;
        }
        visible_scale = lerp(visible_scale, target_scale, 0.12);
        // звук при смене направления
        if (target_scale == 1 && prev_target_scale == 0) {
            audio_stop_sound(HandDissapear_Snd);
            audio_play_sound(HandAppear_Snd, 0, false);
        }
        if (target_scale == 0 && prev_target_scale == 1) {
            audio_stop_sound(HandAppear_Snd);
            audio_play_sound(HandDissapear_Snd, 0, false);
        }
        prev_target_scale = target_scale;
        sway_timer += sway_speed_val;
        image_angle = sin(sway_timer) * sway_amplitude;
        offset_y = lerp(offset_y, 0, 0.15);
        // проверка захвата
        if (can_grab && visible_scale > 0.99) {
            var grabbed = instance_place(x, y, BulletBounceO);
            if (grabbed != noone) {
                grabbed_obj_ref = grabbed;
                grabbing = true;
                can_grab = false;
                grabbed.speed = 0;
                grabbed.held = true;
                image_index = 1;
                image_speed = 0;
                grab_squash_x_speed += 0.7;
                grab_squash_y_speed -= 0.7;
                grab_phase = "squash";
                grab_timer = 0;
                audio_play_sound(HandGrabObj_Snd, 0, false);
            }
        }
    break;
}
image_xscale = visible_scale * grab_squash_x;
image_yscale = visible_scale * grab_squash_y;
x = base_x;
y = base_y + offset_y;