if (GameControllerO.game_paused) exit;

if (held) {
    speed = 0;
    boom_state = "idle";
    wall_bounce_enabled = false;
    prev_speed = 0;
    exit;
}

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
                if (teleport_timer >= 12) { teleport_phase = 1; teleport_timer = 0; }
            break;
            case 1:
                image_xscale = lerp(image_xscale, teleport_base_xscale * 0.05, 0.4);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 8, 0.4);
                if (teleport_timer >= 10) { teleport_phase = 2; teleport_timer = 0; }
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
                if (teleport_timer >= 10) { image_alpha = 1; teleport_phase = 1; teleport_timer = 0; }
            break;
            case 1:
                teleport_white = 1;
                image_xscale = lerp(image_xscale, teleport_base_xscale * 3, 0.4);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 0.1, 0.4);
                if (teleport_timer >= 10) { teleport_phase = 2; teleport_timer = 0; }
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

// если в idle и получил скорость от удара мяча — переходим в slide
if (boom_state == "idle" && speed > min_speed) {
    boom_state = "slide";
    wall_bounce_enabled = true;
}

// попытка пнуть — работает в любом состоянии
if (bumerang_try_kick()) {
    bumerang_start_flight();
}

if (boom_state == "idle") {
    speed = 0;
    prev_speed = 0;
    exit;
}

