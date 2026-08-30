//var _t = lifetime / max_lifetime; // 0 = только появился, 1 = исчезает
//// плотность dithering: появляется и исчезает
//var _density;
//if (_t < 0.2) {
//    _density = _t / 0.2; // нарастает
//} else {
//    _density = 1 - ((_t - 0.2) / 0.8); // убывает
//}

//// байер матрица 4x4
//var _bayer = [
//     0,  8,  2, 10,
//    12,  4, 14,  6,
//     3, 11,  1,  9,
//    15,  7, 13,  5
//];

//var _r = radius;
//draw_set_color(c_white);
//draw_set_alpha(1);

//// сначала собираем какие пиксели белые
//var _white_pixels = ds_grid_create(ceil(_r * 2) + 4, ceil(_r * 2) + 4);
//ds_grid_clear(_white_pixels, false);
//var _ox = floor(x - _r) - 1;
//var _oy = floor(y - _r) - 1;

//for (var _py = y - _r; _py <= y + _r; _py++) {
//    for (var _px = x - _r; _px <= x + _r; _px++) {
//        var _dist = point_distance(x, y, _px, _py);
//        if (_dist > _r) continue;
//        var _edge = 1 - (_dist / _r);
//        var _final_density = _density * _edge;
//        var _bx = (floor(_px) mod 4 + 4) mod 4;
//        var _by = (floor(_py) mod 4 + 4) mod 4;
//        var _threshold = _bayer[_bx + _by * 4] / 16.0;
//        if (_final_density > _threshold) {
//            var _gx = floor(_px) - _ox;
//            var _gy = floor(_py) - _oy;
//            if (_gx >= 0 && _gy >= 0 && _gx < ds_grid_width(_white_pixels) && _gy < ds_grid_height(_white_pixels)) {
//                ds_grid_set(_white_pixels, _gx, _gy, true);
//            }
//        }
//    }
//}

//// рисуем чёрную обводку — соседи белых пикселей которые сами не белые
//draw_set_color(c_black);
//var _dirs = [[-1,0],[1,0],[0,-1],[0,1]];
//for (var _py = y - _r - 1; _py <= y + _r + 1; _py++) {
//    for (var _px = x - _r - 1; _px <= x + _r + 1; _px++) {
//        var _gx = floor(_px) - _ox;
//        var _gy = floor(_py) - _oy;
//        var _is_white = false;
//        if (_gx >= 0 && _gy >= 0 && _gx < ds_grid_width(_white_pixels) && _gy < ds_grid_height(_white_pixels)) {
//            _is_white = ds_grid_get(_white_pixels, _gx, _gy);
//        }
//        if (!_is_white) {
//            // проверяем соседей
//            var _has_white_neighbor = false;
//            for (var _d = 0; _d < 4; _d++) {
//                var _nx = _gx + _dirs[_d][0];
//                var _ny = _gy + _dirs[_d][1];
//                if (_nx >= 0 && _ny >= 0 && _nx < ds_grid_width(_white_pixels) && _ny < ds_grid_height(_white_pixels)) {
//                    if (ds_grid_get(_white_pixels, _nx, _ny)) {
//                        _has_white_neighbor = true;
//                        break;
//                    }
//                }
//            }
//            if (_has_white_neighbor) {
//                draw_point(_px, _py);
//            }
//        }
//    }
//}

//// рисуем белые пиксели
//draw_set_color(c_white);
//for (var _py = y - _r; _py <= y + _r; _py++) {
//    for (var _px = x - _r; _px <= x + _r; _px++) {
//        var _gx = floor(_px) - _ox;
//        var _gy = floor(_py) - _oy;
//        if (_gx >= 0 && _gy >= 0 && _gx < ds_grid_width(_white_pixels) && _gy < ds_grid_height(_white_pixels)) {
//            if (ds_grid_get(_white_pixels, _gx, _gy)) {
//                draw_point(_px, _py);
//            }
//        }
//    }
//}

//ds_grid_destroy(_white_pixels);

//draw_set_alpha(1);
//draw_set_color(c_white);

// прозрачность — исчезает чем выше
var _t = clamp((start_y - y) / max_height, 0, 1);
var _alpha = 1 - _t;
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, _alpha);