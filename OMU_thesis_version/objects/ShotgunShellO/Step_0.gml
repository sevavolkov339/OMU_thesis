if (speed <= 0) exit;

if (speed > max_speed) speed = max_speed;

speed *= 0.98;
if (speed < min_speed) speed = 0;

if (speed == 0) exit;

var next_x = x + lengthdir_x(speed, direction);
var next_y = y + lengthdir_y(speed, direction);
var old_direction = direction;

if (place_meeting(next_x, next_y, wall)) {
    spin_dir *= -1;
    var surface_normal = collision_normal(next_x, next_y, wall, 6, 2);
    if (surface_normal != -1) {
        var incident_x = lengthdir_x(1, direction);
        var incident_y = lengthdir_y(1, direction);
        var normal_x = lengthdir_x(1, surface_normal);
        var normal_y = lengthdir_y(1, surface_normal);
        var dot = incident_x * normal_x + incident_y * normal_y;
        var reflect_x = incident_x - 2 * dot * normal_x;
        var reflect_y = incident_y - 2 * dot * normal_y;
        direction = point_direction(0, 0, reflect_x, reflect_y);
    } else {
        if (place_meeting(x + lengthdir_x(speed, direction), y, wall)) direction = 180 - direction;
        if (place_meeting(x, y + lengthdir_y(speed, direction), wall)) direction = -direction;
    }
    var safe_distance = 0;
    var max_check = min(speed, 12);
    for (var dist = 0; dist <= max_check; dist += 0.5) {
        var check_x = x + lengthdir_x(dist, old_direction);
        var check_y = y + lengthdir_y(dist, old_direction);
        if (!place_meeting(check_x, check_y, wall)) {
            safe_distance = dist;
        } else {
            break;
        }
    }
    if (safe_distance > 0) {
        x += lengthdir_x(safe_distance, old_direction);
        y += lengthdir_y(safe_distance, old_direction);
    }
    if (place_meeting(x, y, wall)) {
        var push_normal = collision_normal(x, y, wall, 6, 2);
        if (push_normal != -1) {
            x += lengthdir_x(2, push_normal);
            y += lengthdir_y(2, push_normal);
        }
    }
    next_x = x + lengthdir_x(speed, direction);
    next_y = y + lengthdir_y(speed, direction);
}

if (!place_meeting(next_x, next_y, wall)) {
    x = next_x;
    y = next_y;
} else {
    for (var i = 1; i <= 6; i++) {
        var try_x = x + lengthdir_x(i, direction + 180);
        var try_y = y + lengthdir_y(i, direction + 180);
        if (!place_meeting(try_x, try_y, wall)) {
            x = try_x;
            y = try_y;
            break;
        }
    }
}

spin_angle += speed * spin_rate * spin_dir;
image_angle = floor(spin_angle / spin_step) * spin_step;
