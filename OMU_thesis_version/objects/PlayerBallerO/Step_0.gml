


//pause


if (GameControllerO.game_paused)
{

    speed = 0;
    hspeed = 0;
    vspeed = 0;
	image_speed = 0;

    exit;
}

if (spawn_invuln_timer > 0) spawn_invuln_timer -= 1;
if (kick_cooldown > 0) kick_cooldown -= 1;

// dying
if (hp <= 0) {
	// музыка обрывается сразу в момент смерти, не дожидаясь ухода в комнату смерти
	GameControllerO.level_music_suppressed = true;
	GameControllerO.music_stop();
	instance_create_layer(x, y, "DeadL", PlayerBallerDeadO);
	with (PlayerBallerDeadO) {
	    audio_play_sound(Player_Dead_Snd, 0, 0);
	    //var _spd = 5;
	    //var nearest_enemy = instance_nearest(x, y, EnemyO);
	    //var _dir;
	    //if (nearest_enemy != noone) {
	    //    _dir = point_direction(nearest_enemy.x, nearest_enemy.y, x, y);
	    //} else {
	    //    _dir = irandom(360);
	    //}
	    //hspeed = lengthdir_x(_spd, _dir);
	    //vspeed = lengthdir_y(_spd, _dir);
	    //image_angle = _dir;
	}
	instance_destroy();
}


if (state == PlayerState.CUTSCENE)
{
	if (GameControllerO.game_paused) exit;
    step_cutscene();
    exit; //
}



var _dsx = 1 - kick_squash_x;
kick_squash_x_speed += _dsx * kick_squash_stiffness;
kick_squash_x_speed *= kick_squash_damping;
kick_squash_x += kick_squash_x_speed;

var _dsy = 1 - kick_squash_y;
kick_squash_y_speed += _dsy * kick_squash_stiffness;
kick_squash_y_speed *= kick_squash_damping;
kick_squash_y += kick_squash_y_speed;

image_xscale = sign(image_xscale) * kick_squash_x;
image_yscale = kick_squash_y;


//water splah control
var _now_in_water = place_meeting(x, y, ChillTriggerO);
if (_now_in_water != was_in_water) {
    instance_create_layer(x, y + 4, "UIL", WaterSplashEffectO);
    var _snd = (irandom(1) == 0) ? WaterEnter1_Snd : WaterEnter2_Snd;
    var _s = audio_play_sound(_snd, 1, false);
    audio_sound_pitch(_s, random_range(0.9, 1.1));
}
was_in_water = _now_in_water;


step_play();

// полёт на крыльях только что закончился — если под ногами больше нет пола, красиво
// исчезаем и возвращаемся туда, где в последний раз стояли на земле.
// падать за пределы уровня можно только в обычных боевых комнатах — в магазине,
// чилл-комнате, сундуке и любых других (титры, боссы, меню и т.д.) это отключено
if (was_flying && !flying) {
    var _in_level_room = instance_exists(GameControllerO) && (
        GameControllerO.world_stage == "levels1" || GameControllerO.world_stage == "levels2" || GameControllerO.world_stage == "levels3"
        || GameControllerO.world_stage == "w2_levels1" || GameControllerO.world_stage == "w2_levels2" || GameControllerO.world_stage == "w2_levels3"
    ) && room != GameControllerO.room_store && room != GameControllerO.room_chill && room != GameControllerO.room_chest;

    if (_in_level_room && !place_meeting(x, y, floor_objects) && spawn_invuln_timer <= 0) {
        fly_visual_y = 0;
        hp -= 1;
        if (instance_exists(GameControllerO)) GameControllerO.player_hp = hp;
        start_cutscene("WingsFall");
    }
}
was_flying = flying;

// удар геймпадом — RB / R1
var _gp = gamepad_index;
if (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_shoulderr) && !place_meeting(x, y, ChillTriggerO) && !flying && kick_cooldown <= 0) {
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
            var _snd = audio_play_sound(Ball_Kick_Snd_1, 0, 0);
            audio_sound_pitch(_snd, random_range(0.8, 1.3));
            var sndd = audio_play_sound(Ball_Kick_Snd, 0, 0);
            audio_sound_pitch(sndd, random_range(0.8, 1.3));
            speed = 4;
            // pills powerup — удар на 10% сильнее
            if (instance_exists(PillsPowerUpO)) {
                speed *= 1.1;
            }
            spin = 85;
            var _rx = gamepad_axis_value(PlayerBallerO.gamepad_index, gp_axisrh);
            var _ry = gamepad_axis_value(PlayerBallerO.gamepad_index, gp_axisrv);
            if (abs(_rx) > 0.2 || abs(_ry) > 0.2) {
                direction = point_direction(0, 0, _rx, _ry);
            } else {
                direction = point_direction(0, 0, PlayerBallerO.image_xscale, 0);
            }
        }
    }
    with (PlayerBallerO) {
        sprite_index = PlayerBallerKickS;
        var _rx = gamepad_axis_value(gamepad_index, gp_axisrh);
        if (abs(_rx) > 0.2) {
            image_xscale = (_rx > 0) ? 1 : -1;
            kick_facing_right = (_rx > 0);
        }
        allowanim = false;
        alarm_set(0, 15);
    }
}

// debug: смена комнаты по N
if (keyboard_check_pressed(ord("N"))) {
    GameControllerO.change_room();
}

//boss

if (keyboard_check_pressed(ord("B"))) {
    room_goto(World_1_Boss_Room_Fly);
}






