life++;

if (phase == "burst") {
    x += hsp;
    y += vsp;
    hsp *= 0.9;
    vsp *= 0.9;
    if (life >= 7) {
        phase = "rise";
        hsp *= 0.35;
        vsp = -rise_vsp;
    }
} else {
    wobble_timer += wobble_speed;
    x += hsp + sin(wobble_timer) * wobble_amp;
    y += vsp;
    vsp = lerp(vsp, -0.05, 0.025);
    hsp *= 0.97;
}

if (y < start_y - max_height || life >= life_max) {
    instance_destroy();
    exit;
}

if (image_index >= image_number - 1) {
    image_speed = 0;
}
