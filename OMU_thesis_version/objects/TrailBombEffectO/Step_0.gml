//alpha -= fade_speed;
//if (alpha <= 0) instance_destroy();


if (!instance_exists(parent_obj)) {
    // даём точкам догореть и удаляемся
    if (array_length(trail_points) == 0) instance_destroy();
} else {
    if (parent_obj.speed > 0.5) {
        point_timer++;
        if (point_timer >= point_interval) {
            point_timer = 0;
            var _pt = {
                x: parent_obj.x + 10,
                y: parent_obj.y - 7,
                lifetime: 0,
                max_lifetime: irandom_range(8, 16),
                size: irandom_range(3, 7)
            };
            array_insert(trail_points, 0, _pt);
            if (array_length(trail_points) > max_points) {
                array_delete(trail_points, array_length(trail_points) - 1, 1);
            }
        }
    }
}

// обновляем точки
for (var i = array_length(trail_points) - 1; i >= 0; i--) {
    trail_points[i].lifetime++;
    if (trail_points[i].lifetime >= trail_points[i].max_lifetime) {
        array_delete(trail_points, i, 1);
    }
}