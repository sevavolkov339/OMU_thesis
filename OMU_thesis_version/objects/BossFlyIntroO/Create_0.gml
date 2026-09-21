// стартуем за экраном
var _cam_x = camera_get_view_x(CameraControllerO.cam);
var _cam_y = camera_get_view_y(CameraControllerO.cam);
x = _cam_x - 80;
y = _cam_y + CameraControllerO.view_h * 0.5;

// цель, центр комнаты
intro_target_x = room_width * 0.5;
intro_target_y = room_height * 0.5;

// шатание во время полёта
intro_wobble_timer = 0;
intro_wobble_x = 0;
intro_wobble_y = 0;

// скорость подлёта
intro_spd_x = 0;
intro_spd_y = 0;

// фаза
intro_phase = 0;
intro_timer = 0;
intro_shake_duration = 2 * room_speed;

shake_x = 0;
shake_y = 0;

// землетрясение во время тряски перед появлением босса
quake_deep_snd = -1;
quake_snd = -1;

image_speed = 1;