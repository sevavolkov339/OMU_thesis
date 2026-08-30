if (!instance_exists(ref)) {
    instance_destroy();
    exit;
}
var _offset = 1;
gpu_set_fog(true, c_black, 0, 0);
draw_sprite_ext(ref.sprite_index, ref.image_index, ref.x - _offset, ref.y, ref.image_xscale, ref.image_yscale, ref.image_angle, c_black, 1);
draw_sprite_ext(ref.sprite_index, ref.image_index, ref.x + _offset, ref.y, ref.image_xscale, ref.image_yscale, ref.image_angle, c_black, 1);
draw_sprite_ext(ref.sprite_index, ref.image_index, ref.x, ref.y - _offset, ref.image_xscale, ref.image_yscale, ref.image_angle, c_black, 1);
draw_sprite_ext(ref.sprite_index, ref.image_index, ref.x, ref.y + _offset, ref.image_xscale, ref.image_yscale, ref.image_angle, c_black, 1);
gpu_set_fog(false, c_black, 0, 0);