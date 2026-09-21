//var _route_len = array_length(route);
//if (_route_len == 0) exit;

//draw_set_font(SmallFnt);

//var _icon_w = 10;
//var _icon_h = 10;
//var _gap = 4;
//var _total_w = _route_len * _icon_w + (_route_len - 1) * _gap;
//var _start_x = (display_get_gui_width() - _total_w) / 2;
//var _y = display_get_gui_height() - 20;

//for (var _i = 0; _i < _route_len; _i++) {
//    var _rx = _start_x + _i * (_icon_w + _gap);
//    var _room = route[_i];
//    var _current = (_i == route_index - 1);
    
// цвет иконки
//    var _col;
//    if (_current) {
//        _col = c_lime; // текущая — зелёная
//    } else if (_i < route_index - 1) {
//        _col = c_dkgray; // пройденные — тёмные
//    } else {
//        _col = c_white; // предстоящие — белые
//    }
    
// форма иконки зависит от типа комнаты
//    draw_set_color(c_black);
//    draw_rectangle(_rx - 1, _y - 1, _rx + _icon_w + 1, _y + _icon_h + 1, false);
//    draw_set_color(_col);
//    draw_set_alpha(1);
    
//    if (_room == room_boss) {
// босс, череп (крест)
//        draw_rectangle(_rx + 3, _y, _rx + 7, _y + _icon_h, false);
//        draw_rectangle(_rx, _y + 3, _rx + _icon_w, _y + 7, false);
//    } else if (_room == room_store) {
// магазин, знак $
//        draw_set_color(_current ? c_lime : ((_i < route_index - 1) ? c_dkgray : c_yellow));
//        draw_rectangle(_rx, _y, _rx + _icon_w, _y + _icon_h, false);
//        draw_set_color(c_black);
//        draw_text(_rx + 2, _y + 1, "$");
//    } else if (_room == room_chest) {
// сундук, прямоугольник с крышкой
//        draw_rectangle(_rx, _y + 4, _rx + _icon_w, _y + _icon_h, false);
//        draw_rectangle(_rx, _y, _rx + _icon_w, _y + 4, true);
//    } else if (_room == room_chill) {
// чилл, кружок
//        draw_circle(_rx + _icon_w / 2, _y + _icon_h / 2, _icon_w / 2, false);
//    } else {
// обычная комната, квадрат
//        draw_rectangle(_rx, _y, _rx + _icon_w, _y + _icon_h, false);
//    }
    
// стрелка между комнатами
//    if (_i < _route_len - 1) {
//        draw_set_color(c_dkgray);
//        var _ax = _rx + _icon_w + 1;
//        var _ay = _y + _icon_h / 2;
//        draw_line(_ax, _ay, _ax + _gap - 1, _ay);
//    }
//}

//draw_set_alpha(1);
//draw_set_color(c_white);
//draw_set_font(-1);