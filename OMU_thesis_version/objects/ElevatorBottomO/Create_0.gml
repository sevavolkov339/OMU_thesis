
//object shake
shake_strength = 0;
shake_duration = 1; // 1 чтобы не было деления на ноль
shake_timer = 0;
shake_offset_x = 0;
shake_offset_y = 0;


//exit enter logic

event_inherited()

exitable = true;
enterable = false;
white_fade_started = false;


///elevator doors
door_height = 10;
door_width  = 45;

gap = 0;
max_gap = 40;
anim_speed = 0.1;

state = 0; // 0 closed, 1 opening, 2 open, 3 closing
opened_once = false;
closed_once = false;

open_distance  = 40;
close_distance = 40;

is_vertical = false;

///door functions
function door_open()
{
    if (state == 0 && !opened_once)
        state = 1;
	if !used{
		instance_destroy(WallDeletableBottomO)
	}
}

function door_close()
{
    if (state == 2 && opened_once && !closed_once)
        state = 3;
}

/// camera
camera_triggered = false;

/// cutscenes
//enter_cutscene = "ElevatorEnterTop";

/// lift cutscene
lift_cutscene_active = false;
lift_cutscene_done   = false; // importnt
lift_cutscene_step   = 0;
lift_cutscene_timer  = 0;

/// задержка перед стартом
touch_timer = 0;
touch_delay = room_speed * 1.5;

///start lift cutscene
function start_cutscene_lift()
{
    lift_cutscene_active = true;
    lift_cutscene_step = 0;
    lift_cutscene_timer = 0;
	//instance_destroy(WallDeletableBottomO,1)	
}

//arrive cutscene
arrive_active   = false;
arrive_done     = false;
arrive_timer    = 0;
arrive_duration = room_speed * 1.5;

arrive_start_y  = y + 100; // лифт стартует НИЖЕ
arrive_end_y    = y;       // и приезжает в текущую позицию

arrive_effect_stopped = false;

function start_arrive_cutscene()
{
    if (arrive_active || arrive_done) return;

    arrive_active = true;
    arrive_timer  = 0;
    y = arrive_start_y;

    // make screen white 
    if (instance_exists(EffectsControllerO))
    {
        with (EffectsControllerO)
        {
            white_alpha = 1; // мгновенно белый
            stop_white_fade(room_speed * 0.8); // плавно убираем за 0.8 сек
            start_elevator_effect();
        }
    }
}

//other



// visibility
image_alpha = 0;
fade_speed = 0.05;

/// state flags
player_inside = false;
used = false; 