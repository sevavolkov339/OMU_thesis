function step_play() {
	flying = instance_exists(WingsO) && WingsO.flying;

	if (instance_exists(GameControllerO)) {
	    GameControllerO.player_hp = hp;
	    GameControllerO.player_max_hp = max_hp;
	    GameControllerO.player_money = money;
	}

	// stun and knockback
	if (stunned) {
	    hspeed = knockback_spd_x;
	    vspeed = knockback_spd_y;
	    knockback_spd_x *= 0.85;
	    knockback_spd_y *= 0.85;
	    stun_time--;
	    if (stun_time <= 0) stunned = false;
	} else {
		var _gp = gamepad_index;
		var _gp_connected = gamepad_is_connected(_gp);

		// стик
		var _stick_x = _gp_connected ? gamepad_axis_value(_gp, gp_axislh) : 0;
		var _stick_y = _gp_connected ? gamepad_axis_value(_gp, gp_axislv) : 0;
		var _deadzone = 0.2;
		if (abs(_stick_x) < _deadzone) _stick_x = 0;
		if (abs(_stick_y) < _deadzone) _stick_y = 0;

		rightKey = keyboard_check(vk_right) || keyboard_check(ord("D")) || (_gp_connected && (gamepad_button_check(_gp, gp_padr) || _stick_x > _deadzone));
		leftKey  = keyboard_check(vk_left)  || keyboard_check(ord("A")) || (_gp_connected && (gamepad_button_check(_gp, gp_padl) || _stick_x < -_deadzone));
		upKey    = keyboard_check(vk_up)    || keyboard_check(ord("W")) || (_gp_connected && (gamepad_button_check(_gp, gp_padu) || _stick_y < -_deadzone));
		downKey  = keyboard_check(vk_down)  || keyboard_check(ord("S")) || (_gp_connected && (gamepad_button_check(_gp, gp_padd) || _stick_y > _deadzone));

		// пиво инвертирует управление движением, пока предмет в инвентаре
		if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) {
		    var _swap_h = rightKey; rightKey = leftKey; leftKey = _swap_h;
		    var _swap_v = upKey; upKey = downKey; downKey = _swap_v;
		}

		// направление взгляда — нужно для крыльев, спрайтов полёта и предметов вроде сигареты.
		// Последовательные перезаписи (без else), с тем же приоритетом (вверх > вниз > влево > вправо),
		// что и при выборе спрайта ходьбы ниже — иначе при диагональном вводе (например вверх+вправо)
		// facing и реальный спрайт игрока расходятся, и следующие за игроком предметы "рассинхронизируются"
		if (rightKey) facing = "right";
		if (leftKey) facing = "left";
		if (downKey) facing = "down";
		if (upKey) facing = "up";

		// стик влияет на скорость плавно
		var cur_move_spd = holding_obj ? moveSpd * 0.6 : moveSpd;
		if (_gp_connected && abs(_stick_x) > _deadzone) {
		    var moveX = _stick_x * cur_move_spd;
		    hspeed = moveX;
		}
		if (_gp_connected && abs(_stick_y) > _deadzone) {
		    var moveY = _stick_y * cur_move_spd;
		    vspeed = moveY;
		}
		var _in_water_spd = place_meeting(x, y, ChillTriggerO);
		var cur_move_spd = holding_obj ? moveSpd * 0.6 : moveSpd;
		if (flying) {
		    cur_move_spd = moveSpd * 1.15; // в полёте чуть быстрее обычного
		    if (room != GameControllerO.room_store) {
		        layer = layer_get_id("EnemyBulletsL");
		    }
		} else if (_in_water_spd) {
		    cur_move_spd *= 0.2;
		    //if (layer != layer_get_id("PlayerL")) {
		    layer = layer_get_id("PlayerL");

		} else {
		    if (room != GameControllerO.room_store) {
		        //if (layer != layer_get_id("EnemyBulletsL")) {
		        layer = layer_get_id("EnemyBulletsL");

		    }
		}
		var moveX = (rightKey - leftKey) * cur_move_spd;
		var moveY = (downKey - upKey) * cur_move_spd;
		if (flying) {
		    // в полёте — плавный разгон к целевой скорости и такое же плавное торможение,
		    // а не мгновенный щелчок скорости, как при обычной ходьбе
		    var _fly_accel = 0.1;
		    hspeed = lerp(hspeed, moveX, _fly_accel);
		    vspeed = lerp(vspeed, moveY, _fly_accel);
		    if (moveX == 0 && abs(hspeed) < minSpd) hspeed = 0;
		    if (moveY == 0 && abs(vspeed) < minSpd) vspeed = 0;
		} else {
		    var _water_frict = place_meeting(x, y, ChillTriggerO) ? 0.97 : frict;
		    if (moveX != 0) hspeed = moveX;
		    else {
		        hspeed *= _water_frict;
		        if (abs(hspeed) < minSpd) hspeed = 0;
		    }
		    if (moveY != 0) vspeed = moveY;
		    else {
		        vspeed *= _water_frict;
		        if (abs(vspeed) < minSpd) vspeed = 0;
		    }
		}
	}

	//// подбор/бросок по E
	//if (keyboard_check_pressed(ord("E"))) {
	//    if (!holding_obj && !throw_windup) {
	//        var _nearest = instance_nearest(x, y, BulletBounceO);
	//        if (_nearest != noone && instance_exists(_nearest) && !_nearest.held) {
	//            var _d = point_distance(x, y, _nearest.x, _nearest.y);
	//            if (_d < 30) {
	//                holding_obj = true;
	//                _nearest.held = true;
	//                held_ref = _nearest;
	//                sprite_index = PlayerBallerGoRightHandsS;
	//                image_index = 0;
	//                image_speed = 0;
	//                throw_windup = false;
	//                throw_timer = 0;
	//            }
	//        }
	//	} else if (holding_obj && !throw_windup) {
	//	    if (instance_exists(held_ref)) {
	//	        held_ref.held = false;
	//	        held_ref.mask_index = held_ref.sprite_index;
	//	        held_ref.x = x;
	//	        held_ref.y = y;
	//	    }
	//	    holding_obj = false;
	//	    held_ref = noone;
	//	    image_xscale = 1;
	//	    throw_timer = 0;
	//	    throw_charge = 0;
	//	    allowanim = true;
	//	}
	//}
	
	////// предмет следует за игроком
	////if (holding_obj && instance_exists(held_ref)) {
	////    held_ref.x = x;
	////    held_ref.y = y;
	////}	

	//// пробел — замах и бросок
	//if (holding_obj) {
	//    if (keyboard_check(vk_space) && !throw_windup) {
	//        sprite_index = PlayerBallerGoRightHandsWindS;
	//        allowanim = false;
	//        image_xscale = (mouse_x >= x) ? 1 : -1;
	//        image_speed = 1;

	//        // заряд
	//        throw_charge = min(throw_charge + 1, throw_charge_max);
	//        var _charge_t = throw_charge / throw_charge_max;

	//        // тряска объекта — усиливается с зарядом
	//        var _shake_amt = _charge_t * 3;
	//        throw_shake_x = random_range(-_shake_amt, _shake_amt);
	//        throw_shake_y = random_range(-_shake_amt, _shake_amt);

	//        // объект уходит за спину
	//        if (instance_exists(held_ref)) {
	//            var _back = image_xscale * -8;
	//            held_ref.x = x + _back + throw_shake_x;
	//            held_ref.y = y - 10 + throw_shake_y;
	//        }
	//    } else if (!keyboard_check(vk_space) && !throw_windup) {
	//        throw_shake_x = 0;
	//        throw_shake_y = 0;
	//    }

	//    if (keyboard_check_released(vk_space) && !throw_windup) {
	//        throw_windup = true;
	//        throw_locked_xscale = image_xscale;
	//        sprite_index = PlayerBallerGoRightHandsThrowS;
	//        image_xscale = throw_locked_xscale;
	//        image_index = 0;
	//        image_speed = 1;
	//        allowanim = false;
	//        throw_timer = room_speed * 0.5;

	//        // скорость броска зависит от заряда
	//        var _charge_t = throw_charge / throw_charge_max;
	//        var _throw_speed = lerp(3, 10, _charge_t);
	//        throw_charge = 0;

	//        if (instance_exists(held_ref)) {
	//		    held_ref.held = false;
	//		    held_ref.mask_index = held_ref.sprite_index;
	//		    held_ref.x = x; // восстанавливаем позицию на игрока
	//		    held_ref.y = y;
	//		    held_ref.speed = _throw_speed;
	//		    held_ref.direction = point_direction(x, y, mouse_x, mouse_y);
	//		    held_ref = noone;
	//		    holding_obj = false;
	//		}
	//    }
	//}

	//// таймер после броска
	//if (throw_windup) {
	//    sprite_index = PlayerBallerGoRightHandsThrowS;
	//    image_xscale = throw_locked_xscale;
	//    throw_timer--;
	//    if (throw_timer <= 0) {
	//        throw_windup = false;
	//        allowanim = true;
	//        image_xscale = 1;
	//    }
	//}

	//speed = point_distance(0, 0, hspeed, vspeed);

	// animation
	var cur_frame = floor(image_index);
	// в мире 2 вместо пыли под ногами остаются вмятины в снегу; в остальных мирах — обычная пыль
	var _in_world_2 = instance_exists(GameControllerO) && string_pos("w2_", GameControllerO.world_stage) == 1;
	if (speed > minSpd) {
	    if (!throw_windup) image_speed = 1;
	    if (cur_frame != prev_frame && cur_frame == 1) {
	        // в мире 2 вместо пыли под ногами остаются следы; в остальных мирах — обычная пыль
	        var _step_fx = noone;

	        switch (sprite_index) {
	            case PlayerBallerGoRightS:
	                if (_in_world_2) {
	                    _step_fx = instance_create_layer(x - 3, y + 6.5, "EffectsL", StepEffectO);
	                    _step_fx.image_xscale = -1;
	                    _step_fx.image_angle = 0;
	                } else {
	                    instance_create_layer(x - 3, y + 6.5, "EffectsL", DustEffectO);
	                }
	                var snd = audio_play_sound(Step_Snd, 1, false);
	                audio_sound_pitch(snd, random_range(0.9, 1.1));
	            break;
	            case PlayerBallerGoLeftS:
	                if (_in_world_2) {
	                    _step_fx = instance_create_layer(x + 3, y + 6.5, "EffectsL", StepEffectO);
	                    _step_fx.image_xscale = 1;
	                    _step_fx.image_angle = 0;
	                } else {
	                    instance_create_layer(x + 3, y + 6.5, "EffectsL", DustEffectO);
	                }
	                var snd = audio_play_sound(Step_Snd, 1, false);
	                audio_sound_pitch(snd, random_range(0.9, 1.1));
	            break;
	            case PlayerBallerGoUpS:
	                if (_in_world_2) {
	                    _step_fx = instance_create_layer(x, y + 6.5, "EffectsL", StepEffectO);
	                    _step_fx.image_xscale = 1;
	                    _step_fx.image_angle = -90;
	                } else {
	                    instance_create_layer(x, y + 6.5, "EffectsL", DustEffectO);
	                }
	                var snd = audio_play_sound(Step_Snd, 1, false);
	                audio_sound_pitch(snd, random_range(0.9, 1.1));
	            break;
	            case PlayerBallerGoDownS:
	                if (_in_world_2) {
	                    _step_fx = instance_create_layer(x, y - 6.5, "EffectsL", StepEffectO);
	                    _step_fx.image_xscale = 1;
	                    _step_fx.image_angle = 90;
	                } else {
	                    instance_create_layer(x, y - 6.5, "EffectsL", DustEffectO);
	                }
	                var snd = audio_play_sound(Step_Snd, 1, false);
	                audio_sound_pitch(snd, random_range(0.9, 1.1));
	            break;
	        }

	        if (_step_fx != noone) {
	            _step_fx.image_index = step_effect_frame;
	            step_effect_frame = 1 - step_effect_frame; // чередуем кадр 0/1 на каждый шаг
	        }
	    }
	} else {
	    if (!throw_windup) {
	        image_speed = 0;
	        if (!rightKey && !leftKey && !downKey && !upKey && !mouse_check_button_pressed(mb_left)) {
	            if (!holding_obj && allowanim) {
	                var _in_water_idle = place_meeting(x, y, ChillTriggerO);
	                sprite_index = _in_water_idle ? PlayerBallerIdleInWaterS : PlayerBallerIdleS;
	            }
	        }
	    }
	}
	prev_frame = cur_frame;

	// wall collision — в полёте крылья игнорируют стены полностью
	if (!flying) {
	    var max_iterations = 4;
	    var iteration = 0;
	    var original_hspeed = hspeed;
	    var original_vspeed = vspeed;

	    while (iteration < max_iterations) {
	        var next_x = x + hspeed;
	        var next_y = y + vspeed;
	        if (place_meeting(next_x, next_y, wall)) {
	            var surface_normal = collision_normal(next_x, next_y, wall, 8, 1);
	            if (surface_normal != -1) {
	                var normal_x = lengthdir_x(1, surface_normal);
	                var normal_y = lengthdir_y(1, surface_normal);
	                var dot = (hspeed * normal_x + vspeed * normal_y);
	                if (dot < 0) {
	                    hspeed = hspeed - (dot * normal_x);
	                    vspeed = vspeed - (dot * normal_y);
	                    var push_strength = 0.1;
	                    hspeed += normal_x * push_strength;
	                    vspeed += normal_y * push_strength;
	                } else {
	                    break;
	                }
	            } else {
	                if (!place_meeting(x + hspeed, y, wall)) {
	                    vspeed = 0;
	                    break;
	                } else if (!place_meeting(x, y + vspeed, wall)) {
	                    hspeed = 0;
	                    break;
	                } else {
	                    while (!place_meeting(x + sign(hspeed), y, wall) && hspeed != 0) x += sign(hspeed);
	                    while (!place_meeting(x, y + sign(vspeed), wall) && vspeed != 0) y += sign(vspeed);
	                    hspeed = 0;
	                    vspeed = 0;
	                    break;
	                }
	            }
	            iteration++;
	        } else {
	            break;
	        }
	    }

	    if (place_meeting(x + hspeed, y + vspeed, wall)) {
	        var push_out_normal = collision_normal(x, y, wall, 8, 1);
	        if (push_out_normal != -1) {
	            x += lengthdir_x(1, push_out_normal);
	            y += lengthdir_y(1, push_out_normal);
	        }
	        hspeed = 0;
	        vspeed = 0;
	    }
	} else {
	    x += hspeed;
	    y += vspeed;
	}

	// sprite control when moving
	if (flying && allowanim) {
	    switch (facing) {
	        case "right": sprite_index = PlayerBallerFlyRightS; break;
	        case "left":  sprite_index = PlayerBallerFlyLeftS; break;
	        case "up":    sprite_index = PlayerBallerFlyUpS; break;
	        default:      sprite_index = PlayerBallerFlyDownS; break;
	    }
	    image_xscale = 1;
	    image_index = 0;
	    image_speed = 0;
	} else if (speed > minSpd && !stunned && !throw_windup) {
	    var _in_water = place_meeting(x, y, ChillTriggerO);
	    if (holding_obj) {
	        if (rightKey && allowanim) { sprite_index = PlayerBallerGoRightHandsS; image_xscale = 1; }
	        if (leftKey  && allowanim) { sprite_index = PlayerBallerGoRightHandsS; image_xscale = -1; }
	        if (downKey  && allowanim) sprite_index = PlayerBallerGoRightHandsS;
	        if (upKey    && allowanim) sprite_index = PlayerBallerGoRightHandsS;
	    } else if (_in_water) {
	        if (rightKey && allowanim) sprite_index = PlayerBallerGoRightInWaterS;
	        if (leftKey  && allowanim) sprite_index = PlayerBallerGoLeftInWaterS;
	        if (downKey  && allowanim) sprite_index = PlayerBallerGoDownInWaterS;
	        if (upKey    && allowanim) sprite_index = PlayerBallerGoUpInWaterS;
	    } else {
	        if (rightKey && allowanim) sprite_index = PlayerBallerGoRightS;
	        if (leftKey  && allowanim) sprite_index = PlayerBallerGoLeftS;
	        if (downKey  && allowanim) sprite_index = PlayerBallerGoDownS;
	        if (upKey    && allowanim) sprite_index = PlayerBallerGoUpS;
	    }
	}

	// визуальный подъём/пружина и дыхание альфой во время полёта (тень при этом остаётся на месте)
	if (flying) {
	    fly_bob_timer += 0.2;
	    fly_visual_y = lerp(fly_visual_y, -16 + sin(fly_bob_timer) * 3, 0.2);
	    fly_alpha_timer += 0.09;
	    image_alpha = 0.55 + sin(fly_alpha_timer) * 0.35;
	} else {
	    fly_visual_y = lerp(fly_visual_y, 0, 0.25);
	    if (abs(fly_visual_y) < 0.05) fly_visual_y = 0;
	    if (blink_time <= 0 && state != PlayerState.CUTSCENE) image_alpha = 1;
	}

	// запоминаем последнюю позицию на полу, чтобы вернуть сюда игрока, если он улетит за пределы уровня
	if (!flying && place_meeting(x, y, floor_objects)) {
	    last_floor_x = x;
	    last_floor_y = y;
	}

	// первое касание воды — запускаем катсцену
	if (place_meeting(x, y, ChillTriggerO) && !chill_triggered) {
	    chill_triggered = true;
	    start_cutscene("ChillScene");
	}

	//// dying
	//if (hp <= 0) {
	//    instance_create_layer(x, y, "DeadL", PlayerBallerDeadO);
	//    with (PlayerBallerDeadO) {
	//        audio_play_sound(Player_Dead_Snd, 0, 0);
	//        //var _spd = 5;
	//        //var nearest_enemy = instance_nearest(x, y, EnemyO);
	//        //var _dir;
	//        //if (nearest_enemy != noone) {
	//        //    _dir = point_direction(nearest_enemy.x, nearest_enemy.y, x, y);
	//        //} else {
	//        //    _dir = irandom(360);
	//        //}
	//        //hspeed = lengthdir_x(_spd, _dir);
	//        //vspeed = lengthdir_y(_spd, _dir);
	//        //image_angle = _dir;
	//    }
	//    instance_destroy();
	//}
}
//gamepad support
gamepad_index = 0; // слот геймпада


