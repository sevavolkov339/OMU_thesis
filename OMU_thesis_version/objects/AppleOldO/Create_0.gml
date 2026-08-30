// начальная скорость
vx = random_range(-1, 1);
vy = random_range(-1, 1);

// защита от нулевого вектора
if (vx == 0 && vy == 0)
{
    vx = 1;
}

//// вращение
//image_angle = irandom(359);
//spin_speed = random_range(-10, 10);

// притяжение
attract_delay = room_speed * 1;
attract_timer = 0;
attracting = false;

attract_force = 2;
max_speed = 9;

// радиус автосбора
pickup_radius = 10;

// trail
trail = [];
trail_max = 12;        // длина хвоста
trail_alpha = 0.7;     // общая прозрачность
trail_width_start = 6;
trail_width_end   = 1;