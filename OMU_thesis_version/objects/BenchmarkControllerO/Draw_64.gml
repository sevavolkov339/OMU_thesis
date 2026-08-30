var _lines = [];

if (done) {
    array_push(_lines, "pathfinding benchmark - done");
    array_push(_lines, "results: " + results_path);
} else {
    var _method = methods[method_index];
    var _count = enemy_counts[count_index];
    var _progress = round((method_index * array_length(enemy_counts) + count_index) / total_configs * 100);

    array_push(_lines, "pathfinding benchmark");
    array_push(_lines, "method: " + _method.name);
    array_push(_lines, "enemies: " + string(_count));
    array_push(_lines, "trial: " + string(trial_index + 1) + " / " + string(trials_per_config));
    array_push(_lines, "state: " + state);
    array_push(_lines, "samples: " + string(path_time_count));
    array_push(_lines, "overall: " + string(_progress) + "%");
}

var _x = display_get_gui_width() - 16;
var _y = 16;

draw_set_halign(fa_right);
for (var i = 0; i < array_length(_lines); i++) {
    draw_outlined(_x, _y, _lines[i]);
    _y += 20;
}
draw_set_halign(fa_left);
