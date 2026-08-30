if (done) exit;

switch (state) {
    case "spawn":
        var _method = methods[method_index];
        var _count = enemy_counts[count_index];

        clear_spawned();
        path_time_sum = 0;
        path_time_count = 0;

        for (var i = 0; i < _count; i++) {
            var _pos = random_open_cell();
            array_push(spawned, instance_create_depth(_pos[0], _pos[1], 0, _method.obj));
        }

        state_timer = 0;
        state = "settle";
    break;

    case "settle":
        state_timer++;
        if (state_timer >= settle_frames) {
            state_timer = 0;
            state = "measure";
        }
    break;

    case "measure":
        state_timer++;
        if (state_timer >= measure_frames) state = "record";
    break;

    case "record":
        var _method = methods[method_index];
        var _count = enemy_counts[count_index];
        var _mean = (path_time_count > 0) ? (path_time_sum / path_time_count) : 0;

        var _f = file_text_open_append(results_path);
        file_text_write_string(_f, _method.name + "," + string(_count) + "," + string(trial_index) + "," + string(_mean) + "," + string(path_time_count) + "\n");
        file_text_close(_f);

        clear_spawned();

        trial_index++;
        if (trial_index >= trials_per_config) {
            trial_index = 0;
            count_index++;
            if (count_index >= array_length(enemy_counts)) {
                count_index = 0;
                method_index++;
                if (method_index >= array_length(methods)) {
                    done = true;
                    state = "done";
                    break;
                }
            }
        }

        state = "spawn";
    break;
}
