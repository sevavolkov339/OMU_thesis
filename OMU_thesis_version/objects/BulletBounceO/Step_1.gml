if (held) {
    speed = 0;
    exit;
}

if (GameControllerO.game_paused)
{
    if (!paused)
    {
        // сохранить состояние один раз
        saved_speed = speed;
        saved_direction = direction;
        paused = true;
    }
	speed = 0
    image_speed = 0;

    // do nothing
    exit;
}
else if (paused)
{
    // выход из паузы
    speed = saved_speed;
    direction = saved_direction;
    paused = false;
}