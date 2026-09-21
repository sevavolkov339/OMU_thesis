hp = 4;
wall = [WallO, WallTriangleO];
apple_base = 10;
touching_ball = false;

touching_birdie = false;

// тряска
shake_strength = 0;
shake_duration = 1;
shake_timer = 0;
shake_offset_x = 0;
shake_offset_y = 0;
// анимация столкновения
hit_anim = false;
// sounds
suffer_sound_played = false;
hit_by_shuriken = false;
// bleeding
bleeding = false;
bleed_damage_timer = 0;
bleed_damage_interval = 2 * room_speed;
bleed_damage = 1;
// стрельба
shoot_timer = 0;
shoot_interval = 2 * room_speed; // раз в 2 cek
// тряска перед плевком
prespit_shake = 0;
prespit_shake_timer = 0;



// squash and stretch при повороте
flip_scale_x = 1;
flip_scale_y = 1;
flip_scale_x_speed = 0;
flip_scale_y_speed = 0;
last_facing = 1;

// левитация
float_timer = random(pi * 2);
origin_x = x;
origin_y = y;

// анимация рта
mouth_open = false;
mouth_timer = 0;
mouth_close_delay = 1 * room_speed;
mouth_scale_x = 1;
mouth_scale_y = 1;
mouth_scale_x_speed = 0;
mouth_scale_y_speed = 0;

// рикойл
recoil_x = 0;
recoil_y = 0;
recoil_friction = 0.85;
spawn_x = x;
spawn_y = y;

// откинут шипами PuffFishO, своя логика (в т.ч. левитация вокруг origin_x/y)
puff_stunned = false;