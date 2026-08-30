var _pause_gp = instance_exists(PlayerBallerO) ? PlayerBallerO.gamepad_index : 0;
if (keyboard_check_pressed(vk_escape) || (gamepad_is_connected(_pause_gp) && gamepad_button_check_pressed(_pause_gp, gp_start)))
{
    toggle_pause();
}


// счётчик времени рана
if (!game_paused && run_active && room != Main_Menu_Room && room != Death_Room) {
    run_time += delta_time / 1000000;
}

// slow mo timer
if (slow_mo_timer > 0) {
    slow_mo_timer -= delta_time / 1000000;
    if (slow_mo_timer <= 0) {
        slow_mo_timer = 0;
        time_scale = 1.0;
        game_set_speed(original_speed, gamespeed_fps);
    }
}

// отложенный переход в следующую комнату (после последней двери сегмента уровней — музыка уже остановлена)
if (pending_room_change != noone && !game_paused) {
    pending_room_change_timer--;
    if (pending_room_change_timer <= 0) {
        var _dest = pending_room_change;
        pending_room_change = noone;
        room_goto(_dest);
    }
}

// смена музыки при входе/выходе из магазина (room_store — текущий магазин активного мира)
if (room == room_store && !in_store) {
    in_store = true;
    // сохраняем текущую музыку
    prev_music = current_music;
    prev_music_asset = current_music_asset;
    prev_music_pitch = current_music_pitch;
    // паузим прошлую
    if (audio_exists(prev_music)) audio_pause_sound(prev_music);
    // играем музыку магазина
    store_music = audio_play_sound(StoreMusic_Test, 10, true);
    current_music = store_music;
    current_music_asset = StoreMusic_Test;
    current_music_pitch = 1.0;
    audio_sound_pitch(current_music, 1.0);
} else if (room != room_store && in_store) {
    in_store = false;
    // останавливаем музыку магазина
    if (audio_exists(store_music)) audio_stop_sound(store_music);
    store_music = -1;
    // восстанавливаем прошлую музыку
    if (audio_exists(prev_music)) {
        audio_resume_sound(prev_music);
        audio_sound_pitch(prev_music, prev_music_pitch);
        current_music = prev_music;
        current_music_asset = prev_music_asset;
        current_music_pitch = prev_music_pitch;
    }
}

// смена музыки при входе/выходе из chill room (room_chill — текущая чилл-комната активного мира)
if (room == room_chill && !in_chillroom) {
    in_chillroom = true;
    // сохраняем текущую музыку
    prev_music = current_music;
    prev_music_asset = current_music_asset;
    prev_music_pitch = current_music_pitch;
    // паузим прошлую
    if (audio_exists(prev_music)) audio_pause_sound(prev_music);
    // играем три звука чилл комнаты
    chillroom_bells   = audio_play_sound(ChillBells_Snd,   10, true);
    chillroom_ambient = audio_play_sound(ChillAmbient_Snd, 10, true);
    chillroom_water   = audio_play_sound(WaterRunning_Snd, 10, true);
    current_music = chillroom_bells;
    current_music_asset = ChillBells_Snd;
    current_music_pitch = 1.0;
    audio_sound_pitch(chillroom_bells,   1.0);
    audio_sound_pitch(chillroom_ambient, 1.0);
    audio_sound_pitch(chillroom_water,   1.0);
} else if (room != room_chill && in_chillroom) {
    in_chillroom = false;
    // останавливаем все три звука
    if (audio_exists(chillroom_bells))   audio_stop_sound(chillroom_bells);
    if (audio_exists(chillroom_ambient)) audio_stop_sound(chillroom_ambient);
    if (audio_exists(chillroom_water))   audio_stop_sound(chillroom_water);
    chillroom_bells   = -1;
    chillroom_ambient = -1;
    chillroom_water   = -1;
    // восстанавливаем прошлую музыку
    if (audio_exists(prev_music)) {
        audio_resume_sound(prev_music);
        audio_sound_pitch(prev_music, prev_music_pitch);
        current_music = prev_music;
        current_music_asset = prev_music_asset;
        current_music_pitch = prev_music_pitch;
    }
}

