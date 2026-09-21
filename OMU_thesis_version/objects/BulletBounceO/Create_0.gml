// pause
paused = false;
saved_speed = 0;
saved_direction = 0;



// other
spin = 0
image_xscale = 0.7
image_yscale = 0.7
//wall = WallO
wall = [WallO, WallTriangleO]

// начальные значения (можно изменить из другого объекта)
speed = 0;
direction = 0;

// переменная для определения минимальной скорости
min_speed = 0.1;

// телепортация
teleporting = false;
teleport_timer = 0;
teleport_phase = 0;
teleport_base_xscale = image_xscale;
teleport_base_yscale = image_yscale;
teleport_white = 0;