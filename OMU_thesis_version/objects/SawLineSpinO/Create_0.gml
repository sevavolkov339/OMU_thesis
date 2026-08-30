saw_count = 6;
saw_spacing = 15; // расстояние между пилами
spin_angle = 0;   // угол вращения всей линии
spin_speed = 1;   // скорость вращения линии
pivot_x = x;      // центр вращения — первая пила
pivot_y = y;

// спавним пилы
saws = array_create(saw_count);
for (var i = 0; i < saw_count; i++) {
    var _saw = instance_create_layer(x + i * saw_spacing, y, "EffectsL", SawO);
    saws[i] = _saw;
}