var _tide_phase = (sin(tide_timer) + 1.0) * 0.5;

for (var _wi = 2; _wi >= 0; _wi--) {
    var _alpha = 1.0;
    var _offset_x = 0;
    
    if (_wi == 0) {
        _alpha = 1.0;
        _offset_x = 0;
    } else {
        var _appear_threshold = _wi * 0.22;
        var _appear_range = 0.45;
        
        var _t = clamp((_tide_phase - _appear_threshold) / _appear_range, 0.0, 1.0);
        _t = _t * _t * (3.0 - 2.0 * _t);
        
        _alpha = _t;
        // каждая волна заезжает на разное расстояние — вторая меньше третьей
        var _max_offset = (_wi == 1) ? 14 : 24;
        _offset_x = (1.0 - _t) * -_max_offset;
    }
    
    draw_sprite_ext(MenuWaveS, _wi,
        x + wave_offsets[_wi] + _offset_x,
        y,
        1, 1, 0,
        c_white, _alpha);
}