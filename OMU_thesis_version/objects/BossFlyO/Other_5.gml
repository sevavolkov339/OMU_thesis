// Room End — срабатывает при ЛЮБОМ уходе из комнаты (в т.ч. смерть игрока -> Death_Room/меню),
// в отличие от Destroy event, который не вызывается при обычной смене комнаты.
// Без этого жужжание оставалось в лупе даже после выхода в меню, если игрок умер, а не босс.
if (audio_is_playing(buzz_snd)) audio_stop_sound(buzz_snd);
if (quake_playing) {
    if (audio_is_playing(quake_deep_snd)) audio_stop_sound(quake_deep_snd);
    if (audio_is_playing(quake_snd)) audio_stop_sound(quake_snd);
}
