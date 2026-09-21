// room End, срабатывает при ЛЮБОМ уходе из комнаты
if (audio_is_playing(buzz_snd)) audio_stop_sound(buzz_snd);
if (quake_playing) {
    if (audio_is_playing(quake_deep_snd)) audio_stop_sound(quake_deep_snd);
    if (audio_is_playing(quake_snd)) audio_stop_sound(quake_snd);
}
