if (popped) {
    image_speed = 1;
    if (image_index >= image_number - 1) {
		//var sndd = audio_play_sound(Ball_Kick_Snd,0,0);
		//audio_sound_pitch(sndd, random_range(0.8, 1.3));
        instance_destroy();
    }
} else {
    y -= rise_speed;
    bob_timer += bob_speed;
    x = base_x + sin(bob_timer) * bob_amp;
    
    if (y <= pop_height) {
		var _snd = audio_play_sound(BubblePop_Snd,0,0);
		audio_sound_pitch(_snd, random_range(0.8, 1.3));		
        popped = true;
        image_index = 0;
        image_speed = 1;
    }
}