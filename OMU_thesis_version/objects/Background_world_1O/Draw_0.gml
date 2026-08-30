if (flash_active && blink_visible) {
    var cam = CameraControllerO.cam;
    var cx = camera_get_view_x(cam);
    var cy = camera_get_view_y(cam);
    var cw = CameraControllerO.view_w;
    var ch = CameraControllerO.view_h;
    draw_set_alpha(flash_alpha);
    draw_set_color(make_color_rgb(180, 0, 0));
    draw_rectangle(cx, cy, cx + cw, cy + ch, false);
    draw_set_alpha(1);
}