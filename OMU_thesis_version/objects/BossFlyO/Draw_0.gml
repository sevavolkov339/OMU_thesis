var _draw_x = x + shake_x + die_shake_x;
var _draw_y = y + shake_y + die_shake_y;
draw_sprite_ext(sprite_index, image_index,
    _draw_x, _draw_y,
    image_xscale, image_yscale,
    image_angle, c_white, 1);
// белый экран
if (die_white > 0) {
    draw_set_alpha(die_white);
    draw_set_color(c_white);
    draw_rectangle(
        camera_get_view_x(CameraControllerO.cam),
        camera_get_view_y(CameraControllerO.cam),
        camera_get_view_x(CameraControllerO.cam) + CameraControllerO.view_w,
        camera_get_view_y(CameraControllerO.cam) + CameraControllerO.view_h,
        false
    );
    draw_set_alpha(1);
    draw_set_color(c_white);
}