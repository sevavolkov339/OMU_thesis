if (GameControllerO.game_paused) exit;

if (touching_ball && !suffer_sound_played) {
    var _snd = audio_play_sound(choose(EnemySuffer3_Snd, EnemySuffer5_Snd), 0, false);
    audio_sound_pitch(_snd, random_range(0.85, 1.15));
    suffer_sound_played = true;
}
if (!touching_ball) {
    suffer_sound_played = false;
}

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
    var _snd = audio_play_sound(BigEnemyDeadSuffer_Snd, 0, false);
    audio_sound_pitch(_snd, random_range(0.5, 1));
    inst.apple_count = apple_count;
	if instance_exists(PlayerBallerO){
		PlayerBallerO.money += apple_count;
	}
    instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
    instance_destroy();
    exit;
}

// откинута шипами PuffFishO — левитацию вокруг origin_x/y и рикойл на это время отключаем,
// иначе она каждый кадр силой возвращала бы x/y на место левитации и отброс был бы не виден
// (тряску при этом не трогаем — она должна продолжаться, пока летит от отброса)
if (!puff_stunned) {
    // затухание рикойла
    recoil_x *= recoil_friction;
    recoil_y *= recoil_friction;
    if (abs(recoil_x) < 0.01) recoil_x = 0;
    if (abs(recoil_y) < 0.01) recoil_y = 0;
    origin_x += recoil_x;
    origin_y += recoil_y;
    // плавный возврат к spawn позиции
    origin_x += (spawn_x - origin_x) * 0.03;
    origin_y += (spawn_y - origin_y) * 0.03;


    // отскок от стен
    var _wall = [WallO, WallTriangleO];
    if (place_meeting(origin_x + recoil_x, origin_y, _wall)) {
        recoil_x *= -0.8;
    }
    if (place_meeting(origin_x, origin_y + recoil_y, _wall)) {
        recoil_y *= -0.8;
    }
    // если застрял — выталкиваем
    if (place_meeting(origin_x, origin_y, _wall)) {
        var _normal = collision_normal(origin_x, origin_y, _wall, 4, 1);
        if (_normal != -1) {
            origin_x += lengthdir_x(2, _normal);
            origin_y += lengthdir_y(2, _normal);
        }
    }
    // обновляем spawn позицию чтобы он не тянулся сквозь стену
    if (!place_meeting(origin_x, origin_y, _wall)) {
        spawn_x += (origin_x - spawn_x) * 0.1;
        spawn_y += (origin_y - spawn_y) * 0.1;
    }

    // левитация
    float_timer += 0.03;
    x = origin_x + sin(float_timer * 0.7) * 10;
    y = origin_y + cos(float_timer * 0.5) * 11;

    // зеркалим спрайт в сторону игрока
    if (instance_exists(PlayerBallerO)) {
        var _facing = (PlayerBallerO.x >= x) ? -1 : 1;
        if (_facing != last_facing) {
            // триггер squash при смене направления
            flip_scale_x = 0.4;
            flip_scale_y = 1.6;
            last_facing = _facing;
        }
        image_xscale = _facing;
    }
    // пружина squash and stretch
    flip_scale_x_speed += (1 - flip_scale_x) * 0.35;
    flip_scale_x_speed *= 0.5;
    flip_scale_x += flip_scale_x_speed;
    flip_scale_y_speed += (1 - flip_scale_y) * 0.35;
    flip_scale_y_speed *= 0.5;
    flip_scale_y += flip_scale_y_speed;
}

// тряска от урона — приоритет (продолжается и во время отброса)
if (shake_timer > 0) {
    var t = shake_timer / shake_duration;
    var cur = shake_strength * t;
    shake_offset_x = random_range(-cur, cur);
    shake_offset_y = random_range(-cur, cur);
    shake_timer--;
} else {
    // постоянная тряска
    shake_offset_x = random_range(-0.8, 0.8);
    shake_offset_y = random_range(-0.8, 0.8);
}

// откинута шипами — стрельбу, рот и остальной AI ниже пропускаем
if (puff_stunned) exit;

// стрельба
shoot_timer++;
if (shoot_timer >= shoot_interval) {
    shoot_timer = 0;
    prespit_shake_timer = 0;
    prespit_shake = 0;
    ShakeScr(id, 7, 0.3);
	// рикойл в противоположную сторону от игрока
	if (instance_exists(PlayerBallerO)) {
	    var _recoil_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, x, y);
	    recoil_x = lengthdir_x(4, _recoil_dir);
	    recoil_y = lengthdir_y(4, _recoil_dir);
	}
    // открываем рот
    mouth_open = true;
    mouth_timer = mouth_close_delay;
    image_index = 1;
    image_speed = 0;
    // squash при открытии
    mouth_scale_x = 1.4;
    mouth_scale_y = 0.6;
    // спавн пули в сторону игрока
    if (instance_exists(PlayerBallerO)) {
        var _bullet = instance_create_layer(x, y, "EnemyBulletsL", EnemyBulletLargeO);
        _bullet.direction = point_direction(x, y, PlayerBallerO.x, PlayerBallerO.y);
        _bullet.speed = 1;
    }
}

// таймер закрытия рта
if (mouth_open) {
    mouth_timer--;
    if (mouth_timer <= 0) {
        mouth_open = false;
        image_index = 0;
        image_speed = 0;
		// squash при закрытии — сплющивание по горизонтали
		mouth_scale_x = 1.4;
		mouth_scale_y = 0.6;
    }
}
// пружина рта
mouth_scale_x_speed += (1 - mouth_scale_x) * 0.4;
mouth_scale_x_speed *= 0.5;
mouth_scale_x += mouth_scale_x_speed;
mouth_scale_y_speed += (1 - mouth_scale_y) * 0.4;
mouth_scale_y_speed *= 0.5;
mouth_scale_y += mouth_scale_y_speed;

// коллизия с мячом
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
        ShakeScr(id, 6, 0.6);
    }
}