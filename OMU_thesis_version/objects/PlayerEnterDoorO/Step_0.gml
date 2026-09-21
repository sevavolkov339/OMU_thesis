// запускаем чёрный fade-переход только для обычных дверей
if (!fade_started) {
    fade_started = true;
    if (!is_segment_final) {
        if (instance_exists(FadeTransitionWhiteO)) {
            instance_destroy(FadeTransitionWhiteO);
        }
        if (instance_exists(FadeTransitionO)) {
            FadeTransitionO.fade_in(0.03);
        } else {
            var _f = instance_create_layer(0, 0, "UIL", FadeTransitionO);
            _f.fade_progress = 0;
            _f.fade_in(0.03);
        }
        audio_play_sound(EnterDoorTransition_Snd, 1, 0);
    } else {
        // музыка обрывается сразу в момент входа в последнюю дверь сегмента
        GameControllerO.level_music_suppressed = true;
        GameControllerO.music_stop();
        audio_play_sound(EnterDoor_NoFadeTransition_Snd, 1, 0);
    }
}

// притягиваемся к центру двери
x = lerp(x, door_x, 0.12);
y = lerp(y, door_y, 0.12);

// крутимся вправо
angle -= spin_speed;

// уменьшаемся
xscale = lerp(xscale, 0, 0.03);
yscale = lerp(yscale, 0, 0.03);

// фейдимся
alpha = lerp(alpha, 0, 0.06);

if (alpha < 0.05) {
    if (is_segment_final) {
        // без fade-перехода, сразу отложенный переход на титульный экран
        GameControllerO.capture_current_room_state();
        GameControllerO.advance_to_next_title();
        instance_destroy();
    } else {
        var _fade_done = false;
        if (instance_exists(FadeTransitionO) && FadeTransitionO.fade_done) _fade_done = true;
        if (instance_exists(FadeTransitionWhiteO) && FadeTransitionWhiteO.fade_done) _fade_done = true;
        if (!instance_exists(FadeTransitionO) && !instance_exists(FadeTransitionWhiteO)) _fade_done = true;

        if (_fade_done) {
            GameControllerO.change_room();
            instance_destroy();
        }
    }
}