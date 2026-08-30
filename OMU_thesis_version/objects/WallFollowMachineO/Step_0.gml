if (!instance_exists(follow_target)) {
    instance_destroy();
    exit;
}
x = follow_target.x;
y = follow_target.y;