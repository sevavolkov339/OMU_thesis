//if (shake_timer > shake_duration * 0.1) {
//    gpu_set_fog(true, c_white, 0, 0);
//}
//draw_sprite_ext(
// sprite_index, image_index
//);
//if (shake_timer > shake_duration * 0.1) {
//    gpu_set_fog(false, 0, 0, 0);
//}


draw_sprite_ext(
    sprite_index,
    image_index,
    x + shake_offset_x,
    y + shake_offset_y,
    image_xscale,
    image_yscale,
    image_angle,
    c_white,
    image_alpha
);