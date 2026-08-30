if (GameControllerO.game_paused) exit;

real_angle = (real_angle + spin_speed) mod 360;
image_angle = (real_angle div 10) * 10;
// обновляем image_angle только каждые 10 градусов
var snapped = floor(real_angle / 10) * 10;
if (image_angle != snapped) {
    image_angle = snapped;
}

// урон игроку
if (instance_exists(PlayerBallerO)) {
    if (place_meeting(x, y, PlayerBallerO) && !PlayerBallerO.stunned) {
		if (PlayerBallerO.blink_time > 0 || PlayerBallerO.flying || PlayerBallerO.spawn_invuln_timer > 0) exit;
        with (PlayerBallerO) {
            //hp -= 1;
            //stunned = true;
            //stun_time = room_speed * 0.2;
            //var _dir = point_direction(other.x, other.y, x, y);
            //knockback_spd_x = lengthdir_x(4, _dir);
            //knockback_spd_y = lengthdir_y(4, _dir);
            //audio_play_sound(Player_Hit_Snd, 0, 0);
            //blink_time = room_speed * 1.5;
            //alarm[1] = 1;
			
			GameControllerO.slow_mo(0.6, 0.3);

			hp -= 1;
			stunned = true;
			stun_time = room_speed * 0.2;
			var kb = 5;
			var dir = point_direction(other.x, other.y, x, y);
			knockback_spd_x = lengthdir_x(kb, dir);
			knockback_spd_y = lengthdir_y(kb, dir);
			audio_play_sound(Player_Hit_Snd, 0, 0);

			// Мигание
			image_alpha = 1;
			blink_time = room_speed * 1.5;
			alarm[1] = 1;			
        }
    }
}