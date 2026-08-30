if (GameControllerO.game_paused) exit;

switch (intro_phase) {
    case 0: // летим к центру с шатанием
        intro_wobble_timer += 0.08;

        var _dx = intro_target_x - x;
        var _dy = intro_target_y - y;
        intro_spd_x += _dx * 0.02;
        intro_spd_y += _dy * 0.02;
        intro_spd_x *= 0.85;
        intro_spd_y *= 0.85;

        intro_wobble_x = sin(intro_wobble_timer * 1.3) * 5;
        intro_wobble_y = cos(intro_wobble_timer * 0.9) * 7;

        x += intro_spd_x;
        y += intro_spd_y;

        image_speed = 1;

        if (point_distance(x, y, intro_target_x, intro_target_y) < 4
            && abs(intro_spd_x) < 0.3 && abs(intro_spd_y) < 0.3) {
            x = intro_target_x;
            y = intro_target_y;
            intro_spd_x = 0;
            intro_spd_y = 0;
            intro_wobble_x = 0;
            intro_wobble_y = 0;
            intro_phase = 1;
            intro_timer = 0;
            CameraControllerO.camera_shake(4, 20);
            quake_deep_snd = audio_play_sound(EarthquakeDeepSnd, 0, true);
            quake_snd = audio_play_sound(EarthquakeSnd, 0, true);
        }
    break;

    case 1: // трясёмся на месте
        intro_timer++;
        shake_x = random_range(-3, 3);
        shake_y = random_range(-3, 3);

        if (intro_timer mod floor(room_speed * 0.5) == 0) {
            CameraControllerO.camera_shake(3, 15);
        }

        if (intro_timer >= intro_shake_duration) {
            // тряска закончилась — землетрясение стихает вместе с ней
            if (audio_is_playing(quake_deep_snd)) audio_stop_sound(quake_deep_snd);
            if (audio_is_playing(quake_snd)) audio_stop_sound(quake_snd);
            // спавним настоящего босса и удаляемся
            var _boss = instance_create_layer(x, y, "EnemiesL", BossFlyO);
            instance_destroy();
        }
    break;
}