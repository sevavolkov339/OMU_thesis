for (var i = 0; i < array_length(parts); i++) {
    if (instance_exists(parts[i])) instance_destroy(parts[i]);
}
for (var i = 0; i < array_length(apple_instances); i++) {
    if (instance_exists(apple_instances[i])) instance_destroy(apple_instances[i]);
}