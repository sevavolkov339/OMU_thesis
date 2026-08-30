if (GameControllerO.game_paused) exit;
if (place_meeting(x, y, ChillTriggerO)) exit; // нельзя пинать в воде
if (flying) exit; // нельзя пинать во время полёта на крыльях
if (kick_cooldown > 0) exit; // маленький кулдаун между пинками, защита от спама кликами
kick_cooldown = room_speed * 0.3;

// находим только один ближайший к игроку объект в зоне удара
var _target = noone;
var _best_dist = infinity;
with (BulletBounceO) {
    if (place_meeting(x, y, BallerHitAreaO)) {
        var _d = point_distance(x, y, other.x, other.y);
        if (_d < _best_dist) {
            _best_dist = _d;
            _target = id;
        }
    }
}

if (_target != noone) {
    with (_target) {
        var _snd = audio_play_sound(Ball_Kick_Snd_1,0,0);
        audio_sound_pitch(_snd, random_range(0.8, 1.3));
        var sndd = audio_play_sound(Ball_Kick_Snd,0,0);
        audio_sound_pitch(sndd, random_range(0.8, 1.3));
        speed = 4;
        if (instance_exists(PillsPowerUpO)) {
            speed *= 1.1;
        }
        spin = 85;
        direction = point_direction(x,y,mouse_x, mouse_y);
    }
}
if mouse_x > PlayerBallerO.x {
    sprite_index = PlayerBallerKickS;
    image_xscale = 1;
    kick_facing_right = true;
} else {
    sprite_index = PlayerBallerKickS;
    image_xscale = -1;
    kick_facing_right = false;
}
allowanim = false;
alarm_set(0,15);