//holding and lifting objects

holding_obj = false;
held_ref = noone;

throw_windup = false;
throw_timer = 0;
throw_locked_xscale = 1;

throw_charge = 0;
throw_charge_max = room_speed * 1.5;
throw_shake_x = 0;
throw_shake_y = 0;

// сторона последнего удара — отдельная переменная специально для таких вещей как сигарета,
// потому что image_xscale во время удара в некоторых случаях перезаписывается другим кодом
// (сквош-пружина, полёт и т.д.) и не годится как надёжный источник направления удара
kick_facing_right = true;

//squash and stretch

kick_squash_x = 1;
kick_squash_y = 1;
kick_squash_x_speed = 0;
kick_squash_y_speed = 0;
kick_squash_stiffness = 0.3;
kick_squash_damping = 0.6;


//movement
moveSpd = 2;
vspeed = 0;
hspeed = 0;
frict = 0.85; // Higher values mean more friction (slows down faster)
minSpd = 0.1; // Minimum speed before stopping completely
instance_create_layer(x,y,"CodingStuffL",BallerHitAreaO);
allowanim = true;
_in_water_spd = place_meeting(x, y, ChillTriggerO);


//stats
// Забираем данные из GameControllerO
if (instance_exists(GameControllerO)) {
    hp = GameControllerO.player_hp;
    max_hp = GameControllerO.player_max_hp;
    money = GameControllerO.player_money;
}

