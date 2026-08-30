spin_angle = (spin_angle + spin_speed) mod 360;

var _half = (saw_count - 1) * saw_spacing * 0.5; // половина длины линии

for (var i = 0; i < saw_count; i++) {
    if (instance_exists(saws[i])) {
        var _dist = i * saw_spacing - _half; // смещение от центра
        saws[i].x = pivot_x + lengthdir_x(_dist, spin_angle);
        saws[i].y = pivot_y + lengthdir_y(_dist, spin_angle);
    }
}