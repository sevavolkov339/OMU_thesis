if (fade_mode == "in") {
    fade_progress += fade_speed;
    if (fade_progress >= 1) {
        fade_progress = 1;
        fade_done = true;
        fade_mode = "none";
    }
} else if (fade_mode == "out") {
    fade_progress -= fade_speed;
    if (fade_progress <= 0) {
        fade_progress = 0;
        fade_done = true;
        fade_mode = "none";
    }
}