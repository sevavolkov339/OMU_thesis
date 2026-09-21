instance_create_layer(x,y, "BulletsL", BossFlyShadowO);

hp = 10;
apple_base = 40;
buzz_snd = audio_play_sound(FlyBuzzingSnd, 0, true); // жужжание в лупе, пока босс жив
quake_deep_snd = -1;
quake_snd = -1;
quake_playing = false; // землетрясение во время смерти
touching_ball = false;
shake_x = 0;
shake_y = 0;
shake_timer = 0;
shake_strength = 0;
shake_duration = 1;
dying = false;
die_timer = 0;
die_shake_x = 0;
die_shake_y = 0;
die_white = 0;
die_prev_frame = -1;
// зона движения
zone_x1 = 0;
zone_y1 = 0;
zone_x2 = room_width;
zone_y2 = room_height;
if (instance_exists(BossFlyZoneO)) {
    zone_x1 = BossFlyZoneO.bbox_left;
    zone_y1 = BossFlyZoneO.bbox_top;
    zone_x2 = BossFlyZoneO.bbox_right;
    zone_y2 = BossFlyZoneO.bbox_bottom;
}
margin = 12;
// фазы
phase = 1;
phase_timer = 0;
phase_duration = 10 * room_speed;
// движение
direction = irandom(360);
spd_phase1 = 5;
spd_phase2 = 1.2;
spd = spd_phase1;
spd_current = 0;
// поворот для плавной фазы
turn_speed = 0;
// спавн мух
fly_spawn_timer = 0;
fly_spawn_interval = 2 * room_speed;
// squash
sq_x = 1;
sq_y = 1;
sq_x_speed = 0;
sq_y_speed = 0;
sq_stiffness = 0.3;
sq_damping = 0.6;
prev_anim_frame = 0;
image_speed = 1;
// рандомный поворот
random_turn_timer = 0;
random_turn_interval = irandom_range(30, 80);
// bleeding
hit_by_shuriken = false;
bleeding = false;
bleed_damage_timer = 0;
bleed_damage_interval = 1 * room_speed;
bleed_damage = 0.5;

// восстановление после загрузки сохранения
boss_restore_player = undefined;
if (!is_undefined(global.pending_boss_snapshot)) {
    var _bs = global.pending_boss_snapshot;
    x = _bs.x;
    y = _bs.y;
    hp = _bs.hp;
    dying = _bs.dying;
    phase = _bs.phase;
    phase_timer = _bs.phase_timer;
    direction = _bs.direction;
    bleeding = _bs.bleeding;
    bleed_damage_timer = _bs.bleed_damage_timer;
    // игрока переставляем в Step_0 - там гарантированно его Create уже отработал
    boss_restore_player = _bs.player;
    global.pending_boss_snapshot = undefined;
}