

// движение
y += move_speed * move_dir;
if (y > start_y + move_range) {
    y = start_y + move_range;
    move_dir = -1;
}
if (y < start_y - move_range) {
    y = start_y - move_range;
    move_dir = 1;
}

// обновляем позиции пил
for (var i = 0; i < saw_count; i++) {
    if (instance_exists(saws[i])) {
        saws[i].x = x + i * saw_spacing;
        saws[i].y = y;
    }
}