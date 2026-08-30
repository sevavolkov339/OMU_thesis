skip_intro = false; // LevelControllerO выставляет true при восстановлении из сохранения


appearing = false;
appear_timer = 0;
appear_duration = 30;
base_xscale = 1;
base_yscale = 1;
image_xscale = 1;
image_yscale = 1;
shake_x = 0;
shake_amount = 3;
shake_offset_x = 0;
shake_offset_y = 0;
shake_timer = 0;
shake_duration = 20;
shake_strength = 10;
hand_create = false;

// если дверь появилась прямо под игроком — она "закрыта" (2й кадр), чтобы он не проваливался
// в неё сразу; открывается (1й кадр), как только игрок сам отойдёт с этого места
locked = instance_exists(PlayerBallerO) && place_meeting(x, y, PlayerBallerO);
image_index = locked ? 1 : 0;


if (!skip_intro){
	if (room != GameControllerO.room_chest && room != GameControllerO.room_store && room != GameControllerO.room_chill && room != World_1_Room_0) {
	    CameraControllerO.camera_shake(2, 15);
	    GameControllerO.slow_mo(0.6, 0.3);
	    repeat (13) {
	        var _p = instance_create_layer(x + 2, y + 5, "EffectsL", DoorParticleEffectO);
	        _p.vx = random_range(-2, 2);
	        _p.vy = random_range(-3, -0.5);
	        _p.max_lifetime = random_range(30, 50);
	        _p.size = random_range(0.8, 1.4);
	    }
	    var snd = audio_play_sound(DoorAppear_Snd, 1, false);
	    appearing = true;
	    image_xscale = 0;
	    shake_timer = shake_duration;
	}


	//// отбрасываем все предметы вокруг
	//var _push_radius = 80;
	//var _push_force = 100;
	//with (BulletBounceO) {
	//    var _dist = point_distance(x, y, other.x, other.y);
	//    if (_dist < _push_radius) {
	//        var _dir = point_direction(other.x, other.y, x, y) + 180;
	//        var _force = _push_force * (1 - _dist / _push_radius);
	//        speed += _force;
	//        direction = _dir;
	//    }
	//}

}