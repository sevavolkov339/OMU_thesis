if (teleporting && teleport_white > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha * teleport_white);
    gpu_set_fog(false, 0, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha * (1 - teleport_white));
} else {
    draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_black, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_black, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_black, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, c_black, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
}
