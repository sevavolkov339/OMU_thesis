// pause
paused = false;
saved_speed = 0;
saved_direction = 0;



//other
spin = 0
max_speed = 10;
spin_angle = 0;

//wall = WallO
wall = [WallO, WallTriangleO]

// Начальные значения (можно изменить из другого объекта)
speed = 0;
direction = 0;

// Переменная для определения минимальной скорости
min_speed = 0.1;

// был ли уже засчитан удар о другой мяч (сбрасывается когда расходятся)
touching_bullet = false;

// короткое окно неуязвимости от повторного касания ИМЕННО с тем же врагом сразу после пролёта
enemy_bounce_immune_id = noone;
enemy_bounce_immune_timer = 0;

// телепортация
teleporting = false;
teleport_timer = 0;
teleport_phase = 0;
teleport_base_xscale = image_xscale;
teleport_base_yscale = image_yscale;
teleport_white = 0;

//being held

held = false;
item_state = "free";

//trail

trail_timer = 0;
trail_interval = 10;

var _trail = instance_create_layer(x, y, "EffectsL", TrailEffectO);
_trail.parent_obj = id;