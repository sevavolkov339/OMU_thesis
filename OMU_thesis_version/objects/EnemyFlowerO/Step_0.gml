if (GameControllerO.game_paused) exit;

if (touching_ball && !suffer_sound_played) {
    var _snd = audio_play_sound(choose(EnemySuffer3_Snd, EnemySuffer5_Snd), 0, false);
    audio_sound_pitch(_snd, random_range(0.85, 1.15));
    suffer_sound_played = true;
}
if (!touching_ball) {
    suffer_sound_played = false;
}


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




//if (hp <= 0) {
//    var apple_count = apple_base;
//    if (instance_exists(ComboControllerO)) {
//        var cc = ComboControllerO;
//        switch (cc.combo) {
//            case 1: apple_count += cc.combo_1_bonus; break;
//            case 2: apple_count += cc.combo_2_bonus; break;
//            case 3: apple_count += cc.combo_3_bonus; break;
//        }
//        cc.add_kill();
//    }
//    var inst = instance_create_layer(x, y, "EffectsL", AppleO);
//	var _snd = audio_play_sound(BigEnemyDeadSuffer_Snd, 0, false);
//    audio_sound_pitch(_snd, random_range(0.5, 1));
//    inst.apple_count = apple_count;
//	PlayerBallerO.money += apple_base
//	instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
//    instance_destroy();
//    exit;
//}

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
    var _snd = audio_play_sound(BigEnemyDeadSuffer_Snd, 0, false);
    audio_sound_pitch(_snd, random_range(0.5, 1));
    inst.apple_count = apple_count;
	if instance_exists(PlayerBallerO){
		PlayerBallerO.money += apple_count; // было apple_base, теперь учитывает бонус
	}
    instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
    instance_destroy();
    exit;
}

// откинут шипами PuffFishO, на это время своя логика движения отключена
if (puff_stunned) exit;


// тряска постоянная
//shake_timer++;
//shake_x = sin(shake_timer * 0.8) * shake_amt + random_range(-0.5, 0.5);
//shake_y = cos(shake_timer * 1.1) * shake_amt + random_range(-0.5, 0.5);

// движение
var next_x = x + lengthdir_x(spd, direction);
var next_y = y + lengthdir_y(spd, direction);

var bounced = false;

if (place_meeting(next_x, y, wall)) {
    direction = 180 - direction;
    next_x = x + lengthdir_x(spd, direction);
    bounced = true;
}
if (place_meeting(x, next_y, wall)) {
    direction = -direction;
    next_y = y + lengthdir_y(spd, direction);
    bounced = true;
}

if (bounced) {
    // спавним 8 пуль
    for (var _i = 0; _i < 8; _i++) {
        var _bullet = instance_create_layer(x, y, "EnemyBulletsL", EnemyBulletO);
        _bullet.direction = _i * 45;
        _bullet.speed = 0.5;
    }
    // анимация
    image_index = 0;
    image_speed = 1;
    hit_anim = true;
}

if (hit_anim) {
    if (image_index >= image_number - 1) {
        //image_speed = 0;
        image_index = 0;
        hit_anim = false;
    }
}

x = next_x;
y = next_y;

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
        shake = 3;
        shake_timer = 10;
        ShakeScr(id, 6, 0.6);
    }
}