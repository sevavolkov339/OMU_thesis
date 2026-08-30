draw_set_alpha(0.35);
draw_set_color(c_white);

for (var gx = 0; gx <= grid_w; gx++) {
    var _x = origin_x + gx * cell_size;
    draw_line(_x, origin_y, _x, origin_y + grid_h * cell_size);
}
for (var gy = 0; gy <= grid_h; gy++) {
    var _y = origin_y + gy * cell_size;
    draw_line(origin_x, _y, origin_x + grid_w * cell_size, _y);
}

draw_set_alpha(1);
draw_set_color(c_white);
