if (GameControllerO.game_paused) exit;

// смерть — катсцена
if (hp <= 0 && !dying) {
    layer = layer_get_id("DeadL");
    dying = true;
    if (audio_is_playing(buzz_snd)) audio_stop_sound(buzz_snd); // жужжание прекращается, как только начинается смерть
    // она снова трясётся, пока умирает — землетрясение опять играет на фоне
    quake_deep_snd = audio_play_sound(EarthquakeDeepSnd, 0, true);
    quake_snd = audio_play_sound(EarthquakeSnd, 0, true);
    quake_playing = true;
    die_timer = 0;
    die_prev_frame = -1;
    hspeed = 0;
    vspeed = 0;
    sprite_index = BossFlyDeadS;
    image_index = 0;
    image_speed = 1;
    //if (instance_exists(ComboControllerO)) {
	//    with (ComboControllerO) { add_kill(); }
	//}
}

if (dying) {
    die_shake_x = random_range(-3, 3);
    die_shake_y = random_range(-3, 3);
    var _cur_frame = floor(image_index);
    if (_cur_frame != die_prev_frame) {
        die_prev_frame = _cur_frame;
        CameraControllerO.camera_shake(2, 15);
        audio_play_sound(DeathHitsSnd, 0, false); // при каждой вспышке света из неё
    }
    die_white = min(die_white + 0.004, 1);
    if (image_index >= image_number - 1) {
        die_white = 1;
        room_goto(World_1_TransitionRoom);
    }
    exit;
}

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

// сбрасываем touching_ball только когда предмет ПОЛНОСТЬЮ разошёлся с боссом — специально
// без фильтра по скорости движения предмета. Муха сама постоянно летает, поэтому предмет
// (камень/бумеранг/сюрикен) может "застрять" внутри неё и без конца отскакивать на месте —
// с каждым отскоком его скорость гаснет (*0.85) и в какой-то момент падает ниже порога
// "движется", но физически он всё ещё касается босса. Если сбрасывать touching_ball по
// скорости — это читалось бы как "касание прекратилось и началось заново" на каждом таком
// кадре и наносило урон бесконечно, пока предмет не выпадет из босса. Проверка по чистому
// перекрытию (без скорости) от этого не страдает — сама муха почти никогда не стоит на месте,
// поэтому реального "вечно лежащего на боссе предмета" сценария тут не бывает
if (!place_meeting(x, y, BulletBounceO) && !place_meeting(x, y, YoYoO)) {
    touching_ball = false;
}

if (hit_by_shuriken && !bleeding) {
    bleeding = true;
    var _trail = instance_create_layer(x, y, "EffectsL", BloodTrailEffectO);
    _trail.owner = id;
}

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

phase_timer++;
if (phase_timer >= phase_duration) {
    phase_timer = 0;
    phase = (phase == 1) ? 2 : 1;
    spd = (phase == 1) ? spd_phase1 : spd_phase2;
    if (phase == 1) direction = irandom(360);
}

spd_current = lerp(spd_current, spd, 0.015);

if (phase == 2) {
    fly_spawn_timer++;
    if (fly_spawn_timer >= fly_spawn_interval) {
        fly_spawn_timer = 0;
        var _fly = instance_create_layer(x, y, "EnemiesL", EnemyFlyO);
        _fly.path_spd_scale = 1.6; // мухи в комнате босса заметно быстрее обычных
    }
}

if (phase == 1) {
    image_speed = 1;
    random_turn_timer++;
    if (random_turn_timer >= random_turn_interval) {
        random_turn_timer = 0;
        random_turn_interval = irandom_range(20, 60);
        direction += choose(-90, -45, 45, 90, 135, -135, 180);
    }
    var _nx = x + lengthdir_x(spd_current, direction);
    var _ny = y + lengthdir_y(spd_current, direction);
    var _hit_x = _nx < zone_x1 + margin || _nx > zone_x2 - margin;
    var _hit_y = _ny < zone_y1 + margin || _ny > zone_y2 - margin;
    if (_hit_x) {
        direction = 180 - direction;
        sq_x_speed -= 0.5;
        sq_y_speed += 0.5;
        _nx = x + lengthdir_x(spd_current, direction);
    }
    if (_hit_y) {
        direction = -direction;
        sq_x_speed += 0.5;
        sq_y_speed -= 0.5;
        _ny = y + lengthdir_y(spd_current, direction);
    }
    x = _nx;
    y = _ny;
} else {
    image_speed = 0.3;
    turn_speed += random_range(-0.8, 0.8);
    turn_speed *= 0.92;
    direction += turn_speed;
    var _nx = x + lengthdir_x(spd_current, direction);
    var _ny = y + lengthdir_y(spd_current, direction);
    var _hit_x = _nx < zone_x1 + margin || _nx > zone_x2 - margin;
    var _hit_y = _ny < zone_y1 + margin || _ny > zone_y2 - margin;
    if (_hit_x) {
        direction = 180 - direction;
        turn_speed *= -0.5;
        _nx = x + lengthdir_x(spd_current, direction);
    }
    if (_hit_y) {
        direction = -direction;
        turn_speed *= -0.5;
        _ny = y + lengthdir_y(spd_current, direction);
    }
    x = _nx;
    y = _ny;
}