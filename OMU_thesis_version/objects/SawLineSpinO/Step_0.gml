spin_angle = (spin_angle + spin_speed) mod 360;

// крутим все пилы относительно первой
for (var i = 0; i < saw_count; i++) {
    if (instance_exists(saws[i])) {
        var _dist = i * saw_spacing;
        saws[i].x = pivot_x + lengthdir_x(_dist, spin_angle);
        saws[i].y = pivot_y + lengthdir_y(_dist, spin_angle);
    }
}