// Оглушение
stunned = false;
stun_time = 0;

// Отталкивание
knockback_spd_x = 0;
knockback_spd_y = 0;

blink_time = 0;

// маленький кулдаун между пинками — иначе при очень быстром спаме кликов пинок фактически
// постоянно "зажат" и все предметы разлетаются от игрока разом
kick_cooldown = 0;

// неуязвимость в первые 1.5 секунды после старта уровня — без мигания (просто тихо игнорируем урон)
spawn_invuln_timer = 0;
var _in_level_room_on_spawn = instance_exists(GameControllerO) && (
    GameControllerO.world_stage == "levels1" || GameControllerO.world_stage == "levels2" || GameControllerO.world_stage == "levels3"
    || GameControllerO.world_stage == "w2_levels1" || GameControllerO.world_stage == "w2_levels2" || GameControllerO.world_stage == "w2_levels3"
) && room != GameControllerO.room_store && room != GameControllerO.room_chill && room != GameControllerO.room_chest;
if (_in_level_room_on_spawn) {
    spawn_invuln_timer = room_speed * 1.5;
}

//for anim

prev_frame = -1;

// следы от шагов (только в мире 2) — чередуем кадр спрайта следа на каждый шаг
step_effect_frame = 0;

//wall = WallO

wall = [WallO, WallTriangleO, WallFollowMachineO]

