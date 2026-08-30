// след стоит life_time кадров, потом плавно угасает и уничтожается
if (life_time > 0) {
    life_time--;
} else {
    image_alpha -= fade_speed;
    if (image_alpha <= 0) {
        instance_destroy();
    }
}