// смена музыки при входе/выходе из chest room (room_chest — текущий сундук активного мира; и World_1_Room_0 — там играет та же музыка)
if ((room == room_chest || room == World_1_Room_1) && !in_chestroom) {
    in_chestroom = true;
    // сохраняем текущую музыку
    prev_music = current_music;
    prev_music_asset = current_music_asset;
    prev_music_pitch = current_music_pitch;
    // паузим прошлую
    if (audio_exists(prev_music)) audio_pause_sound(prev_music);
    // играем музыку магазина
    chestroom_music = audio_play_sound(SilenceChestRoom, 10, true);
    current_music = chestroom_music;
    current_music_asset = SilenceChestRoom;
    current_music_pitch = 1.0;
    audio_sound_pitch(current_music, 1.0);
} else if (room != room_chest && room != World_1_Room_1 && in_chestroom) {
    in_chestroom = false;
    // останавливаем музыку магазина
    if (audio_exists(chestroom_music)) audio_stop_sound(chestroom_music);
    chestroom_music = -1;
    // восстанавливаем прошлую музыку
    if (audio_exists(prev_music)) {
        audio_resume_sound(prev_music);
        audio_sound_pitch(prev_music, prev_music_pitch);
        current_music = prev_music;
        current_music_asset = prev_music_asset;
        current_music_pitch = prev_music_pitch;
    }
}

// смена музыки при входе/выходе из transition room
if (room == World_1_TransitionRoom && !in_transition) {
    in_transition = true;
    prev_music = current_music;
    prev_music_asset = current_music_asset;
    prev_music_pitch = current_music_pitch;
    if (audio_exists(prev_music)) audio_pause_sound(prev_music);
    transition_music = audio_play_sound(HolySound_WhiteTransitionRoom, 10, true);
    current_music = transition_music;
    current_music_asset = HolySound_WhiteTransitionRoom;
    current_music_pitch = 1.0;
    audio_sound_pitch(current_music, 1.0);
} else if (room != World_1_TransitionRoom && in_transition) {
    in_transition = false;
    if (audio_exists(transition_music)) audio_stop_sound(transition_music);
    transition_music = -1;
    if (audio_exists(prev_music)) {
        audio_resume_sound(prev_music);
        audio_sound_pitch(prev_music, prev_music_pitch);
        current_music = prev_music;
        current_music_asset = prev_music_asset;
        current_music_pitch = prev_music_pitch;
    }
}


// музыка уровней (World_1_Test_Track) — играет только в боевых комнатах случайных сегментов,
// не в меню/титрах/якорной комнате/магазине/сундуке/чилле
var _in_levels_segment = (world_stage == "levels1" || world_stage == "levels2" || world_stage == "levels3");
var _in_special_room = in_store || in_chestroom || in_chillroom;
if (_in_levels_segment && !_in_special_room && !level_music_suppressed) {
    music_play(World_1_Test_Track);
} else if (!_in_levels_segment && current_music_asset == World_1_Test_Track) {
    music_stop();
}

// плавный питч музыки под time_scale
if (audio_exists(current_music) && !in_store) {
    var _combo = saved_combo;
    var _combo_pitch = 1.0;
    if (_combo == 1) _combo_pitch = 1.08;
    else if (_combo == 2) _combo_pitch = 1.18;
    else if (_combo == 3) _combo_pitch = 1.32;
    var _deviation = time_scale - 1.0;
    var _target_pitch = _combo_pitch + _deviation * 1.8;
    current_music_pitch = lerp(current_music_pitch, _target_pitch, 0.08);
    audio_sound_pitch(current_music, current_music_pitch);
}

