if (GameControllerO.game_paused) exit;

real_angle = (real_angle + spin_speed) mod 360;
//image_angle = (real_angle div 10) * 10;
// обновляем image_angle только каждые 10 градусов
//var snapped = floor(real_angle / 10) * 10;
//if (image_angle != snapped) {
//    image_angle = snapped;
//}

// движение по углам зоны (по часовой стрелке)
var _target = corners[(corner_index + 1) mod 4];
var _tx = _target[0];
var _ty = _target[1];

if (state == "moving") {
    move_speed = min(move_speed + move_accel, move_max_speed);
    var _dist = point_distance(x, y, _tx, _ty);

    if (_dist <= move_speed) {
        // доехали, "врезались в стену"
        x = _tx;
        y = _ty;
        corner_index = (corner_index + 1) mod 4;
        move_speed = 0;
        state = "shaking";
        shake_timer = shake_duration;
    } else {
        var _dir = point_direction(x, y, _tx, _ty);
        x += lengthdir_x(move_speed, _dir);
        y += lengthdir_y(move_speed, _dir);
    }
} else if (state == "shaking") {
    shake_timer--;
    var _t = shake_timer / shake_duration;
    var _cur = shake_strength * _t;
    shake_x = random_range(-_cur, _cur);
    shake_y = random_range(-_cur, _cur);
    if (shake_timer <= 0) {
        shake_x = 0;
        shake_y = 0;
        state = "moving";
    }
}

// урон игроку
if (instance_exists(PlayerBallerO)) {
    if (place_meeting(x, y, PlayerBallerO) && !PlayerBallerO.stunned) {
		if (PlayerBallerO.blink_time > 0 || PlayerBallerO.flying || PlayerBallerO.spawn_invuln_timer > 0) exit;
        with (PlayerBallerO) {
			GameControllerO.slow_mo(0.6, 0.3);

			hp -= 1;
			stunned = true;
			stun_time = room_speed * 0.2;
			var kb = 5;
			var dir = point_direction(other.x, other.y, x, y);
			knockback_spd_x = lengthdir_x(kb, dir);
			knockback_spd_y = lengthdir_y(kb, dir);
			audio_play_sound(Player_Hit_Snd, 0, 0);

			// мигание
			image_alpha = 1;
			blink_time = room_speed * 1.5;
			alarm[1] = 1;
        }
    }
}
