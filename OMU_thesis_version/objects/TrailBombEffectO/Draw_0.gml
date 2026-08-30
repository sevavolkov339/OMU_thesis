var _count = array_length(trail_points);
if (_count == 0) exit;
for (var i = 0; i < _count; i++) {
    var _pt = trail_points[i];
    var _t = _pt.lifetime / _pt.max_lifetime;
    var _threshold = (1 - _t) * 16;
    var _size = floor(_pt.size * 0.45); // значительно меньше
    if (_size < 1) _size = 1;
    var _half = _size / 2;
    var _px_start = floor(_pt.x - _half);
    var _py_start = floor(_pt.y - _half);
    // обводка чёрная
    draw_set_color(c_black);
    for (var _py = 0; _py < _size; _py++) {
        for (var _px = 0; _px < _size; _px++) {
            var _bx = _px mod 4;
            var _by = _py mod 4;
            var _bval = bayer[_bx + _by * 4];
            if (_bval < _threshold) {
                draw_point(_px_start + _px - 1, _py_start + _py);
                draw_point(_px_start + _px + 1, _py_start + _py);
                draw_point(_px_start + _px, _py_start + _py - 1);
                draw_point(_px_start + _px, _py_start + _py + 1);
            }
        }
    }
    // красные пиксели поверх
    draw_set_color(make_color_rgb(255, 60, 60));
    for (var _py = 0; _py < _size; _py++) {
        for (var _px = 0; _px < _size; _px++) {
            var _bx = _px mod 4;
            var _by = _py mod 4;
            var _bval = bayer[_bx + _by * 4];
            if (_bval < _threshold) {
                draw_point(_px_start + _px, _py_start + _py);
            }
        }
    }
}