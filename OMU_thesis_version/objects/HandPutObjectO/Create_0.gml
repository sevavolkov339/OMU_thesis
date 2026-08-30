if (GameControllerO.carried_object == noone) {
    instance_destroy();
    exit;
}
carried_obj_type = GameControllerO.carried_object;
GameControllerO.carried_object = noone;
// целевая позиция — где спавним объект
target_x = x;
target_y = y;
// определяем ближайший край экрана и стартовую позицию руки
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
var _dist_left   = target_x - _cam_x;
var _dist_right  = (_cam_x + _cam_w) - target_x;
var _dist_top    = target_y - _cam_y;
var _dist_bottom = (_cam_h + _cam_y) - target_y;
var _min_dist = min(_dist_left, _dist_right, _dist_top, _dist_bottom);
var _overshoot = 80;
if (_min_dist == _dist_left) {
    start_x = _cam_x - _overshoot;
    start_y = target_y;
    image_angle = 90;
} else if (_min_dist == _dist_right) {
    start_x = _cam_x + _cam_w + _overshoot;
    start_y = target_y;
    image_angle = -90;
} else if (_min_dist == _dist_top) {
    start_x = target_x;
    start_y = _cam_y - _overshoot;
    image_angle = 180;
} else {
    start_x = target_x;
    start_y = _cam_y + _cam_h + _overshoot;
    image_angle = 0;
}
x = start_x;
y = start_y;
// спавним объект сразу, он будет следовать за рукой
carried_inst = instance_create_layer(x, y, "BulletsL", carried_obj_type);
if (instance_exists(carried_inst)) {
    carried_inst.speed = 0;
    if (variable_instance_exists(carried_inst, "held")) carried_inst.held = true;
    carried_inst.image_xscale = 0;
    carried_inst.image_yscale = 0;
}
// фазы: "in" -> "place" -> "out" -> done
phase = "in";
phase_timer = 0;
in_duration  = 18;
out_duration = 18;
place_duration = 12;
image_xscale = 1;
image_yscale = 1;