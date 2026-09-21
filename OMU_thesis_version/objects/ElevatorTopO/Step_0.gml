// object shake

if (shake_timer > 0) {
    var t = shake_timer / shake_duration;
    var cur = shake_strength * t;
    shake_offset_x = random_range(-cur, cur);
    shake_offset_y = random_range(-cur, cur);
    shake_timer--;
} else {
    shake_offset_x = 0;
    shake_offset_y = 0;
}


//event_inherited();

// pause

if (GameControllerO.game_paused) exit;

// arrive cutscene
if (arrive_active)
{
	image_alpha = 1
    arrive_timer++;

    var t = arrive_timer / arrive_duration;
    t = clamp(t, 0, 1);

    var eased = 1 - power(1 - t, 3);

    y = lerp(arrive_start_y, arrive_end_y, eased);

    if (arrive_timer == 1)
    {
        //ShakeScr(self, 10, 0.3);
    }

    // turn effect off
    if (!arrive_effect_stopped && t >= 0.5)
    {
        arrive_effect_stopped = true;

        if (instance_exists(EffectsControllerO))
        {
            with (EffectsControllerO)
                stop_elevator_effect();
        }
		ShakeScr(self, 10, 0.3);
    }

    // финал движения
	if (t >= 1)
	{
	    y = arrive_end_y;
	    arrive_active = false;
	    arrive_done   = true;

	    used = true; 
	}
    exit;
}



event_inherited();



// doors anim
is_vertical = (image_angle == 90 || image_angle == 270);

switch (state)
{
    case 1:
        gap = lerp(gap, max_gap, anim_speed);
        if (abs(gap - max_gap) < 0.5)
        {
            gap = max_gap;
            state = 2;
            opened_once = true;
        }
    break;

    case 3:
        gap = lerp(gap, 0, anim_speed);
        if (gap < 0.5)
        {
            gap = 0;
            state = 0;
            closed_once = true;
        }
    break;
}

// cutscene launch
if (LevelControllerO.level_completed && !lift_cutscene_active && !lift_cutscene_done)
{
    if (place_meeting(x, y, PlayerBallerO))
    {
        touch_timer++;

        if (touch_timer >= touch_delay)
        {
            start_cutscene_lift();
            lift_cutscene_done = true;
        }
    }
    else
    {
        touch_timer = 0;
    }
}

// lift cutscene
if (lift_cutscene_active)
{
    lift_cutscene_timer++;

    switch (lift_cutscene_step)
    {
        case 0:
            ShakeScr(self, 10, 0.3);
            lift_cutscene_step = 1;
            lift_cutscene_timer = 0;
        break;

        case 1:

	    if (!white_fade_started)
	    {
	        white_fade_started = true;

	        if (instance_exists(EffectsControllerO))
	        {
	            with (EffectsControllerO)
	            {
	                start_elevator_effect();
	                start_white_fade(room_speed * 0.6); // плавно белеет
	            }
	        }
	    }

	    var duration = room_speed * 1;
	    y -= 100 / duration;

	    if (lift_cutscene_timer >= duration)
	    {
	        lift_cutscene_step = 2;
	    }
		break;

        case 2:
			with LevelControllerO{
				change_room()	
			}
            lift_cutscene_active = false;
        break;
    }
}