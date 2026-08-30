timer = 0;
duration = 0.1 * room_speed;
blink_timer = 0;
blink_duration = 0.3 * room_speed;
blinking = false;
radius = 20;

// волна
wave_radius = 0;
wave_speed = 8;
wave_alpha = 1;
wave_width = 3;

var snd = audio_play_sound(EnemyExplosion2_Snd, 0, false);
audio_sound_pitch(snd, random_range(0.8, 1.2));

if (instance_exists(Background_world_1O)) {
    Background_world_1O.flash_active = true;
    Background_world_1O.flash_timer = 0;
    Background_world_1O.blink_timer = 0;
    Background_world_1O.blink_visible = true;
}