// не создаваться если объект уже был пойман до сохранения
var _hgo_state = GameControllerO.get_current_room_state();
if (_hgo_state != undefined
    && variable_struct_exists(_hgo_state, "object_carried")
    && _hgo_state.object_carried) {
    instance_destroy();
    exit;
}



door_ref = noone;
state = "idle";
base_x = x;
base_y = y;
// покачивание синусом
sway_timer = 0;
sway_amplitude = 10;
sway_speed_val = 0.04;
// появление/скрытие
visible_scale = 0;
target_scale = 0;
offset_y = 0;
target_offset_y = 0;
hide_distance = 60;
show_distance = 60;
can_grab = false;
// захват
grabbed_obj_ref = noone;
grabbing = false;
grab_phase = "none"; // "none" -> "squash" -> "slide" -> "done"
grab_timer = 0;
grab_squash_x = 1;
grab_squash_y = 1;
grab_squash_x_speed = 0;
grab_squash_y_speed = 0;
grab_squash_stiffness = 0.3;
grab_squash_damping = 0.6;

//sounds

sound_appeared = false;
sound_disappeared = false;

prev_target_scale = 0;
sound_appeared = false;
sound_disappeared = false;