if (boom_state == "flying") {
    // следим за позицией игрока как точкой возврата
    if (instance_exists(PlayerBallerO)) {
        origin_x = PlayerBallerO.x;
        origin_y = PlayerBallerO.y;
    }

    // поворот — круговой полёт. Стены и толчки тут намеренно не учитываются —
    // это нужно, чтобы бумеранг всегда чисто описывал полный круг и точно возвращался
    // в исходную точку броска, независимо от стен и врагов на пути.
    heading = (heading + turn_speed * arc_side + 360) mod 360;
    arc_angle_traveled += abs(turn_speed);

    x += lengthdir_x(launch_speed, heading);
    y += lengthdir_y(launch_speed, heading);

    direction = heading;
    speed = launch_speed;

    // урон врагам во время полёта (без отталкивания и без изменения дуги — круг должен остаться чистым)
    var _ef = instance_place(x, y, EnemyO);
    if (enemy_bounce_immune_timer > 0) {
        enemy_bounce_immune_timer -= 1;
        if (_ef == enemy_bounce_immune_id) _ef = noone;
    }
    if (_ef != noone && !_ef.touching_ball) {
        FreezeScr(100);
        audio_play_sound(Enemy_Hit_Snd, 0, 0);
        var _dmg = 0.7;
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
        var _is_crit = instance_exists(CritPowerUpO) && random(1) < 0.3;
        if (_is_crit) _dmg *= 2;
        _ef.hp -= _dmg;
        var _dmg_popup = instance_create_layer(_ef.x, _ef.y - 20, "DeadL", DamageO);
        _dmg_popup.dmg = _dmg;
        if (_is_crit) instance_create_layer(_ef.x, _ef.y - 20, "DeadL", KritDamageO);
        ShakeScr(_ef, 6, 0.6);
        _ef.touching_ball = true;
    }
    if (_ef != noone) {
        enemy_bounce_immune_id = _ef;
        enemy_bounce_immune_timer = 20;
    }

    // ровно один круг — 360 градусов — переходим в slide
    if (arc_angle_traveled >= 360) {
        direction = heading;
        speed = launch_speed;
        boom_state = "slide";
        wall_bounce_enabled = true;
        arc_angle_traveled = 0;
        max_dist_from_origin = 0;
    }

} else if (boom_state == "slide") {
    speed *= 0.97;
    if (speed < min_speed) {
        speed = 0;
        boom_state = "idle";
        wall_bounce_enabled = false;
        prev_speed = 0;
        exit;
    }

    var next_x = x + lengthdir_x(speed, direction);
    var next_y = y + lengthdir_y(speed, direction);
    var collision_occurred = false;
    var old_direction = direction;

    // отскок от стен
    // защита от проскальзывания сквозь стену на высокой скорости — проверяем промежуточные точки пути
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
            } else { break; }
        }
        if (safe_distance > 0) {
            x += lengthdir_x(safe_distance, old_direction);
            y += lengthdir_y(safe_distance, old_direction);
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

    // урон врагам при скольжении
    var _es = instance_place(x, y, EnemyO);
    if (_es == noone) _es = instance_place(next_x, next_y, EnemyO);
    if (enemy_bounce_immune_timer > 0) {
        enemy_bounce_immune_timer -= 1;
        if (_es == enemy_bounce_immune_id) _es = noone;
    }
    if (_es != noone && speed > 0 && !_es.touching_ball) {
        FreezeScr(100);
        audio_play_sound(Enemy_Hit_Snd, 0, 0);
        var _dmg = 0.7;
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
        var _is_crit = instance_exists(CritPowerUpO) && random(1) < 0.3;
        if (_is_crit) _dmg *= 2;
        _es.hp -= _dmg;
        var _dmg_popup = instance_create_layer(_es.x, _es.y - 20, "DeadL", DamageO);
        _dmg_popup.dmg = _dmg;
        if (_is_crit) instance_create_layer(_es.x, _es.y - 20, "DeadL", KritDamageO);
        ShakeScr(_es, 6, 0.6);
        _es.touching_ball = true;

        // расталкиваемся от врага, чтобы не задевать его повторно за тот же проход (и не сквозь стену)
        var _push_dir = point_direction(_es.x, _es.y, x, y);
        var _safe_dist = 0;
        for (var _d = 0; _d <= 12; _d += 1) {
            var _cx = x + lengthdir_x(_d, _push_dir);
            var _cy = y + lengthdir_y(_d, _push_dir);
            if (!instance_place(_cx, _cy, EnemyO) && !place_meeting(_cx, _cy, wall)) {
                _safe_dist = _d;
            } else {
                break;
            }
        }
        if (_safe_dist > 0) {
            x += lengthdir_x(_safe_dist, _push_dir);
            y += lengthdir_y(_safe_dist, _push_dir);
        }
        next_x = x + lengthdir_x(speed, direction);
        next_y = y + lengthdir_y(speed, direction);
    }
    if (_es != noone) {
        enemy_bounce_immune_id = _es;
        enemy_bounce_immune_timer = 20;
    }

    // столкновение с мячом при скольжении — эффект только в момент начала касания
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
                    other.touching_bullet = true;

                    // физически расталкиваем оба объекта, чтобы они гарантированно разошлись за этот же кадр
                    // (но не сквозь стену — проверяем перед тем, как реально сдвинуть)
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

                    // бумеранг при столкновении с другим предметом уходит в новый круговой облёт,
                    // но в противоположную сторону от предыдущего круга
                    other.boom_state = "flying";
                    other.origin_x = other.x;
                    other.origin_y = other.y;
                    other.kick_direction = (_dir + 180) mod 360;
                    other.heading = (_dir + 180) mod 360;
                    other.launch_speed = max(other.speed, 4);
                    other.arc_angle_traveled = 0;
                    other.arc_side *= -1;
                    other.wall_bounce_enabled = false;

                    if (id < other.id) {
                        FreezeScr(100);
                        instance_create_layer(x, y, "EffectsL", ExplosionEffectO);
                    }
                }
            }
        }
    }
    touching_bullet = _touching_bullet_now;
    next_x = x + lengthdir_x(speed, direction);
    next_y = y + lengthdir_y(speed, direction);

    // применяем движение
    if (!collision_occurred || !place_meeting(next_x, next_y, wall)) {
        x = next_x;
        y = next_y;
    } else {
        for (var i = 1; i <= 8; i++) {
            var try_x = x + lengthdir_x(i, direction + 180);
            var try_y = y + lengthdir_y(i, direction + 180);
            if (!place_meeting(try_x, try_y, wall)) {
                x = try_x;
                y = try_y;
                break;
            }
        }
    }
}

spin_angle += speed * 10;
image_angle = floor(spin_angle / 30) * 30;
prev_speed = speed;