if (held) {
    speed = 0;
    exit;
}

// speed cap
if (speed > max_speed) speed = max_speed;

// teleporting
if (teleporting) {
    teleport_timer++;
    
    image_angle = lerp(image_angle, 0, 0.3);
    spin = 0;
    image_blend = merge_colour(c_black, c_white, teleport_white);
    
    if (teleport_mode == "out") {
        switch (teleport_phase) {
            case 0:
                teleport_white = 1;
                image_xscale = lerp(image_xscale, teleport_base_xscale * 2.5, 0.3);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 0.1, 0.3);
                if (teleport_timer >= 12) {
                    teleport_phase = 1;
                    teleport_timer = 0;
                }
            break;
            case 1:
                image_xscale = lerp(image_xscale, teleport_base_xscale * 0.05, 0.4);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 8, 0.4);
                if (teleport_timer >= 10) {
                    teleport_phase = 2;
                    teleport_timer = 0;
                }
            break;
            case 2:
                instance_destroy(BallTrajectoryO);
                y -= 15;
                image_alpha = lerp(image_alpha, 0, 0.2);
                if (image_alpha < 0.05) {
                    image_alpha = 0;
                    teleporting = false;
                    instance_destroy();
                }
            break;
        }
    } else if (teleport_mode == "in") {
        switch (teleport_phase) {
            case 0:
                teleport_white = 1;
                y += 8;
                image_alpha = lerp(image_alpha, 1, 0.3);
                if (teleport_timer >= 10) {
                    image_alpha = 1;
                    teleport_phase = 1;
                    teleport_timer = 0;
                }
            break;
            case 1:
                teleport_white = 1;
                image_xscale = lerp(image_xscale, teleport_base_xscale * 3, 0.4);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 0.1, 0.4);
                if (teleport_timer >= 10) {
                    teleport_phase = 2;
                    teleport_timer = 0;
                }
            break;
            case 2:
                image_xscale = lerp(image_xscale, teleport_base_xscale, 0.2);
                image_yscale = lerp(image_yscale, teleport_base_yscale, 0.2);
                teleport_white = lerp(teleport_white, 0, 0.15);
                image_angle += 100;
                if (teleport_timer >= 18) {
                    image_xscale = teleport_base_xscale;
                    image_yscale = teleport_base_yscale;
                    image_alpha = 1;
                    teleport_white = 0;
                    image_blend = c_white;
                    teleporting = false;
                    spin = 8;
                }
            break;
        }
    }
    exit;
}

if (speed <= 0) exit;

speed *= 0.98;
if (speed < min_speed) speed = 0;

if (speed == 0) exit;

var next_x = x + lengthdir_x(speed, direction);
var next_y = y + lengthdir_y(speed, direction);

var collision_occurred = false;
var old_direction = direction;

// wall collision
var _wall_hit = place_meeting(next_x, next_y, wall);
if (!_wall_hit && speed > 4) {
    var _wsteps = ceil(speed / 4);
    for (var _wsi = 1; _wsi < _wsteps; _wsi++) {
        var _wst = (_wsi / _wsteps) * speed;
        if (place_meeting(x + lengthdir_x(_wst, direction), y + lengthdir_y(_wst, direction), wall)) {
            _wall_hit = true;
            break;
        }
    }
}
if (_wall_hit) {
    collision_occurred = true;
    var surface_normal = collision_normal(next_x, next_y, wall, 8, 2);
    if (surface_normal != -1) {
        var incident_x = lengthdir_x(1, direction);
        var incident_y = lengthdir_y(1, direction);
        var normal_x = lengthdir_x(1, surface_normal);
        var normal_y = lengthdir_y(1, surface_normal);
        var dot = incident_x * normal_x + incident_y * normal_y;
        var reflect_x = incident_x - 2 * dot * normal_x;
        var reflect_y = incident_y - 2 * dot * normal_y;
        direction = point_direction(0, 0, reflect_x, reflect_y);
    } else {
        if (place_meeting(x + lengthdir_x(speed, direction), y, wall)) direction = 180 - direction;
        if (place_meeting(x, y + lengthdir_y(speed, direction), wall)) direction = -direction;
    }
    var safe_distance = 0;
    var max_check = min(speed, 20);
    for (var dist = 0; dist <= max_check; dist += 0.5) {
        var check_x = x + lengthdir_x(dist, old_direction);
        var check_y = y + lengthdir_y(dist, old_direction);
        if (!place_meeting(check_x, check_y, wall)) {
            safe_distance = dist;
        } else {
            break;
        }
    }
    if (safe_distance > 0) {
        x = x + lengthdir_x(safe_distance, old_direction);
        y = y + lengthdir_y(safe_distance, old_direction);
    }
    if (place_meeting(x, y, wall)) {
        var push_normal = collision_normal(x, y, wall, 8, 2);
        if (push_normal != -1) {
            x += lengthdir_x(3, push_normal);
            y += lengthdir_y(3, push_normal);
        } else {
            x += lengthdir_x(3, random(360));
            y += lengthdir_y(3, random(360));
        }
    }
    next_x = x + lengthdir_x(speed, direction);
    next_y = y + lengthdir_y(speed, direction);
}