// ===== крылья (WingsO) и полёт =====
facing = "down"; // текущее направление взгляда — для крыльев и спрайтов полёта

flying = false;
was_flying = false;

fly_visual_y = 0;  // визуальный подъём над землёй во время полёта (тень остаётся на месте)
fly_bob_timer = 0; // лёгкая пружина вверх-вниз во время полёта
fly_alpha_timer = 0; // дыхание альфой во время полёта

// все объекты пола в комнате — по ним определяем, вылетел ли игрок за пределы уровня
floor_objects = [FloorLevel1O, FloorLevel2O, FloorLevel3O, FloorLevel4O, FloorLevel5O, FloorLevel6O, FloorLevel2_World_2_O, FloorStoreO];
last_floor_x = x;
last_floor_y = y;

//player states

chill_triggered = false;
// при загрузке в чилл комнату — проверяем уже ли лечились
if (instance_exists(GameControllerO)) {
    var _chill_state = GameControllerO.get_current_room_state();
    if (_chill_state != undefined && _chill_state.chill_healed) {
        chill_triggered = true;
    }
}

enum PlayerState {
    PLAY,
    CUTSCENE
}

state = PlayerState.PLAY;

//cutscenes and functions
bubble1 = noone;
bubble2 = noone;
bubble1_spread = 15;

