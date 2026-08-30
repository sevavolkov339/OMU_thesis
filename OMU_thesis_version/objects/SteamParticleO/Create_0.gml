//lifetime = 0;
//max_lifetime = irandom_range(130, 320);
//vsp = random_range(0.2, 0.5);
//hsp = random_range(-0.1, 0.1);
//radius = random_range(3, 8);
//wobble_timer = random(pi * 2);
//wobble_speed = random_range(0.04, 0.08);
//wobble_amp = random_range(1, 2.5);

// рандомный спрайт
var _sprites = [ParDitterS, ParDitterVar2S, ParS];
sprite_index = _sprites[irandom(2)];
// рандомный старт кадра
image_index = irandom_range(0, 2);
// рандомная скорость анимации
image_speed = random_range(0.3, 1.0);
// движение
vsp = random_range(0.3,  1.5);
hsp = random_range(-0.15, 0.15);
max_height = random_range(200, 400);
start_y = y;
wobble_timer = random(pi * 2);