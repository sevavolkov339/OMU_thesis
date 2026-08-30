for (var i = 0; i < saw_count; i++) {
    if (instance_exists(saws[i])) {
        instance_destroy(saws[i]);
    }
}