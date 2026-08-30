prev_anim_frame = 0;
sq_x = 1;
sq_y = 1;
sq_x_speed = 0;
sq_y_speed = 0;
sq_stiffness = 0.3;
sq_damping = 0.6;

hp = 20;
part_count = 10;
parts = [];
wall = [WallO, WallTriangleO, WallForEnemiesO];

// движение
spd = 1.5;
direction = irandom(360);
turn_speed = 2;

// история позиций для хвоста
pos_history = [];
var _hist_size = part_count * 12;
for (var i = 0; i < _hist_size; i++) {
    array_push(pos_history, { px: x, py: y });
}

// расстояние между частями
part_spacing = 10;

// яблоки
apple_base = 50
apple_count = 3;
apple_instances = [];
apple_spawn_timer = 0;
apple_spawn_interval = room_speed * 3;

// стены
wall_check_dist = 14;


// зона движения
zone_x1 = 0;
zone_y1 = 0;
zone_x2 = room_width;
zone_y2 = room_height;
if (instance_exists(BossSnakeZoneO)) {
    zone_x1 = BossSnakeZoneO.bbox_left;
    zone_y1 = BossSnakeZoneO.bbox_top;
    zone_x2 = BossSnakeZoneO.bbox_right;
    zone_y2 = BossSnakeZoneO.bbox_bottom;
}
margin = 12;

// спавним части тела
for (var i = 0; i < part_count; i++) {
    var _part = instance_create_layer(x, y, "EnemiesL", BossSnakePartO);
    _part.boss_ref = id;
    _part.part_index = i;
    array_push(parts, _part);
}

// аутлайн для головы
var _head_outline = instance_create_layer(x, y, "BossOutlineL", BossSnakeOutlineO);
_head_outline.ref = id;

// аутлайны для частей
for (var i = 0; i < array_length(parts); i++) {
    var _outline = instance_create_layer(x, y, "BossOutlineL", BossSnakeOutlineO);
    _outline.ref = parts[i];
}

// спавним яблоки
for (var i = 0; i < apple_count; i++) {
    spawn_apple();
}

function spawn_apple() {
    var _ax = irandom_range(zone_x1 + margin, zone_x2 - margin);
    var _ay = irandom_range(zone_y1 + margin, zone_y2 - margin);
    var _apple = instance_create_layer(_ax, _ay, "EffectsL", AppleBossO);
    _apple.boss_ref = id;
    array_push(apple_instances, _apple);
}

function find_nearest_apple() {
    var _nearest = noone;
    var _best_dist = 999999;
    for (var i = array_length(apple_instances) - 1; i >= 0; i--) {
        if (!instance_exists(apple_instances[i])) {
            array_delete(apple_instances, i, 1);
            continue;
        }
        var _d = point_distance(x, y, apple_instances[i].x, apple_instances[i].y);
        if (_d < _best_dist) {
            _best_dist = _d;
            _nearest = apple_instances[i];
        }
    }
    return _nearest;
}

touching_ball = false;

image_speed = 1;