var _count = 7 + irandom(5);
for (var i = 0; i < _count; i++) {
    instance_create_layer(x, y, "UIL", WaterDropO);
}
instance_destroy();