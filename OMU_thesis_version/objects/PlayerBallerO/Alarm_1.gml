if (blink_time > 0) {
    // переключаем прозрачность
    if (image_alpha == 1) {
        image_alpha = 0.15;
    } else {
        image_alpha = 1;
    }
    blink_time -= 3;
    alarm[1] = 3; // как часто мигает
} else {
    // мигание закончилось
    image_alpha = 1;
}