cutscene_name = "";
cutscene_step = 0;
cutscene_timer = 0;

function start_cutscene(_name)
{
    if (_name == "" || is_undefined(_name)) exit;

    state = PlayerState.CUTSCENE;
    cutscene_name = _name;
    cutscene_step = 0;
    cutscene_timer = 0;
    hspeed = 0;
    vspeed = 0;
}

function stop_cutscene()
{
    state = PlayerState.PLAY;
    cutscene_name = "";
    cutscene_step = 0;
    cutscene_timer = 0;
}

function end_cutscene()
{
    stop_cutscene();
    allowanim = true;
    image_speed = 1;

    if (instance_exists(LevelControllerO))
    {
        with (LevelControllerO)
        {
            on_cutscene_finished();
        }
    }
}


function step_cutscene() {
    if (GameControllerO.game_paused) exit;
    cutscene_update();
}

function cutscene_update() {
	switch (cutscene_name)
	{
		case "ChillScene":
			cutscene_chill();
		break;
		
	    case "ElevatorEnterTop":
	        cutscene_enter_top();
	    break;

	    case "ElevatorEnterLeft":
	        cutscene_enter_left();
	    break;

	    case "ElevatorEnterRight":
	        cutscene_enter_right();
	    break;
		
		case "ElevatorArriveBottom":
		    cutscene_arrive_bottom();
		break;
		
		case "ElevatorArriveLeft":
		    cutscene_arrive_left();
		break;
		
		case "ElevatorArriveRight":
		    cutscene_arrive_right();
		break;

		case "WingsFall":
		    cutscene_wings_fall();
		break;
	}
}

