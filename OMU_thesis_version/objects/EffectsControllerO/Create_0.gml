// cam shake
cam_shake_time  = 0;
cam_shake_power = 0;
cam_shake_ox    = 0;
cam_shake_oy    = 0;

// obj shake
obj_shakes = ds_map_create();

// camera
cam = view_camera[0];

// elevator effect
elevator_effect = false;

// white screen fade
white_alpha  = 0;
white_target = 0;
white_speed  = 0;

// линии
lines = [];

// параметры
spawn_chance = 0.6;
max_lines = 120;

// functions
function start_elevator_effect()
{
    elevator_effect = true;
}

function stop_elevator_effect()
{
    elevator_effect = false;
}

// плавно сделать экран белым
function start_white_fade(_time)
{
    white_target = 1;
    white_speed  = (_time > 0) ? (1 / _time) : 1;
}

// плавно вернуть экран обратно
function stop_white_fade(_time)
{
    white_target = 0;
    white_speed  = (_time > 0) ? (1 / _time) : 1;
}