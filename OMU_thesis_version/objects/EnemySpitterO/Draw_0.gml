draw_sprite_ext(
    sprite_index,
    image_index,
    x + shake_offset_x,
    y + shake_offset_y,
    image_xscale * flip_scale_x * mouth_scale_x,
    image_yscale * flip_scale_y * mouth_scale_y,
    image_angle,
    c_white,
    image_alpha
);