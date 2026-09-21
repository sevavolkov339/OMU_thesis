if (GameControllerO.game_paused) exit;

switch (state) {
    case "idle":
        state_timer++;
        if (state_timer >= wait_duration) {
            state = "blowing";
            state_timer = 0;
            wind_dir = choose(-1, 1);
        }
    break;

    case "blowing":
        state_timer++;
        if (state_timer >= blow_duration) {
            state = "idle";
            state_timer = 0;
            wait_duration = room_speed * random_range(3, 9);
        }
    break;
}

// сила ветра плавно нарастает и спадает, а не переключается мгновенно
var _target_strength = (state == "blowing") ? 1 : 0;
wind_strength = ApproachScr(wind_strength, _target_strength, 0.04);

// полосы ветра, появляются, пока хоть немного дует
if (wind_strength > 0.05 && array_length(lines) < max_lines) {
    line_spawn_timer++;
    if (line_spawn_timer >= line_spawn_interval) {
        line_spawn_timer = 0;
        spawn_wind_line();
    }
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
for (var i = array_length(lines) - 1; i >= 0; i--) {
    var _l = lines[i];
    _l.x += lengthdir_x(_l.spd, _l.dir);
    _l.y += lengthdir_y(_l.spd, _l.dir);
    _l.life--;

    // вытягивается (растёт до полной длины) в первой половине жизни
    if (_l.stretch) {
        var _grow_t = clamp(1 - (_l.life / (_l.life_max * 0.5)), 0, 1);
        _l.len = lerp(_l.len_max * 0.2, _l.len_max, _grow_t);
    }

    if (_l.life <= 0 || _l.x < -100 || _l.x > _gw + 100 || _l.y < -100 || _l.y > _gh + 100) {
        array_delete(lines, i, 1);
    }
}

// сдувает игрока и кикаемые предметы
if (wind_strength > 0.01) {
    var _push = wind_dir * wind_strength;

    if (instance_exists(PlayerBallerO)) {
        var _p = PlayerBallerO;
        // ускорение/торможение, только когда игрок САМ реально движется
        if (_p.hspeed != 0) {
            if (sign(_p.hspeed) == -wind_dir) {
                _p.hspeed *= (1 - player_headwind_brake * wind_strength);
            } else if (sign(_p.hspeed) == wind_dir) {
                _p.hspeed *= (1 + player_tailwind_boost * wind_strength);
            }
        }
        // а сам пассивный "сдув", чисто позиционный сдвиг, а не через hspeed/speed
        var _pnx = _p.x + _push * player_push;
        if (!place_meeting(_pnx, _p.y, _p.wall)) {
            _p.x = _pnx;
        }
    }

    // предметы, только пока лежат на месте (не летят после удара); летящий предмет
    with (BulletBounceO) {
        if (!held && speed <= min_speed) {
            var _nx = x + _push * other.item_push;
            if (!place_meeting(_nx, y, wall)) {
                x = _nx;
            }
        }
    }
}
