var cx = x;
var cy = y;
var _steps = 16;

for (var _py = cy - radius; _py <= cy + radius; _py++) {
    for (var _px = cx - radius; _px <= cx + radius; _px++) {
        var _dist = point_distance(cx, cy, _px, _py);
        if (_dist > radius) continue;
        
        // внутренний сплошной белый круг
        if (_dist < radius - fade_width) {
            draw_set_color(make_colour_rgb(204, 20, 128));
            draw_set_alpha(1);
            draw_point(_px, _py);
            continue;
        }
        
        // зона dithering
        var _t = (_dist - (radius - fade_width)) / fade_width; // 0..1
        
        // байер матрица 4x4 для ordered dithering
        var _bayer = [
             0,  8,  2, 10,
            12,  4, 14,  6,
             3, 11,  1,  9,
            15,  7, 13,  5
        ];
        var _bx = (_px mod 4 + 4) mod 4;
        var _by = (_py mod 4 + 4) mod 4;
        var _threshold = _bayer[_bx + _by * 4] / 16.0;
        
        if (_t < _threshold) {
            draw_set_color(make_colour_rgb(204, 20, 128));
            draw_set_alpha(1);
            draw_point(_px, _py);
        }
    }
}

draw_set_alpha(1);
draw_set_color(make_colour_rgb(204, 20, 128));