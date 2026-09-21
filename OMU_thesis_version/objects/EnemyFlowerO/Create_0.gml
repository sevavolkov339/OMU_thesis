hp = 6;
spd = 1;
direction = irandom(360);
wall = [WallO, WallTriangleO];
apple_base = 10;
touching_ball = false;

touching_birdie = false;

// тряска
shake_x = 0;
shake_y = 0;
shake_amt = 1.5;


shake_strength = 0;
shake_duration = 1; // 1 чтобы не было деления на ноль
shake_timer = 0;
shake_offset_x = 0;
shake_offset_y = 0;


// анимация столкновения
hit_anim = false;

// sounds

suffer_sound_played = false;

hit_by_shuriken = false;

// bleeding
hit_by_shuriken = false;
bleeding = false;
bleed_damage_timer = 0;
bleed_damage_interval = 2 * room_speed;
bleed_damage = 1

// откинут шипами PuffFishO, своя логика движения на это время отключается
puff_stunned = false;