

// pause

if (GameControllerO.game_paused)
{
    // остановить движение по пути
    path_end();

    speed = 0;
    hspeed = 0;
    vspeed = 0;

    exit;
}

// откинут шипами PuffFishO, на это время своя логика движения/AI отключена
if (puff_stunned) exit;

//if (touching_ball && !suffer_sound_played) {
//    //var _snd = audio_play_sound(choose(EnemySuffer4_Snd, EnemySuffer5_Snd), 0, false);
//    //audio_sound_pitch(_snd, random_range(0.85, 1.15));
	
//	audio_play_sound(EnemySuffer4_Snd, 0, false);
//    suffer_sound_played = true;
//}
//if (!touching_ball) {
//    suffer_sound_played = false;
//}


// shake
if (shake_timer > 0) {
    var t = shake_timer / shake_duration;
    var cur = shake_strength * t;
    shake_offset_x = random_range(-cur, cur);
    shake_offset_y = random_range(-cur, cur);
    shake_timer--;
} else {
    shake_offset_x = 0;
    shake_offset_y = 0;
}

// AI

if (instance_exists(PipelineValidationO) && PipelineValidationO.cfg_pathfinder == "flow"
        && instance_exists(PlayerBallerO) && instance_exists(SetupPathwayO)) {
	var _cs = SetupPathwayO.cell_size;
	var _gx = clamp(floor(x / _cs), 0, SetupPathwayO.grid_w - 1);
	var _gy = clamp(floor(y / _cs), 0, SetupPathwayO.grid_h - 1);
	var _dir = SetupPathwayO.flow_dir[_gx][_gy];

	target_x = PlayerBallerO.x;
	target_y = PlayerBallerO.y;
	var _tx = target_x;
	var _ty = target_y;
	if (_dir != -1) {
		_tx = (_gx + round(lengthdir_x(1, _dir))) * _cs + _cs / 2;
		_ty = (_gy + round(lengthdir_y(1, _dir))) * _cs + _cs / 2;
	}
	direction = point_direction(x, y, _tx, _ty);
	speed = (point_distance(x, y, _tx, _ty) > 0.5) ? 0.5 * path_spd_scale : 0;
}

if instance_exists(PlayerBallerO){

	if (hp <= 0) {
	    var apple_count = apple_base;
	    if (instance_exists(ComboControllerO)) {
	        var cc = ComboControllerO;
	        switch (cc.combo) {
	            case 1: apple_count += cc.combo_1_bonus; break;
	            case 2: apple_count += cc.combo_2_bonus; break;
	            case 3: apple_count += cc.combo_3_bonus; break;
	        }
	        cc.add_kill();
	    }
	    // kopilka powerup, шанс 30% на 1.5x яблок
	    if (instance_exists(KopilkaPowerUpO)) {
	        if (random(1) < 0.3) {
	            apple_count = ceil(apple_count * 1.5);
	        }
	    }
	    var inst = instance_create_layer(x, y, "EffectsL", AppleO);
	    inst.apple_count = apple_count;
		if instance_exists(PlayerBallerO){
			PlayerBallerO.money += apple_count;
		}
	    instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
	    instance_destroy();
	    exit;
	}


	// collision with ball

	/*
	if (place_meeting(x,y,BulletBounceO)) {
		if (!touching_ball) {
			audio_play_sound(Enemy_Hit_Snd,0,0)
			shake = 3 // shake
			shake_timer = 10 
			hp -= 1.5; // наносим урон только один раз
			touching_ball = true; // помечаем что касание уже началось
		}
	}
	*/

	if (shake_timer > 0){
		shake_timer--	
	}
	else{
		shake = 0
	}

	if (!EnemyTouchingMovingBulletScr()) {
	    touching_ball = false;
	}

}


// separation от других врагов
var sep_force = 12;
var sep_radius = 20;
with (EnemyFlyO) {
    if (id != other.id) {
        var _dist = point_distance(x, y, other.x, other.y);
        if (_dist < sep_radius && _dist > 0) {
            var _dir = point_direction(x, y, other.x, other.y);
            var _force = (sep_radius - _dist) / sep_radius * sep_force;
            other.x += lengthdir_x(_force * 0.1, _dir);
            other.y += lengthdir_y(_force * 0.1, _dir);
        }
    }
}

// спавн трейла крови один раз
if (hit_by_shuriken && !bleeding) {
    bleeding = true;
    var _trail = instance_create_layer(x, y, "EffectsL", BloodTrailEffectO);
    _trail.owner = id;
}

// урон от кровотечения
if (bleeding) {
    bleed_damage_timer++;
    if (bleed_damage_timer >= bleed_damage_interval) {
        bleed_damage_timer = 0;
        hp -= bleed_damage;
        var _dmg_popup = instance_create_layer(x, y - 20, "DeadL", DamageO);
        _dmg_popup.dmg = bleed_damage;
        audio_play_sound(Enemy_Hit_Snd, 0, 0);
        shake = 3;
        shake_timer = 10;
        ShakeScr(id, 6, 0.6);
    }
}

show_debug_message("hit_by_shuriken: " + string(hit_by_shuriken) + " speed: " + string(speed));