// игрок улетел за пределы уровня на крыльях — исчезаем на месте, потом появляемся
// там, где в последний раз стояли на полу (аналог анимации PlayerEnterDoorO, но без смены комнаты)
function cutscene_wings_fall() {
    cutscene_timer++;

    switch (cutscene_step) {
        case 0:
            image_angle -= (image_xscale < 0) ? -15 : 15;
            image_xscale = lerp(image_xscale, 0, 0.08);
            image_yscale = lerp(image_yscale, 0, 0.08);
            image_alpha = lerp(image_alpha, 0, 0.08);
            if (image_alpha < 0.05) {
                instance_create_layer(x, y, "EffectsL", DustEffectO);
                x = last_floor_x;
                y = last_floor_y;
                image_angle = 0;
                image_xscale = 1;
                image_yscale = 1;
                sprite_index = PlayerBallerIdleS;
                image_index = 0;
                image_speed = 0;
                instance_create_layer(x, y, "EffectsL", DustEffectO);
                cutscene_step = 1;
                cutscene_timer = 0;
            }
        break;

        case 1:
            image_alpha = lerp(image_alpha, 1, 0.1);
            if (image_alpha > 0.95) {
                image_alpha = 1;
                blink_time = room_speed * 1.5;
                alarm[1] = 1;
                end_cutscene();
            }
        break;
    }
}


function cutscene_chill() {
    cutscene_timer++;
    
    if (!instance_exists(HotSpringPoolO)) {
        end_cutscene();
        return;
    }
    var _target_x = HotSpringPoolO.x;
    var _target_y = HotSpringPoolO.y;
    
    switch (cutscene_step) {
        case 0:
            // плывём к центру с замедлением
            var _dx = _target_x - x;
	            var _dy = _target_y - y;
            x += _dx * 0.06;
            y += _dy * 0.06;
            // анимация направления
            if (abs(_dx) > abs(_dy)) {
                sprite_index = (_dx > 0) ? PlayerBallerGoRightInWaterS : PlayerBallerGoLeftInWaterS;
            } else {
                sprite_index = (_dy > 0) ? PlayerBallerGoDownInWaterS : PlayerBallerGoUpInWaterS;
            }
            image_speed = 1;
            // достигли центра
            if (point_distance(x, y, _target_x, _target_y) < 1) {
                x = _target_x;
                y = _target_y;
                cutscene_step = 1;
                cutscene_timer = 0;
                sprite_index = PlayerBallerChillS;
                image_index = 0;
                image_speed = 1;
            }
        break;
        
		case 1:
		    if (cutscene_timer == 1) {
		        if (instance_exists(HotSpringPoolO)) {
		            var _spread = random_range(10, 30);
		            bubble1 = instance_create_layer(x - _spread, y - 3, "UIL", ChillBubbleO);
		            bubble1_spread = _spread; // запоминаем для второго
		        }
		    }
		    // второй бабл с задержкой
		    if (cutscene_timer == 12) {
		        if (instance_exists(HotSpringPoolO)) {
		            bubble2 = instance_create_layer(x + bubble1_spread, y - 3, "UIL", ChillBubbleO);
		        }
		    }
			if (cutscene_timer >= room_speed * 0.8 && cutscene_timer < room_speed * 0.8 + 1) {
			    hp = min(hp + 1, max_hp);
			    if (instance_exists(GameControllerO)) {
			        GameControllerO.player_hp = hp;
			        GameControllerO.mark_chill_healed(); // <- добавь
			    }
			    if (instance_exists(bubble1)) bubble1.popped = true;
			}
		    if (cutscene_timer >= room_speed * 1.6 && cutscene_timer < room_speed * 1.6 + 1) {
		        hp = min(hp + 1, max_hp);
		        if (instance_exists(GameControllerO)) GameControllerO.player_hp = hp;
		        if (instance_exists(bubble2)) bubble2.popped = true;
		    }
		    var _both_popped = !instance_exists(bubble1) && !instance_exists(bubble2);
		    if (_both_popped && image_index >= image_number - 1) {
		        cutscene_step = 2;
		        cutscene_timer = 0;
		    }
		break;
        
        case 2:
            end_cutscene();
        break;
    }
}

function start_elevator_exit(_lift)
{
    state = PlayerState.CUTSCENE;
    current_lift = _lift;	

    switch (_lift.object_index)
    {
        case ElevatorBottomO:
            start_cutscene("ElevatorArriveBottom");
        break;

        case ElevatorLeftO:
            start_cutscene("ElevatorArriveLeft");
        break;

        case ElevatorRightO:
            start_cutscene("ElevatorArriveRight");
        break;
    }
}


function cutscene_enter_elevator() {

    cutscene_timer++;

    switch (cutscene_step) {

        // Шаг 0 — go straight
        case 0:
            sprite_index = PlayerBallerGoUpS;
            vspeed = -1.5;

            if (cutscene_timer > room_speed * 2) {
                hspeed = 0;
                cutscene_step++;
                cutscene_timer = 0;
            }
        break;

        // Шаг 1 — пауза
        case 1:
            sprite_index = PlayerBallerIdleS;

            if (cutscene_timer > room_speed * 6) {
                cutscene_step++;
                cutscene_timer = 0;
            }
        break;

        // Шаг 2 — конец катсцены
        case 2:
            end_cutscene();
        break;
    }
}



