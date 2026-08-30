door_x = 0;
door_y = 0;
angle = 0;
spin_speed = 10;
alpha = 1;
xscale = 1;
yscale = 1;

enter_sprite = -1;
sprite_index = 1;
enter_subimage = 0;

// true для последней двери сегмента уровней — ставится снаружи (DoorO) сразу после instance_create_layer,
// поэтому сам fade-переход запускаем не здесь, а в Step_0 на первом кадре (см. fade_started)
is_segment_final = false;
fade_started = false;