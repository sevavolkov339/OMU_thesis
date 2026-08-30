if (fading) {
    fade_alpha = min(fade_alpha + fade_speed, 1);
    if (fade_alpha >= 1) {
        fade_done = true;
    }
}