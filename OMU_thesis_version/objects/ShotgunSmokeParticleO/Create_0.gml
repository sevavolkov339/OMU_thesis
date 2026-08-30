var _sprites = [ParDitterS, ParDitterVar2S, ParS];
sprite_index = _sprites[irandom(2)];
image_index = irandom_range(0, 2);
image_speed = random_range(0.4, 0.7);

phase = "burst";
life = 0;
life_max = 50 + irandom(20);

var _burst_dir = random(360);
var _burst_spd = random_range(1.2, 3.2);
hsp = lengthdir_x(_burst_spd, _burst_dir);
vsp = lengthdir_y(_burst_spd, _burst_dir);

rise_vsp = random_range(0.35, 0.65);
max_height = random_range(35, 65);
start_y = y;
wobble_timer = random(pi * 5);
wobble_amp = random_range(0.08, 0.22);
wobble_speed = random_range(0.04, 0.06);
scale = random_range(0.45, 1.1);
