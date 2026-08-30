if (GameControllerO.game_paused) exit;

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

float_timer += 0.05;
x = owner.x + 10;
y = owner.y + owner.fly_visual_y - 18 + sin(float_timer) * 2;
