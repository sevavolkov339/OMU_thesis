//if (held) {
//    speed = 0;
//    exit;
//}

if (explosion_cooldown > 0) explosion_cooldown--;

if (held) {
    speed = 0;
    mask_index = -1;
    if (instance_exists(PlayerBallerO) && !keyboard_check(vk_space)) {
        x = -9999;
        y = -9999;
    }
    exit;
}
// восстанавливаем маску и позицию когда отпустили
mask_index = sprite_index;

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