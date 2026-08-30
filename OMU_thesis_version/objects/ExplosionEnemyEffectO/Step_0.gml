// волна расширяется
wave_radius += wave_speed;
wave_alpha = max(wave_alpha - 0.05, 0);

if (!blinking) {
    timer++;
    if (timer >= duration) {
        blinking = true;
        blink_timer = 0;
    }
} else {
    blink_timer++;
    if (blink_timer >= blink_duration) {
        instance_destroy();
        exit;
    }
}