

// движение
x += move_speed * move_dir;
if (x > start_x + move_range) {
    x = start_x + move_range;
    move_dir = -1;
}
if (x < start_x - move_range) {
    x = start_x - move_range;
    move_dir = 1;
}

// обновляем позиции пил
for (var i = 0; i < saw_count; i++) {
    if (instance_exists(saws[i])) {
        saws[i].x = x;
        saws[i].y = y + i * saw_spacing;
    }
}