if (instance_exists(PlayerBallerO)) {
    if (PlayerBallerO.y < y + 10) {
        layer = layer_get_id("EnemyBulletsL");
    } else if (PlayerBallerO.y > y + 10) {
        layer = layer_get_id("EffectsL");
    }
}

// анимация и звук
croak_timer--;
if (croak_timer <= 0) {
    image_index = 0;
    image_speed = 1;
    var _snd = audio_play_sound(Frog_Snd, 1, false);
    audio_sound_pitch(_snd, random_range(0.85, 1.15));
    croak_timer = irandom_range(90, 300); // следующее кваканье
}
// останавливаем анимацию после одного прохода
if (image_speed > 0 && image_index >= image_number - 1) {
    image_speed = 0;
    image_index = 0;
}