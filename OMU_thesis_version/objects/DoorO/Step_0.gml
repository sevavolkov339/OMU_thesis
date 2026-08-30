
// закрытая при появлении дверь открывается, как только игрок сходит с её места
if (locked && !(instance_exists(PlayerBallerO) && place_meeting(x, y, PlayerBallerO))) {
    locked = false;
    image_index = 0;
}

if (!appearing && !instance_exists(HandGrabObjectO) && !hand_create && (room != GameControllerO.room_store)) and ((room != GameControllerO.room_chest && room != GameControllerO.room_store && room != GameControllerO.room_chill)) {
    var _room_state = GameControllerO.get_current_room_state();
    var _object_already_carried = _room_state != undefined
        && variable_struct_exists(_room_state, "object_carried")
        && _room_state.object_carried;

    if (_object_already_carried) {
        hand_create = true;
    } else {
        var _hand = instance_create_layer(x, y, "EffectsL", HandGrabObjectO);
        if (instance_exists(_hand)) {
            _hand.door_ref = id;
        }
        hand_create = true;
    }
}



if (appearing) {
	with (BulletBounceO) {
	    var _dist = point_distance(x, y, other.x, other.y);
	    var _combined = 50; // радиус отталкивания
	    if (_dist < _combined) {
	        var _dir = point_direction(other.x, other.y, x, y);
	        x += lengthdir_x(2, _dir);
	        y += lengthdir_y(2, _dir);
	    }
	}
}

if (appearing) {
	appear_timer++;
	var t = clamp(appear_timer / appear_duration, 0, 1);
	var t_ease = 1 - power(1 - t, 3);
	image_xscale = t_ease * base_xscale;
	image_yscale = base_yscale;
}
	




// тряска как у врага
if (shake_timer > 0) {
	var st = shake_timer / shake_duration;
	var cur = shake_strength * st;
	shake_offset_x = random_range(-cur, cur);
	shake_offset_y = random_range(-cur, cur);
	shake_timer--;
} else {
	shake_offset_x = 0;
	shake_offset_y = 0;
}


if (appearing && t >= 1) {
	appearing = false;
	image_xscale = base_xscale;
	image_yscale = base_yscale;
	shake_offset_x = 0;
	shake_offset_y = 0;
}




if (!locked && instance_exists(PlayerBallerO) && place_meeting(x, y, PlayerBallerO)) {
    var _enter = instance_create_layer(PlayerBallerO.x, PlayerBallerO.y, "PlayerL", PlayerEnterDoorO);
    _enter.door_x = x;
    _enter.door_y = y;
    _enter.enter_sprite = PlayerBallerO.sprite_index;
    _enter.enter_subimage = PlayerBallerO.image_index;
    _enter.spin_speed = (PlayerBallerO.sprite_index == PlayerBallerGoLeftS) ? -15 : 15;
    // последняя дверь сегмента — сама анимация игрока обычная, но без чёрного fade-перехода,
    // а по её окончании запускается отложенный переход на титульный экран вместо обычной смены комнаты
    _enter.is_segment_final = GameControllerO.is_segment_final_door();
    instance_destroy(PlayerBallerO);
}
