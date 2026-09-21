function draw_outlined(_x, _y, _text) {
    draw_set_color(c_black);
    draw_text(_x - 1, _y, _text);
    draw_text(_x + 1, _y, _text);
    draw_text(_x, _y - 1, _text);
    draw_text(_x, _y + 1, _text);
    draw_set_color(c_white);
    draw_text(_x, _y, _text);
}

var _hx = 470;
var _hy = 8;

draw_outlined(_hx, _hy, "save/load benchmark");
if (done) {
    draw_outlined(_hx, _hy + 16, "done - " + results_path);
} else {
    var _done_configs = trial_index * array_length(methods) + method_index;
    var _pct = round(100 * _done_configs / total_configs);
    var _m = (method_index < array_length(methods)) ? methods[method_index] : methods[0];
    draw_outlined(_hx, _hy + 16, "trial " + string(trial_index + 1) + "/" + string(trials_per_config)
        + "  method " + _m.format + "/" + _m.strategy + "  (" + string(_pct) + "%)");
}
