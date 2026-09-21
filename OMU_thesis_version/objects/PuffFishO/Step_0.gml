// враги, которых кинули шипами: сами двигаем/отражаем их от стен и гасим скорость
if (!GameControllerO.game_paused) {
    for (var _kbi = array_length(puff_kb_list) - 1; _kbi >= 0; _kbi--) {
        var _kb = puff_kb_list[_kbi];
        if (!instance_exists(_kb.eid)) {
            array_delete(puff_kb_list, _kbi, 1);
            continue;
        }

        with (_kb.eid) {
            var _nx = x + lengthdir_x(speed, direction);
            var _ny = y + lengthdir_y(speed, direction);
            if (place_meeting(_nx, _ny, other.puff_kb_wall)) {
                var _n = collision_normal(_nx, _ny, other.puff_kb_wall, 8, 2);
                if (_n != -1) {
                    var _ix = lengthdir_x(1, direction);
                    var _iy = lengthdir_y(1, direction);
                    var _nnx = lengthdir_x(1, _n);
                    var _nny = lengthdir_y(1, _n);
                    var _dot = _ix * _nnx + _iy * _nny;
                    direction = point_direction(0, 0, _ix - 2 * _dot * _nnx, _iy - 2 * _dot * _nny);
                } else {
                    direction += 180;
                }
                speed *= 0.6;
                // выталкиваемся наружу, чтобы гарантированно не застрять в стене
                var _safe = 0;
                for (var _d = 0; _d <= 24; _d += 1) {
                    if (!place_meeting(x + lengthdir_x(_d, direction), y + lengthdir_y(_d, direction), other.puff_kb_wall)) {
                        _safe = _d;
                    } else {
                        break;
                    }
                }
                x += lengthdir_x(_safe, direction);
                y += lengthdir_y(_safe, direction);
            } else {
                x = _nx;
                y = _ny;
            }
            speed *= other.puff_kb_decay;
            // трясём всё время, пока летит от отброса, сами поддерживаем таймер тряски
            shake_strength = 3;
            shake_timer = 6;
        }

        _kb.timer--;
        if (_kb.timer <= 0) {
            with (_kb.eid) {
                puff_stunned = false;
                // если враг "плавает" вокруг своей точки (например EnemySpitterO)
                if (variable_instance_exists(id, "origin_x")) origin_x = x;
                if (variable_instance_exists(id, "origin_y")) origin_y = y;
            }
            array_delete(puff_kb_list, _kbi, 1);
        }
    }
}

if (held) {
    speed = 0;
    exit;
}

// speed cap
if (speed > max_speed) speed = max_speed;

// сквош-стретч анимация раздувания/сдувания
if (squash_wait >= 0) {
    squash_wait--;
    if (squash_wait == 0) {
        squash_x = 0.5;
        squash_y = 1.5;
    }
}
squash_x = ApproachScr(squash_x, 1, 0.05);
squash_y = ApproachScr(squash_y, 1, 0.05);

// если долго (3 сек) не касалась врагов, сдувается сама
if (puff_inflated && !GameControllerO.game_paused) {
    puff_no_touch_timer++;
    if (puff_no_touch_timer >= puff_deflate_delay) {
        puff_off();
    }
}

//if (speed > 0 && !held && !teleporting) {
//    trail_timer++;
//    if (trail_timer >= trail_interval) {
//        trail_timer = 0;
//        var _trail = instance_create_layer(x, y, "EffectsL", TrailEffectO);
//        _trail._sprite    = sprite_index;
//        _trail._sub_image = image_index;
//        _trail._xscale    = image_xscale;
//        _trail._yscale    = image_yscale;
//        _trail._angle     = image_angle;
//    }
//}

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

if (puff_inflated) {
    speed *= friction_inflated;
} else {
    speed *= friction_deflated;
}
if (speed < min_speed) speed = 0;

if (speed == 0) exit;

// эффективная скорость перемещения: раздутая рыба двигается чуть медленнее сдутой
var _move_speed;
if (puff_inflated) {
    _move_speed = speed * puff_move_scale_inflated;
} else {
    _move_speed = speed * puff_move_scale_deflated;
}

var next_x = x + lengthdir_x(_move_speed, direction);
var next_y = y + lengthdir_y(_move_speed, direction);

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
    //var _snd = audio_play_sound(ObjectHitSurface_Snd, 1, false);
    //audio_sound_pitch(_snd, random_range(0.8, 1.2));
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
        if (place_meeting(x + lengthdir_x(_move_speed, direction), y, wall)) direction = 180 - direction;
        if (place_meeting(x, y + lengthdir_y(_move_speed, direction), wall)) direction = -direction;
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
    next_x = x + lengthdir_x(_move_speed, direction);
    next_y = y + lengthdir_y(_move_speed, direction);
}

// enemy collision
var enemy_hit = instance_place(next_x, next_y, EnemyO);
if (enemy_bounce_immune_timer > 0) {
    enemy_bounce_immune_timer -= 1;
    if (enemy_hit == enemy_bounce_immune_id) enemy_hit = noone;
}
if (enemy_hit != noone && speed > 0) {
    collision_occurred = true;
    if (!enemy_hit.touching_ball) {
        FreezeScr(100);
        audio_play_sound(Enemy_Hit_Snd, 0, 0);
        var _bounce_snd = audio_play_sound(PuffyFishBounce_Snd, 0, 0);
        audio_sound_pitch(_bounce_snd, random_range(0.8, 1.3));
		var _dmg = 1.5;
		if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
		if (instance_exists(CritPowerUpO)) {
		    if (random(1) < 0.3) {
		        _dmg = _dmg * 2;
		        instance_create_layer(enemy_hit.x, enemy_hit.y - 20, "DeadL", KritDamageO);
		    }
		}
		enemy_hit.hp -= _dmg;
        var _dmg_popup = instance_create_layer(enemy_hit.x, enemy_hit.y - 20, "DeadL", DamageO);
        _dmg_popup.dmg = _dmg;
        //enemy_hit.hp -= 1.5;
        enemy_hit.shake = 3;
        enemy_hit.shake_timer = 10;
        ShakeScr(enemy_hit, 6, 0.6);
        enemy_hit.touching_ball = true;

        // любое касание врага сбрасывает таймер "давно не касалась" и раздувает ежа
        puff_no_touch_timer = 0;
        if (!puff_inflated) {
            puff_on();
        } else {
            // уже раздута, каждое новое касание тоже откидывает, но слабее, чем самый первый
            puff_knock(enemy_hit, puff_kb_force * 0.4);
        }
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
        next_x = x + lengthdir_x(_move_speed, direction);
        next_y = y + lengthdir_y(_move_speed, direction);
    } else {
        var old_dir = direction;
        if (place_meeting(x + lengthdir_x(_move_speed, direction), y, EnemyO)) direction = 180 - direction;
        if (place_meeting(x, y + lengthdir_y(_move_speed, direction), EnemyO)) direction = -direction;
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
        next_x = x + lengthdir_x(_move_speed, direction);
        next_y = y + lengthdir_y(_move_speed, direction);
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

                if (id < other.id) {
                    FreezeScr(100);
                    instance_create_layer(x, y, "EffectsL", ExplosionEffectO);
                }
            }
        }
    }
}
touching_bullet = _touching_bullet_now;
next_x = x + lengthdir_x(_move_speed, direction);
next_y = y + lengthdir_y(_move_speed, direction);

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