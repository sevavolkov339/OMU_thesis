if (popped) {
    if (!pop_sound_played) {
        var _snd = audio_play_sound(BubbleWithHeartPop_Snd, 0, 0);
        audio_sound_pitch(_snd, random_range(0.8, 1.3));
        pop_sound_played = true;
    }
    image_speed = 1;
    if (image_index >= image_number - 1) {
        instance_destroy();
    }
} else {
    y -= rise_speed;
    bob_timer += bob_speed;
    x = base_x + sin(bob_timer) * bob_amp;
}