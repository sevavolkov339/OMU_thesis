//shake
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

//pause

if (GameControllerO.game_paused)
{
    // остановить движение по пути
    path_end();

    speed = 0;
    hspeed = 0;
    vspeed = 0;

    exit;
}

// откинут шипами PuffFishO — на это время своя логика движения/AI отключена
if (puff_stunned) exit;

// AI

if instance_exists(PlayerBallerO){

	if (hp <= 0)
	{
	    var apple_count = apple_base;
	    if (instance_exists(ComboControllerO)) {
	        var cc = ComboControllerO;
	        switch (cc.combo) {
	            case 1: apple_count += cc.combo_1_bonus; break;
	            case 2: apple_count += cc.combo_2_bonus; break;
	            case 3: apple_count += cc.combo_3_bonus; break;
	        }
	        cc.add_kill();
	    }
    
	    for (var i = 0; i < apple_count; i++) {
	        instance_create_layer(x, y, "EffectsL", AppleO);
	    }
    
	    instance_destroy();
	    exit;
	}


	//collision with ball

	/*
	if (place_meeting(x,y,BulletBounceO)) {
		if (!touching_ball) {
			audio_play_sound(Enemy_Hit_Snd,0,0)
			shake = 3 //shake
			shake_timer = 10 
			hp -= 1.5;             // наносим урон только один раз
			touching_ball = true; // помечаем что касание уже началось
		}
	}
	*/

	if (shake_timer > 0){
		shake_timer--	
	}
	else{
		shake = 0
	}

	if (!EnemyTouchingMovingBulletScr()) {
	    touching_ball = false;
	}

}

// separation от других врагов
var sep_force = 12;
var sep_radius = 20;
with (EnemyO) {
    if (id != other.id) {
        var _dist = point_distance(x, y, other.x, other.y);
        if (_dist < sep_radius && _dist > 0) {
            var _dir = point_direction(x, y, other.x, other.y);
            var _force = (sep_radius - _dist) / sep_radius * sep_force;
            other.x += lengthdir_x(_force * 0.1, _dir);
            other.y += lengthdir_y(_force * 0.1, _dir);
        }
    }
}