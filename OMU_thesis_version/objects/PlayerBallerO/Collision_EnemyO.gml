//if (GameControllerO.game_paused) exit;

// если игрок мигает, неуязвим, игнорируем столкновение
//if (blink_time > 0) exit;

//GameControllerO.slow_mo(0.6, 0.3);

//hp -= 1;
//stunned = true;
//stun_time = room_speed * 0.2;
//var kb = 5;
//var dir = point_direction(other.x, other.y, x, y);
//knockback_spd_x = lengthdir_x(kb, dir);
//knockback_spd_y = lengthdir_y(kb, dir);
//audio_play_sound(Player_Hit_Snd, 0, 0);

// мигание
//image_alpha = 1;
//blink_time = room_speed * 1.5;
//alarm[1] = 1;

if (GameControllerO.game_paused) exit;
if (blink_time > 0 || flying || spawn_invuln_timer > 0) exit;

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
hp -= 1;
stunned = true;
stun_time = room_speed * 0.2;
var kb = 5;
var dir = point_direction(other.x, other.y, x, y);
knockback_spd_x = lengthdir_x(kb, dir);
knockback_spd_y = lengthdir_y(kb, dir);
audio_play_sound(Player_Hit_Snd, 0, 0);
image_alpha = 1;
blink_time = room_speed * 1.5;
alarm[1] = 1;