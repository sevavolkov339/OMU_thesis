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
		PlayerBallerO.money += apple_count;
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

// рандомная смена направления
dir_change_timer++;
if (dir_change_timer >= dir_change_interval) {
    dir_change_timer = 0;
    dir_change_interval = irandom_range(60, 180);
    direction = irandom(360);
}

// синхронизация рывка с первым кадром анимации
var cur_frame = floor(image_index);
if (cur_frame == 0 && prev_frame != 0) {
    lunge_active = true;
    lunge_timer = lunge_duration;
    // спавним пыль
    instance_create_layer(x, y + 6, "EffectsL", DustEffectO);
}
prev_frame = cur_frame;

// движение
var cur_spd = lunge_active ? lunge_speed : 0;
if (lunge_timer > 0) {
    lunge_timer--;
    if (lunge_timer <= 0) lunge_active = false;
}

var next_x = x + lengthdir_x(cur_spd, direction);
var next_y = y + lengthdir_y(cur_spd, direction);
var bounced = false;

if (place_meeting(next_x, y, wall)) {
    direction = 180 - direction;
    next_x = x + lengthdir_x(cur_spd, direction);
    bounced = true;
}
if (place_meeting(x, next_y, wall)) {
    direction = -direction;
    next_y = y + lengthdir_y(spd, direction);
    bounced = true;
}

// зеркалим спрайт по направлению
if (cos(degtorad(direction)) > 0) {
    image_xscale = 1;
} else {
    image_xscale = -1;
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