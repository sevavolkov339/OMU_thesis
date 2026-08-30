var _cs = cell_size;

draw_set_alpha(0.5);
for (var gx = 0; gx < grid_w; gx++) {
    for (var gy = 0; gy < grid_h; gy++) {
        var _wx = gx * _cs;
        var _wy = gy * _cs;
        if (coarse_grid[gx][gy] == 1) {
            draw_set_color(c_red);
            draw_rectangle(_wx, _wy, _wx + _cs, _wy + _cs, false);
        } else {
            draw_set_color(c_white);
            draw_rectangle(_wx, _wy, _wx + _cs, _wy + _cs, true);
        }
    }
}
draw_set_alpha(1);
draw_set_color(c_white);