//pause

if (GameControllerO.game_paused) exit;



//camera shake
if (cam_shake_time > 0)
{
    cam_shake_time--;
    cam_shake_ox = random_range(-cam_shake_power, cam_shake_power);
    cam_shake_oy = random_range(-cam_shake_power, cam_shake_power);
}
else
{
    cam_shake_ox = 0;
    cam_shake_oy = 0;
}

//obj shake
var key = ds_map_find_first(obj_shakes);
while (key != undefined)
{
    if (!instance_exists(key))
    {
        ds_map_delete(obj_shakes, key);
        key = ds_map_find_first(obj_shakes);
        continue;
    }

    var s = obj_shakes[? key];

    if (s.time > 0)
    {
        s.time--;
        s.ox = random_range(-s.power, s.power);
        s.oy = random_range(-s.power, s.power);
        obj_shakes[? key] = s;

        key.draw_ox = s.ox;
        key.draw_oy = s.oy;
    }
    else
    {
        key.draw_ox = 0;
        key.draw_oy = 0;
        ds_map_delete(obj_shakes, key);
    }

    key = ds_map_find_next(obj_shakes, key);
}

//elevator effect
if (elevator_effect)
{
    if (random(1) < spawn_chance && array_length(lines) < max_lines)
    {
        var l = {
            x: random(camera_get_view_width(cam)),
            y: -20,
            len: irandom_range(20, 80),
            speed: random_range(8, 18),
            alpha: 0,
            life: irandom_range(30, 80),
            fade_speed: random_range(0.03, 0.08)
        };

        array_push(lines, l);
    }
}

// обновление линий
for (var i = array_length(lines) - 1; i >= 0; i--)
{
    var l = lines[i];

    l.y += l.speed;

    if (l.life > 20)
        l.alpha = min(l.alpha + l.fade_speed, 1);
    else
        l.alpha = max(l.alpha - l.fade_speed, 0);

    l.life--;

    if (l.life <= 0)
        array_delete(lines, i, 1);
}



//white screen update
if (white_alpha != white_target)
{
    if (white_alpha < white_target)
        white_alpha = min(white_alpha + white_speed, white_target);
    else
        white_alpha = max(white_alpha - white_speed, white_target);
}