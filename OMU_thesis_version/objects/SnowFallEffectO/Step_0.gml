if (instance_exists(GameControllerO) && GameControllerO.game_paused) exit;

spawn_timer++;
if (spawn_timer >= spawn_interval && array_length(flakes) < max_flakes) {
    spawn_timer = 0;
    spawn_snow_flake();
}

// ветер (WindEffectO) сносит снег в свою сторону
var _wind_push = 0;
if (instance_exists(WindEffectO)) {
    _wind_push = WindEffectO.wind_dir * WindEffectO.wind_strength * 3.5;
}

for (var i = array_length(flakes) - 1; i >= 0; i--) {
    var _f = flakes[i];

    _f.y += _f.vy;
    _f.sway_phase += _f.sway_speed;
    _f.base_x += _wind_push;

    // покачивание, снежинка/снег плавно виляет из стороны в сторону, а не улетает
    if (_f.is_flake) {
        _f.anim_timer += 0.15;
        _f.frame = floor(_f.anim_timer) mod 6;
    }

    if (_f.y > room_height + 10) {
        array_delete(flakes, i, 1);
    }
}
