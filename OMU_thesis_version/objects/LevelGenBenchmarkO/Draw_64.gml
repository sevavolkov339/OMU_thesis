var _lines = [];

if (done) {
    array_push(_lines, "levelgen benchmark - done");
    array_push(_lines, "results: " + results_path);
} else {
    var _method = methods[method_index];
    var _wall_target = wall_targets[density_index];
    var _progress = round((method_index * array_length(wall_targets) + density_index) / total_configs * 100);

    array_push(_lines, "levelgen benchmark");
    array_push(_lines, "method: " + _method.name);
    array_push(_lines, "wall target: " + string(_wall_target));
    array_push(_lines, "trial: " + string(trial_index + 1) + " / " + string(trials_per_config));
    array_push(_lines, "state: " + state);
    if (!is_undefined(last_result)) {
        var _shape_names = ["rectangle", "L-shape", "cross"];
        array_push(_lines, "shape: " + _shape_names[last_result.shape]);
        array_push(_lines, "walls placed: " + string(array_length(last_result.walls)) + " / " + string(_wall_target));
        array_push(_lines, "enemies/chest/items: " + string(array_length(last_result.enemies)) + "/" + string(array_length(last_result.chest)) + "/" + string(array_length(last_result.items)));
        array_push(_lines, "last gen time: " + string(last_gen_time_us) + " us");
    }
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
