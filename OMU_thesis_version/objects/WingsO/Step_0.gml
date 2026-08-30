if (GameControllerO.game_paused) exit;

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

// позиция/спрайт/разворот крыльев обновляются в Draw_0 (после того как игрок уже
// точно доехал до своей позиции в этом кадре) — иначе крылья на кадр отстают от игрока

var _can_fly = (owner.state == PlayerState.PLAY) && !owner.stunned;

switch (fly_state) {
    case "ready":
        flying = false;
        image_index = 0;
        image_speed = 0;
        if (_can_fly && keyboard_check(vk_space)) {
            fly_state = "flying";
            fly_timer = 0;
            flying = true;
        }
    break;

    case "flying":
        flying = true;
        image_speed = 0.35; // машем крыльями только во время полёта
        fly_timer++;
        var _still_holding = _can_fly && keyboard_check(vk_space);
        if (!_still_holding || fly_timer >= fly_duration) {
            fly_state = "cooldown";
            cooldown_timer = 0;
            flying = false;
        }
    break;

    case "cooldown":
        flying = false;
        image_index = 0;
        image_speed = 0;
        cooldown_timer++;
        if (cooldown_timer >= cooldown_duration) {
            fly_state = "ready";
            cooldown_timer = 0;
        }
    break;
}