function cutscene_exit_elevator() {

    cutscene_timer++;

    switch (cutscene_step) {

        // Шаг 0 — go straight
        case 0:
            sprite_index = PlayerBallerGoUpS;
            vspeed = -1.5;

            if (cutscene_timer > room_speed * 2) {
                hspeed = 0;
                cutscene_step++;
                cutscene_timer = 0;
            }
        break;

        // Шаг 1 — пауза
        case 1:
            sprite_index = PlayerBallerIdleS;

            if (cutscene_timer > room_speed) {
                cutscene_step++;
                cutscene_timer = 0;
            }
        break;

        // Шаг 2 — конец катсцены
        case 2:
            end_cutscene();
        break;
    }
}




function cutscene_enter_top()
{
    cutscene_timer++;

    // получаем ссылку на лифт, с которым мы связаны
    var lift = instance_nearest(x, y, ElevatorTopO); // или передавайте enter_lift как переменную
    if (lift == noone) return;

    // цель — центр лифта
    var target_x = lift.x;
    var target_y = lift.y; // можно сместить на дверь, если нужно

    switch (cutscene_step)
    {
        case 0:
            // вычисляем разницу для движения
            var dx = target_x - x;
            var dy = target_y - y;

            // горизонтальное движение
            if (abs(dx) > 1) {
                hspeed = dx * 0.05;
            } else {
                hspeed = 0;
                x = target_x;
            }

            // вертикальное движение
            if (abs(dy) > 1) {
                vspeed = dy * 0.05;
            } else {
                vspeed = 0;
                y = target_y;
            }

            // проигрываем анимацию движения вверх, если есть движение
            if (abs(hspeed) > 0.1 || abs(vspeed) > 0.1) {
                sprite_index = PlayerBallerGoUpS;
                image_speed = 1;
            } else {
                sprite_index = PlayerBallerIdleS;
                image_speed = 0;
            }

            // Если достигли позиции — переходим к следующему шагу
            if (abs(x - target_x) <= 1 && abs(y - target_y) <= 1)
            {
                cutscene_step++;
                cutscene_timer = 0;
                hspeed = 0;
                vspeed = 0;
            }			
        break;

        case 1:
			with ElevatorTopO{
				door_close()	
			}
			x = ElevatorTopO.x
			y = ElevatorTopO.y
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;

            // короткая паузак перед завершением катсцены
            if (cutscene_timer > room_speed * 5)
            {
                end_cutscene();
            }
        break;
    }
}




function cutscene_enter_left()
{
    cutscene_timer++;

    // получаем ссылку на лифт, с которым мы связаны
    var lift = instance_nearest(x, y, ElevatorLeftO); // или передавайте enter_lift как переменную
    if (lift == noone) return;

    // цель — центр лифта
    var target_x = lift.x;
    var target_y = lift.y; // можно сместить на дверь, если нужно

    switch (cutscene_step)
    {
        case 0:
            // вычисляем разницу для движения
            var dx = target_x - x;
            var dy = target_y - y;

            // горизонтальное движение
            if (abs(dx) > 1) {
                hspeed = dx * 0.05;
            } else {
                hspeed = 0;
                x = target_x;
            }

            // вертикальное движение
            if (abs(dy) > 1) {
                vspeed = dy * 0.05;
            } else {
                vspeed = 0;
                y = target_y;
            }

            // проигрываем анимацию движения влево, если есть движение
            if (abs(hspeed) > 0.1 || abs(vspeed) > 0.1) {
                sprite_index = PlayerBallerGoLeftS;
                image_speed = 1;
            } else {
                sprite_index = PlayerBallerIdleS;
                image_speed = 0;
            }

            // Если достигли позиции — переходим к следующему шагу
            if (abs(x - target_x) <= 1 && abs(y - target_y) <= 1)
            {
                cutscene_step++;
                cutscene_timer = 0;
                hspeed = 0;
                vspeed = 0;
            }			
        break;

        case 1:
			with ElevatorLeftO{
				door_close()	
			}
			x = ElevatorLeftO.x
			y = ElevatorLeftO.y
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;

            // короткая паузак перед завершением катсцены
            if (cutscene_timer > room_speed * 5)
            {
                end_cutscene();
            }
        break;
    }
}


