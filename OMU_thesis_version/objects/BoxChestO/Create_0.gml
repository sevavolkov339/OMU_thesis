origin_x = x;
origin_y = y;
vel_x = 0;
vel_y = 0;
friction_spd = 0.98;
bounce_damp = 0.6;

// squash and stretch
squash_x = 1;
squash_y = 1;
squash_x_speed = 0;
squash_y_speed = 0;
squash_stiffness = 0.3;
squash_damping = 0.6;

// состояние
opened = false;
was_touching_player = false;

kick_cooldown = 0;

// проверяем сохранённое состояние сундука
if (instance_exists(GameControllerO)) {
    var _chest_state = GameControllerO.get_current_room_state();
    if (_chest_state != undefined && _chest_state.chest_opened) {
        opened = true;
        image_index = 1;
        image_speed = 0;
    }
}