// силуэт игрока, рисуется в Draw GUI, поэтому виден всегда поверх всего
if (player_behind_mill && surface_exists(silhouette_surf)) {
    var _cam = view_camera[0];
    var _cx = camera_get_view_x(_cam);
    var _cy = camera_get_view_y(_cam);
    var _cw = camera_get_view_width(_cam);
    var _ch = camera_get_view_height(_cam);
    var _scale_x = display_get_gui_width() / _cw;
    var _scale_y = display_get_gui_height() / _ch;

    var _gui_x = (silhouette_origin_x - _cx) * _scale_x;
    var _gui_y = (silhouette_origin_y - _cy) * _scale_y;

    // отключаем билинейную фильтрацию на время отрисовки
    var _prev_filter = gpu_get_texfilter();
    gpu_set_texfilter(false);
    draw_surface_ext(silhouette_surf, _gui_x, _gui_y, _scale_x, _scale_y, 0, c_white, 1);
    gpu_set_texfilter(_prev_filter);
}