function cutscene_enter_right()
{
    cutscene_timer++;

    // получаем ссылку на лифт, с которым мы связаны
    var lift = instance_nearest(x, y, ElevatorRightO); // или передавайте enter_lift как переменную
    if (lift == noone) return;

    // цель — центр лифта
    var target_x = lift.x;
    var target_y = lift.y; // можно сместить на дверь, если нужно

    switch (cutscene_step)
    {
        case 0:
            // вычисляем разницу для движения
            var dx = target_x - x;
            var dy = target_y - y;

            // горизонтальное движение
            if (abs(dx) > 1) {
                hspeed = dx * 0.05;
            } else {
                hspeed = 0;
                x = target_x;
            }

            // вертикальное движение
            if (abs(dy) > 1) {
                vspeed = dy * 0.05;
            } else {
                vspeed = 0;
                y = target_y;
            }

            // проигрываем анимацию движения вправо, если есть движение
            if (abs(hspeed) > 0.1 || abs(vspeed) > 0.1) {
                sprite_index = PlayerBallerGoRightS;
                image_speed = 1;
            } else {
                sprite_index = PlayerBallerIdleS;
                image_speed = 0;
            }

            // Если достигли позиции — переходим к следующему шагу
            if (abs(x - target_x) <= 1 && abs(y - target_y) <= 1)
            {
                cutscene_step++;
                cutscene_timer = 0;
                hspeed = 0;
                vspeed = 0;
            }			
        break;

        case 1:
			with ElevatorRightO{
				door_close()	
			}
			x = ElevatorRightO.x
			y = ElevatorRightO.y
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;

            // короткая паузак перед завершением катсцены
            if (cutscene_timer > room_speed * 5)
            {
                end_cutscene();
            }
        break;
    }
}





function cutscene_arrive_left()
{
    cutscene_timer++;

    var lift = current_lift
    if (!instance_exists(lift)) return;

    switch (cutscene_step)
    {
        /// STEP 0 — ждём и открываем двери
        case 0:
			x = lift.x
			y = lift.y
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;
            hspeed = 0;
            vspeed = 0;

            with (lift)
            {
                door_open();
            }
			

            if (cutscene_timer > room_speed * 1.5)
            {
                cutscene_step = 1;
                cutscene_timer = 0;
            }			
        break;

        /// STEP 1 — игрок выходит из лифта влево
        case 1:
			with (CameraControllerO){
				camera_move_to_room_center()	
			}				
			CameraControllerO.follow_target = noone
            sprite_index = PlayerBallerGoRightS;
            image_speed = 1;
			hspeed = 1.5;

            if (cutscene_timer > room_speed * 1)
            {
                hspeed = 0;
                cutscene_step = 2;
                cutscene_timer = 0;
            }
        break;

        /// STEP 2 — закрываем двери
        case 2:
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;

            with (lift)
            {
                door_close();
            }

            if (cutscene_timer > room_speed * 0.5)
            {
                end_cutscene();
            }
        break;
    }
}

function cutscene_arrive_right()
{
    cutscene_timer++;

    var lift = current_lift
    if (!instance_exists(lift)) return;

    switch (cutscene_step)
    {
        /// STEP 0 — ждём и открываем двери
        case 0:
			x = lift.x
			y = lift.y
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;
            hspeed = 0;
            vspeed = 0;

            with (lift)
            {
                door_open();
            }
			

            if (cutscene_timer > room_speed * 1.5)
            {
                cutscene_step = 1;
                cutscene_timer = 0;
            }			
        break;

        /// STEP 1 — игрок выходит из лифта влево
        case 1:
			with (CameraControllerO){
				camera_move_to_room_center()	
			}				
			CameraControllerO.follow_target = noone
            sprite_index = PlayerBallerGoLeftS;
            image_speed = 1;
            hspeed = -1.5;

            if (cutscene_timer > room_speed * 1)
            {
                hspeed = 0;
                cutscene_step = 2;
                cutscene_timer = 0;
            }
        break;

        /// STEP 2 — закрываем двери
        case 2:
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;

            with (lift)
            {
                door_close();
            }

            if (cutscene_timer > room_speed * 0.5)
            {
                end_cutscene();
            }
        break;
    }
}



function cutscene_arrive_bottom()
{
    cutscene_timer++;

    var lift = current_lift
    if (!instance_exists(lift)) return;

    switch (cutscene_step)
    {
        /// STEP 0 — ждём и открываем двери
        case 0:
			x = lift.x
			y = lift.y
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;
            hspeed = 0;
            vspeed = 0;

            with (lift)
            {
                door_open();
            }
			

            if (cutscene_timer > room_speed * 1.5)
            {
                cutscene_step = 1;
                cutscene_timer = 0;
            }			
        break;

        /// STEP 1 — игрок выходит из лифта вниз
        case 1:
			with (CameraControllerO){
				camera_move_to_room_center()	
			}				
			CameraControllerO.follow_target = noone
            sprite_index = PlayerBallerGoUpS;
            image_speed = 1;
            vspeed = -1.5;

            if (cutscene_timer > room_speed * 1)
            {
                vspeed = 0;
                cutscene_step = 2;
                cutscene_timer = 0;
            }
        break;

        /// STEP 2 — закрываем двери
        case 2:
            sprite_index = PlayerBallerIdleS;
            image_speed = 0;

            with (lift)
            {
                door_close();
            }

            if (cutscene_timer > room_speed * 0.5)
            {
                end_cutscene();
            }
        break;
    }
}

was_in_water = false;