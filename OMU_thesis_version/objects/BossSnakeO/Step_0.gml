if (GameControllerO.game_paused) exit;

// считаем живые части
var _alive_parts = 0;
for (var i = 0; i < array_length(parts); i++) {
    if (instance_exists(parts[i])) _alive_parts++;
}

if (_alive_parts <= 0) {
    for (var i = 0; i < array_length(parts); i++) {
        if (instance_exists(parts[i])) instance_destroy(parts[i]);
    }
    for (var i = 0; i < array_length(apple_instances); i++) {
        if (instance_exists(apple_instances[i])) instance_destroy(apple_instances[i]);
    }
    instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
    var inst = instance_create_layer(x, y, "EffectsL", AppleO);
    inst.apple_count = 50;
	PlayerBallerO.money += apple_base
    instance_destroy();
    exit;
}

// спавн яблок
apple_spawn_timer++;
if (apple_spawn_timer >= apple_spawn_interval) {
    apple_spawn_timer = 0;
    var _alive = 0;
    for (var i = array_length(apple_instances) - 1; i >= 0; i--) {
        if (instance_exists(apple_instances[i])) {
            _alive++;
        } else {
            array_delete(apple_instances, i, 1);
        }
    }
    if (_alive < apple_count) spawn_apple();
}

// поворот к яблоку
var _target = find_nearest_apple();
var _desired_dir = direction;
if (_target != noone) {
    _desired_dir = point_direction(x, y, _target.x, _target.y);
}

// проверяем стены
var _m = margin;
var _check_dist = wall_check_dist;

var _ahead_x  = x + lengthdir_x(_check_dist, direction);
var _ahead_y  = y + lengthdir_y(_check_dist, direction);
var _ahead_x2 = x + lengthdir_x(_check_dist * 2, direction);
var _ahead_y2 = y + lengthdir_y(_check_dist * 2, direction);
var _left_x   = x + lengthdir_x(_check_dist, direction + 45);
var _left_y   = y + lengthdir_y(_check_dist, direction + 45);
var _right_x  = x + lengthdir_x(_check_dist, direction - 45);
var _right_y  = y + lengthdir_y(_check_dist, direction - 45);

var _wall_ahead = place_meeting(_ahead_x, _ahead_y, wall)
    || place_meeting(_ahead_x2, _ahead_y2, wall)
    || _ahead_x < zone_x1 + _m || _ahead_x > zone_x2 - _m
    || _ahead_y < zone_y1 + _m || _ahead_y > zone_y2 - _m;

var _wall_left = place_meeting(_left_x, _left_y, wall)
    || _left_x < zone_x1 + _m || _left_x > zone_x2 - _m
    || _left_y < zone_y1 + _m || _left_y > zone_y2 - _m;

var _wall_right = place_meeting(_right_x, _right_y, wall)
    || _right_x < zone_x1 + _m || _right_x > zone_x2 - _m
    || _right_y < zone_y1 + _m || _right_y > zone_y2 - _m;

if (_wall_ahead) {
    if (!_wall_right) {
        direction -= turn_speed * 4;
    } else if (!_wall_left) {
        direction += turn_speed * 4;
    } else {
        direction += 180;
    }
} else {
    var _diff = angle_difference(_desired_dir, direction);
    if (abs(_diff) > turn_speed) {
        direction += sign(_diff) * turn_speed;
    } else {
        direction = _desired_dir;
    }
}

// движение
var _nx = x + lengthdir_x(spd, direction);
var _ny = y + lengthdir_y(spd, direction);

var _out = _nx < zone_x1 + _m || _nx > zone_x2 - _m || _ny < zone_y1 + _m || _ny > zone_y2 - _m;
if (!_out && !place_meeting(_nx, _ny, wall)) {
    x = _nx;
    y = _ny;
} else {
    direction += 180 + irandom_range(-30, 30);
}

image_angle = direction;
image_xscale = sq_y;
image_yscale = sq_x;

// squash and stretch
var _cur_frame = floor(image_index);
if (_cur_frame != prev_anim_frame) {
    if (_cur_frame == 0) {
        sq_x_speed += 0.5;
        sq_y_speed -= 0.5;
    } else if (_cur_frame == 1) {
        sq_x_speed -= 0.5;
        sq_y_speed += 0.5;
    }
    prev_anim_frame = _cur_frame;
}

var _dsx = 1 - sq_x;
sq_x_speed += _dsx * sq_stiffness;
sq_x_speed *= sq_damping;
sq_x += sq_x_speed;

var _dsy = 1 - sq_y;
sq_y_speed += _dsy * sq_stiffness;
sq_y_speed *= sq_damping;
sq_y += sq_y_speed;

// история позиций
array_insert(pos_history, 0, { px: x, py: y });
if (array_length(pos_history) > part_count * 12) {
    array_delete(pos_history, array_length(pos_history) - 1, 1);
}

// обновляем позиции частей
var _sync_frame = (array_length(parts) > 0 && instance_exists(parts[0])) ? parts[0].image_index : 0;

for (var i = 0; i < array_length(parts); i++) {
    if (!instance_exists(parts[i])) continue;
    parts[i].image_index = _sync_frame;
    var _hist_idx = (i + 1) * part_spacing;
    if (_hist_idx < array_length(pos_history)) {
        parts[i].x = pos_history[_hist_idx].px;
        parts[i].y = pos_history[_hist_idx].py;
        if (_hist_idx > 0) {
            var _px1 = pos_history[_hist_idx - 1].px;
            var _py1 = pos_history[_hist_idx - 1].py;
            var _px2 = pos_history[_hist_idx].px;
            var _py2 = pos_history[_hist_idx].py;
            parts[i].image_angle = -point_direction(_px2, _py2, _px1, _py1);
        }
    }
}

// съедаем яблоко
for (var i = array_length(apple_instances) - 1; i >= 0; i--) {
    if (!instance_exists(apple_instances[i])) {
        array_delete(apple_instances, i, 1);
        continue;
    }
    if (point_distance(x, y, apple_instances[i].x, apple_instances[i].y) < spd + 4) {
        instance_destroy(apple_instances[i]);
        array_delete(apple_instances, i, 1);
        spawn_apple();

        var _empty_slot = -1;
        for (var _j = 0; _j < array_length(parts); _j++) {
            if (!instance_exists(parts[_j])) {
                _empty_slot = _j;
                break;
            }
        }

        if (_empty_slot != -1) {
            var _new_part = instance_create_layer(x, y, "EnemiesL", BossSnakePartO);
            _new_part.boss_ref = id;
            _new_part.part_index = _empty_slot;
            parts[_empty_slot] = _new_part;
            var _outline = instance_create_layer(x, y, "BossOutlineL", BossSnakeOutlineO);
            _outline.ref = _new_part;
        } else {
            var _new_part = instance_create_layer(x, y, "EnemiesL", BossSnakePartO);
            _new_part.boss_ref = id;
            _new_part.part_index = array_length(parts);
            if (array_length(parts) > 0 && instance_exists(parts[0])) {
                _new_part.image_index = parts[0].image_index;
                _new_part.image_speed = parts[0].image_speed;
            }
            array_push(parts, _new_part);
            part_count++;
            var _outline = instance_create_layer(x, y, "BossOutlineL", BossSnakeOutlineO);
            _outline.ref = _new_part;
        }
    }
}