// enemy collision
var enemy_hit = instance_place(next_x, next_y, EnemyO);
if (enemy_bounce_immune_timer > 0) {
    enemy_bounce_immune_timer -= 1;
    if (enemy_hit == enemy_bounce_immune_id) enemy_hit = noone;
}
if (enemy_hit != noone && speed > 0) {
    collision_occurred = true;
    if (!enemy_hit.touching_ball && explosion_cooldown <= 0) {
        FreezeScr(100);
        var _fx = instance_create_layer(x, y, "EnemiesL", ExplosionBombEffectO);
        _fx.parent_bomb = id;
        enemy_hit.touching_ball = true;
        explosion_cooldown = explosion_cooldown_max;
    }
    var surface_normal = collision_normal(next_x, next_y, EnemyO, 8, 2);
    if (surface_normal != -1) {
        var old_dir = direction;
        var incident_x = lengthdir_x(1, direction);
        var incident_y = lengthdir_y(1, direction);
        var normal_x = lengthdir_x(1, surface_normal);
        var normal_y = lengthdir_y(1, surface_normal);
        var dot = incident_x * normal_x + incident_y * normal_y;
        var reflect_x = incident_x - 2 * dot * normal_x;
        var reflect_y = incident_y - 2 * dot * normal_y;
        direction = point_direction(0, 0, reflect_x, reflect_y);
        speed *= 0.85;
        var safe_dist = 0;
        var max_check_enemy = min(speed, 15);
        for (var d = 0; d <= max_check_enemy; d += 0.5) {
            var check_x = x + lengthdir_x(d, old_dir);
            var check_y = y + lengthdir_y(d, old_dir);
            if (!instance_place(check_x, check_y, EnemyO)) {
                safe_dist = d;
            } else {
                break;
            }
        }
        if (safe_dist > 0) {
            x = x + lengthdir_x(safe_dist, old_dir);
            y = y + lengthdir_y(safe_dist, old_dir);
        }
        var enemy_check = instance_place(x, y, EnemyO);
        if (enemy_check != noone) {
            var push_dir = point_direction(enemy_check.x, enemy_check.y, x, y);
            x += lengthdir_x(5, push_dir);
            y += lengthdir_y(5, push_dir);
        }
        next_x = x + lengthdir_x(speed, direction);
        next_y = y + lengthdir_y(speed, direction);
    } else {
        var old_dir = direction;
        if (place_meeting(x + lengthdir_x(speed, direction), y, EnemyO)) direction = 180 - direction;
        if (place_meeting(x, y + lengthdir_y(speed, direction), EnemyO)) direction = -direction;
        speed *= 0.85;
        var safe_dist = 0;
        for (var d = 0; d <= speed; d += 0.5) {
            var check_x = x + lengthdir_x(d, old_dir);
            var check_y = y + lengthdir_y(d, old_dir);
            if (!instance_place(check_x, check_y, EnemyO)) {
                safe_dist = d;
            } else {
                break;
            }
        }
        if (safe_dist > 0) {
            x = x + lengthdir_x(safe_dist, old_dir);
            y = y + lengthdir_y(safe_dist, old_dir);
        }
        // если всё ещё застряли в враге, принудительно выталкиваемся от его центра
        var enemy_check2 = instance_place(x, y, EnemyO);
        if (enemy_check2 != noone) {
            var push_dir2 = point_direction(enemy_check2.x, enemy_check2.y, x, y);
            x += lengthdir_x(5, push_dir2);
            y += lengthdir_y(5, push_dir2);
        }
        next_x = x + lengthdir_x(speed, direction);
        next_y = y + lengthdir_y(speed, direction);
    }
}

if (enemy_hit != noone) {
    enemy_bounce_immune_id = enemy_hit;
    enemy_bounce_immune_timer = 20;
}

// столкновение с другим мячом, эффект только в момент начала касания
var _touching_bullet_now = false;
with (BulletBounceO) {
    if (id != other.id && speed > 1.5 && other.speed > 1.5) {
        var _dist = point_distance(x, y, other.x, other.y);
        var _combined_radius = sprite_get_width(sprite_index) * 0.5 + sprite_get_width(other.sprite_index) * 0.5;
        if (_dist < _combined_radius) {
            _touching_bullet_now = true;
            if (!touching_bullet) {
                var _dir = point_direction(other.x, other.y, x, y);
                direction = _dir;
                other.direction = (_dir + 180) mod 360;
                other.touching_bullet = true;

                // физически расталкиваем оба объекта
                var _overlap = _combined_radius - _dist;
                if (_overlap > 0) {
                    var _push = _overlap * 0.5 + 1;
                    var _pnx = x + lengthdir_x(_push, _dir);
                    var _pny = y + lengthdir_y(_push, _dir);
                    if (!place_meeting(_pnx, _pny, wall)) { x = _pnx; y = _pny; }
                    var _ponx = other.x + lengthdir_x(_push, _dir + 180);
                    var _pony = other.y + lengthdir_y(_push, _dir + 180);
                    if (!place_meeting(_ponx, _pony, other.wall)) { other.x = _ponx; other.y = _pony; }
                }

                if (id < other.id && other.explosion_cooldown <= 0) {
                    FreezeScr(100);
                    var _fx = instance_create_layer(x, y, "EnemiesL", ExplosionBombEffectO);
                    _fx.parent_bomb = other.id;
                    other.explosion_cooldown = other.explosion_cooldown_max;
                }
            }
        }
    }
}
touching_bullet = _touching_bullet_now;
next_x = x + lengthdir_x(speed, direction);
next_y = y + lengthdir_y(speed, direction);

// применяем движение
if (!collision_occurred || (!place_meeting(next_x, next_y, wall) && instance_place(next_x, next_y, EnemyO) == noone)) {
    x = next_x;
    y = next_y;
} else {
    var attempts = 8;
    for (var i = 1; i <= attempts; i++) {
        var try_x = x + lengthdir_x(i, direction + 180);
        var try_y = y + lengthdir_y(i, direction + 180);
        if (!place_meeting(try_x, try_y, wall) && instance_place(try_x, try_y, EnemyO) == noone) {
            x = try_x;
            y = try_y;
            break;
        }
    }
}