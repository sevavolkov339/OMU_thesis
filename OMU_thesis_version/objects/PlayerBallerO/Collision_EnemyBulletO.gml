if (GameControllerO.game_paused) exit;
if (PlayerBallerO.blink_time > 0 || PlayerBallerO.flying || PlayerBallerO.spawn_invuln_timer > 0) exit;

// шарик поглощает удар
if (instance_exists(BalloonO) && BalloonO.try_absorb_damage()) {
    GameControllerO.slow_mo(0.6, 0.3);
    audio_play_sound(Player_Hit_Snd, 0, 0);
    stunned = true;
    stun_time = room_speed * 0.2;
    var kb = 5;
    var dir = point_direction(other.x, other.y, x, y);
    knockback_spd_x = lengthdir_x(kb, dir);
    knockback_spd_y = lengthdir_y(kb, dir);
    image_alpha = 1;
    blink_time = room_speed * 1.5;
    alarm[1] = 1;
    exit;
}

GameControllerO.slow_mo(0.6, 0.3);