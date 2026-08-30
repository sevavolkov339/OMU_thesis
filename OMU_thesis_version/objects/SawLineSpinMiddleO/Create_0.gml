saw_count = 9;
saw_spacing = 15;
spin_angle = 0;
spin_speed = 1;
pivot_x = x;
pivot_y = y;

saws = array_create(saw_count);
for (var i = 0; i < saw_count; i++) {
    var _saw = instance_create_layer(x + i * saw_spacing, y, "EffectsL", SawO);
    saws[i] = _saw;
}