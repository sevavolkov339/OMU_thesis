


if (GameControllerO.game_paused) exit;
if (instance_exists(LevelControllerO) && (LevelControllerO.level_completed or !LevelControllerO.enemies_spawned)) exit;

if (combo_bar >= 0.999) {
    if (combo < max_combo) {
        combo++;
        combo_bar = combo_start_fill[combo];
        
        // звук с питчем в зависимости от комбо
        var sound = audio_play_sound(ComboUp_Snd, 0, false);
        audio_sound_pitch(sound, 0.8 + (combo * 0.2)); // 1x = 1.0, 2x = 1.2, 3x = 1.4
    } else {
        combo_bar = 1;
    }
}


// потом убываем
var drain = drain_base * (1 + combo * 0.6);
combo_bar -= drain;

if (combo_bar <= 0) {
    combo_bar = 0;
    if (combo > 0) { // только если комбо было активно
        audio_play_sound(ComboStop_Snd, 0, false);
    }
    combo = 0;
}

if (keyboard_check_pressed(ord("K"))) {
    add_kill();
}

if (instance_exists(GameControllerO)) {
    GameControllerO.saved_combo = combo;
    GameControllerO.saved_combo_bar = combo_bar;
}