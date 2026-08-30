if (GameControllerO.game_paused) exit;

timer++;
y += vy;

// мигание начинается после 60% времени
var blink_start = lifetime * 0.6;
if (timer > blink_start) {
    var t = (timer - blink_start) / (lifetime - blink_start);
    var blink_speed = lerp(4, 1, t); // ускоряется
    visible = (timer mod max(1, round(blink_speed))) < round(blink_speed * 0.5);
} else {
    visible = true;
}

if (timer >= lifetime) instance_destroy();
