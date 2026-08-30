timer = 0;
duration = 0.1 * room_speed;
blink_timer = 0;
blink_duration = 0.3 * room_speed;
blinking = false;
radius = 20;

// волна
wave_radius = 0;
wave_speed = 20;
wave_alpha = 1;
wave_width = 2.5;

var snd = audio_play_sound(ObjectsCollide_Snd, 1, false);
audio_sound_pitch(snd, random_range(0.8, 1.2));