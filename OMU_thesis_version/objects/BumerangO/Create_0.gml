// pause
paused = false;
saved_speed = 0;
saved_direction = 0;
saved_boom_state = "idle";
saved_heading = 0;
saved_arc_angle_traveled = 0;
saved_max_dist_from_origin = 0;
// movement
spin = 0;
max_speed = 10;
spin_angle = 0;
wall = [WallO, WallTriangleO];
speed = 0;
direction = 0;
min_speed = 0.1;
// был ли уже засчитан удар о другой мяч (сбрасывается когда расходятся)
touching_bullet = false;

// короткое окно неуязвимости от повторного касания ИМЕННО с тем же врагом сразу
enemy_bounce_immune_id = noone;
enemy_bounce_immune_timer = 0;
// boomerang flight
boom_state = "idle";
origin_x = x;
origin_y = y;
kick_direction = 0;
launch_speed = 0;
heading = 0;
arc_angle_traveled = 0;
arc_side = 1;
turn_speed = 6.5; // больше = меньше круг
max_dist_from_origin = 0;
arrive_dist = 24;
wall_bounce_enabled = false;
prev_speed = 0;

function bumerang_start_flight() {
    boom_state = "flying";
    origin_x = x;
    origin_y = y;
    kick_direction = direction;
    heading = direction;
    launch_speed = max(speed, 4);
    arc_angle_traveled = 0;
    arc_side = choose(-1, 1);
    turn_speed = 6.5;
    max_dist_from_origin = 0;
    wall_bounce_enabled = false;
}

function bumerang_try_kick() {
    if (held) return false;
    if (instance_exists(PlayerBallerO) && place_meeting(PlayerBallerO.x, PlayerBallerO.y, ChillTriggerO)) return false;

    var _in_hit = place_meeting(x, y, BallerHitAreaO);
    var _mouse_kick = _in_hit && mouse_check_button_pressed(mb_left);
    var _gp_kick = false;
    if (_in_hit && instance_exists(PlayerBallerO) && gamepad_is_connected(PlayerBallerO.gamepad_index)) {
        _gp_kick = gamepad_button_check_pressed(PlayerBallerO.gamepad_index, gp_shoulderr);
    }
    if (_mouse_kick || _gp_kick) {
        speed = 4;
        if (instance_exists(PillsPowerUpO)) speed *= 1.1;
        if (_mouse_kick) {
            direction = point_direction(x, y, mouse_x, mouse_y);
        } else {
            var _rx = gamepad_axis_value(PlayerBallerO.gamepad_index, gp_axisrh);
            var _ry = gamepad_axis_value(PlayerBallerO.gamepad_index, gp_axisrv);
            if (abs(_rx) > 0.2 || abs(_ry) > 0.2) {
                direction = point_direction(0, 0, _rx, _ry);
            } else {
                direction = point_direction(0, 0, PlayerBallerO.image_xscale, 0);
            }
        }
        return true;
    }
    return false;
}

// teleport
teleporting = false;
teleport_timer = 0;
teleport_phase = 0;
teleport_base_xscale = image_xscale;
teleport_base_yscale = image_yscale;
teleport_white = 0;
// held
held = false;
item_state = "free";
var _trail = instance_create_layer(x, y, "EffectsL", TrailEffectO);
_trail.parent_obj = id;