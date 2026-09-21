if (GameControllerO.game_paused) exit;

timer++;
if (timer >= lifetime) {
    instance_destroy();
    exit;
}

// движение и отскок
var next_x = x + lengthdir_x(speed, direction);
var next_y = y + lengthdir_y(speed, direction);

//if (place_meeting(next_x, y, wall)) {
//    direction = 180 - direction;
//    next_x = x + lengthdir_x(speed, direction);
//}
//if (place_meeting(x, next_y, wall)) {
//    direction = -direction;
//    next_y = y + lengthdir_y(speed, direction);
//}

x = next_x;
y = next_y;

// урон игроку
if (instance_exists(PlayerBallerO)) {
    if (place_meeting(x, y, PlayerBallerO) && !PlayerBallerO.stunned) {
		// если игрок мигает или летит, неуязвим, игнорируем столкновение
		if (PlayerBallerO.blink_time > 0 || PlayerBallerO.flying || PlayerBallerO.spawn_invuln_timer > 0) exit;
        with (PlayerBallerO) {
            hp -= 1;
            stunned = true;
            stun_time = room_speed * 0.2;
            var _dir = point_direction(other.x, other.y, x, y);
            knockback_spd_x = lengthdir_x(4, _dir);
            knockback_spd_y = lengthdir_y(4, _dir);
            audio_play_sound(Player_Hit_Snd, 0, 0);
            blink_time = room_speed * 1.5;
            alarm[1] = 1;
        }
        instance_destroy();
    }
}