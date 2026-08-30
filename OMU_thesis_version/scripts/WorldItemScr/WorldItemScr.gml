function world_item_create() {
    item_data = {
        name: "unknown",
        sprite: -1,
        cost: 0,
        type: "Item",
        description: ""
    };
    speed = 0;
    direction = 0;
    friction_amt = 0.97;
    min_speed = 0.3;
    wall = [WallO, WallTriangleO];
    bounce_count = 0;
    max_bounces = 4;
    shake_strength = 0;
    shake_duration = 1;
    shake_timer = 0;
    shake_offset_x = 0;
    shake_offset_y = 0;
}

function world_item_step() {
    // шейк
    if (shake_timer > 0) {
        var t = shake_timer / shake_duration;
        var cur = shake_strength * t;
        shake_offset_x = random_range(-cur, cur);
        shake_offset_y = random_range(-cur, cur);
        shake_timer--;
    } else {
        shake_offset_x = 0;
        shake_offset_y = 0;
    }

    if (speed > 0) {
        speed *= friction_amt;
        if (speed < min_speed) speed = 0;

        var next_x = x + lengthdir_x(speed, direction);
        var next_y = y + lengthdir_y(speed, direction);

        if (place_meeting(next_x, next_y, wall)) {
            if (bounce_count < max_bounces) {
                var surface_normal = collision_normal(next_x, next_y, wall, 8, 2);
                if (surface_normal != -1) {
                    var ix = lengthdir_x(1, direction);
                    var iy = lengthdir_y(1, direction);
                    var nx = lengthdir_x(1, surface_normal);
                    var ny = lengthdir_y(1, surface_normal);
                    var dot = ix * nx + iy * ny;
                    direction = point_direction(0, 0, ix - 2*dot*nx, iy - 2*dot*ny);
                } else {
                    if (place_meeting(x + lengthdir_x(speed, direction), y, wall)) direction = 180 - direction;
                    if (place_meeting(x, y + lengthdir_y(speed, direction), wall)) direction = -direction;
                }
                speed *= 0.8;
                bounce_count++;
            } else {
                speed = 0;
            }
            next_x = x + lengthdir_x(speed, direction);
            next_y = y + lengthdir_y(speed, direction);
        }

        x = next_x;
        y = next_y;
    }

    // подбор игроком
    if (instance_exists(PlayerBallerO)) {
        if (distance_to_object(PlayerBallerO) < 10) {
            if (instance_exists(InventoryControllerO)) {
                var added = InventoryControllerO.add_item(item_data);
                if (added) instance_destroy();
            }
        }
    }
}