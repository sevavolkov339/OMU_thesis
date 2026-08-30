if (done) exit;

switch (state) {
    case "generate":
        var _method = methods[method_index];
        var _wall_target = wall_targets[density_index];

        var _t0 = get_timer();
        var _spec = _method.fn(grid_w, grid_h, _wall_target, enemy_target, chest_target, item_target, item_objects, min_spacing);
        last_gen_time_us = get_timer() - _t0;
        last_result = _spec;

        clear_spawned();
        materialize(_spec);

        state_timer = 0;
        state = "hold";
    break;

    case "hold":
        state_timer++;
        if (state_timer >= hold_frames) state = "record";
    break;

    case "record":
        var _method = methods[method_index];
        var _wall_target = wall_targets[density_index];

        var _f = file_text_open_append(results_path);
        file_text_write_string(_f,
            _method.name + "," + string(_wall_target) + "," + string(trial_index) + "," +
            string(last_gen_time_us) + "," + string(array_length(last_result.walls)) + "," +
            string(array_length(last_result.enemies)) + "," + string(array_length(last_result.chest)) + "," +
            string(array_length(last_result.items)) + "\n"
        );
        file_text_close(_f);

        clear_spawned();

        trial_index++;
        if (trial_index >= trials_per_config) {
            trial_index = 0;
            density_index++;
            if (density_index >= array_length(wall_targets)) {
                density_index = 0;
                method_index++;
                if (method_index >= array_length(methods)) {
                    done = true;
                    state = "done";
                    break;
                }
            }
        }

        state = "generate";
    break;
}
