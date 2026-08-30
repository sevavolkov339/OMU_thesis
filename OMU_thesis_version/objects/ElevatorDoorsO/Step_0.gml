

//pause

if (GameControllerO.game_paused) exit;


// определяем ориентацию по повороту
is_vertical = (abs(image_angle) % 180 == 90);

// ===== Анимация =====
switch (state)
{
    case 1: // opening
        gap = lerp(gap, max_gap, anim_speed);
        if (abs(gap - max_gap) < 0.5)
        {
            gap = max_gap;
            state = 2; // open
            opened_once = true;
        }
    break;

    case 3: // closing
        gap = lerp(gap, 0, anim_speed);
        if (gap < 0.5)
        {
            gap = 0;
            state = 0; // closed
            closed_once = true;
        }
    break;
}

// automatic open close
var allow_doors = false;

// двери реагируют на игрока только если игрок в CUTSCENE или уровень пройден
if (instance_exists(PlayerBallerO))
{
    if (PlayerBallerO.state == PlayerState.CUTSCENE)
        allow_doors = true;
}

if (instance_exists(LevelControllerO))
{
    if (LevelControllerO.level_completed)
        allow_doors = true;
}


if (allow_doors && instance_exists(PlayerBallerO))
{
    // открыть — игрок близко и двери ещё не открывались
    if (state == 0 && !opened_once)
    {
        if (point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y) < open_distance)
            door_open();
    }

    // закрыть — игрок ушёл и двери ещё не закрывались
    if (state == 2 && opened_once && !closed_once)
    {
        if (point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y) > close_distance)
            door_close();
    }
}