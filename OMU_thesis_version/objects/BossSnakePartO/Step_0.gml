//if (!instance_exists(follow_target)) exit;
//prev_x = x;
//prev_y = y;
//x = follow_target.prev_x;
//y = follow_target.prev_y;

if (shake_timer > 0) {
    var t = shake_timer / shake_duration;
    var cur = shake_strength * t;
    shake_x = random_range(-cur, cur);
    shake_y = random_range(-cur, cur);
    shake_timer--;
} else {
    shake_x = 0;
    shake_y = 0;
}

if (!EnemyTouchingMovingBulletScr()) {
    touching_ball = false;
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

if (hp <= 0) {
    //var apple_count = apple_base;
    if (instance_exists(ComboControllerO)) {
        var cc = ComboControllerO;
        //switch (cc.combo) {
        //    case 1: apple_count += cc.combo_1_bonus; break;
        //    case 2: apple_count += cc.combo_2_bonus; break;
        //    case 3: apple_count += cc.combo_3_bonus; break;
        //}
        cc.add_kill();
    }
    //var inst = instance_create_layer(x, y, "EffectsL", AppleO);
	//var _snd = audio_play_sound(BigEnemyDeadSuffer_Snd, 0, false);
    //audio_sound_pitch(_snd, random_range(0.5, 1));
    //inst.apple_count = apple_count;
	//PlayerBallerO.money += apple_base
	instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
    instance_destroy();
    exit;
}