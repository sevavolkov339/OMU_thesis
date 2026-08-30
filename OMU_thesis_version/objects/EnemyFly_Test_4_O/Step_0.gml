

//pause

if (GameControllerO.game_paused)
{
    // остановить движение по пути
    path_end();

    speed = 0;
    hspeed = 0;
    vspeed = 0;

    exit;
}

// откинут шипами PuffFishO — на это время своя логика движения/AI отключена
if (puff_stunned) exit;

//shake
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

// just read the stored direction for this cell, no per-enemy search
if (instance_exists(PlayerTestO)) {
	var _cs = SetupPathwayO.cell_size;
	var _gx = clamp(floor(x / _cs), 0, SetupPathwayO.grid_w - 1);
	var _gy = clamp(floor(y / _cs), 0, SetupPathwayO.grid_h - 1);
	var _dir = SetupPathwayO.flow_dir[_gx][_gy];

	if (_dir != -1) {
		direction = _dir;
		speed = 0.5 * path_spd_scale;
	} else {
		speed = 0;
	}
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
	    // kopilka powerup — шанс 30% на 1.5x яблок
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