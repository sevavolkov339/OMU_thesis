// pause
paused = false;
saved_speed = 0;
saved_direction = 0;



// other
spin = 0
max_speed = 10;

explosion_cooldown = 0;
explosion_cooldown_max = 20; // кадров между взрывами

//wall = WallO
wall = [WallO, WallTriangleO]

// начальные значения (можно изменить из другого объекта)
speed = 0;
direction = 0;

// переменная для определения минимальной скорости
min_speed = 0.1;

// был ли уже засчитан удар о другой мяч (сбрасывается когда расходятся)
touching_bullet = false;

// короткое окно неуязвимости от повторного касания/отскока ИМЕННО от того же
enemy_bounce_immune_id = noone;
enemy_bounce_immune_timer = 0;

// телепортация
teleporting = false;
teleport_timer = 0;
teleport_phase = 0;
teleport_base_xscale = image_xscale;
teleport_base_yscale = image_yscale;
teleport_white = 0;

// being held

held = false;
item_state = "free";

// trail

trail_timer = 0;
trail_interval = 10;

var _trail = instance_create_layer(x, y, "EffectsL", TrailEffectO);
_trail.parent_obj = id;


// не во всех комнатах есть слой "HandsL" (например в магазине)
var _trail2_layer = (layer_get_id("HandsL") != -1) ? "HandsL" : "EffectsL";
var _trail2 = instance_create_layer(x, y, _trail2_layer, TrailBombEffectO);
_trail2.parent_obj = id;