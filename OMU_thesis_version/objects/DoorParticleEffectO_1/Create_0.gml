vx = random_range(-3, 3);
vy = random_range(-2, -0.5);
alpha = 1;
size = random_range(0.8, 1.4);
gravity = 0.05;
lifetime = 0;
max_lifetime = random_range(30, 50);
anim_offset = irandom(5); // случайный старт анимации

var _sprites = [DustOutlinedS, StarOutlinedS];
sprite_index = _sprites[irandom(1)];
