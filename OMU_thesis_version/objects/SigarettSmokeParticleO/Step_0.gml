wobble_timer += wobble_speed;
x += hsp + sin(wobble_timer) * wobble_amp;
y -= vsp;
vsp = lerp(vsp, 0.02, 0.02);
hsp *= 0.97;
if (y < start_y - max_height) {
    instance_destroy();
    exit;
}
if (image_index >= image_number - 1) {
    instance_destroy();
}