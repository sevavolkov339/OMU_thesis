apple_count = 1; // устанавливается снаружи при спавне
alpha = 1;
vy = -0.5;
lifetime = 90;
timer = 0;

// анимация букв
breath_timer = random_range(0, 6.28);
breath_speed = 0.08;
breath_amplitude = 1.5;
heart_phase_offset = 0.4;

var snd = audio_play_sound(CollectFlowers_Snd, 1, false);
audio_sound_pitch(snd, random_range(0.9, 1.1));

