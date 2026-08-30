follow_target = noone; // за кем следует эта часть
prev_x = x;
prev_y = y;
part_index = 0;

boss_ref = noone;
part_index = 0;
alive = true;

hp = 2;
touching_ball = false;
shake_x = 0;
shake_y = 0;
shake_timer = 0;
shake_strength = 0;
shake_duration = 1;

//sprite_index = BossSnakePartS;
//image_speed = 0;
//image_index = irandom(sprite_get_number(BossSnakePartS) - 1);

//bleeding
hit_by_shuriken = false;
bleeding = false;
bleed_damage_timer = 0;
bleed_damage_interval = 1 * room_speed;
bleed_damage = 0.5;