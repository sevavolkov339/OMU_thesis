// pause

if (GameControllerO.game_paused) exit;


// ===== TIMER =====
attract_timer++;

if (!attracting && attract_timer >= attract_delay)
{
    attracting = true;
}

//// ===== SPIN =====
//image_angle += spin_speed;

// ===== MAGNET =====
if (attracting && instance_exists(PlayerBallerO))
{
    var px = PlayerBallerO.x;
    var py = PlayerBallerO.y;

    var dx = px - x;
    var dy = py - y;

    var dist = point_distance(x, y, px, py);

    // 👉 АВТОСБОР (анти-орбита)
    if (dist <= pickup_radius)
    {
        with (PlayerBallerO)
        {
            audio_play_sound(Apple_Collect_Snd, 1, false);
            money += 1;
        }
        instance_destroy();
        exit;
    }

    // нормализуем вектор
    dx /= dist;
    dy /= dist;

    // ускоряемся к игроку
    vx += dx * attract_force;
    vy += dy * attract_force;

    // ограничение скорости
    var spd = point_distance(0, 0, vx, vy);
    if (spd > max_speed)
    {
        vx = (vx / spd) * max_speed;
        vy = (vy / spd) * max_speed;
    }

    // гасим вращение
    //spin_speed = lerp(spin_speed, 0, 0.15);
}
else
{
    // ===== ОТСКОКИ ТОЛЬКО ДО ПРИТЯЖЕНИЯ =====

    if (place_meeting(x + vx, y, WallO))
        vx = -vx;

    if (place_meeting(x, y + vy, WallO))
        vy = -vy;
}

// ===== MOVE =====
x += vx;
y += vy;

// update trail
var t = {
    x: x,
    y: y
};

array_insert(trail, 0, t);

// ограничиваем длину
if (array_length(trail) > trail_max)
{
    array_resize(trail, trail_max);
}