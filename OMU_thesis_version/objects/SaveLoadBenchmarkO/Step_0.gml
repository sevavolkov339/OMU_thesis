if (done) exit;

if (state == "next_trial") {
    if (trial_index >= trials_per_config) {
        done = true;
        show_debug_message("save/load benchmark done: " + results_path);
        exit;
    }
    // одна и та же последовательность для всех шести связок этого трайла - честность
    trial_sequence = build_trial_sequence();
    method_index = 0;
    state = "run_method";
    exit;
}

if (state == "run_method") {
    if (method_index >= array_length(methods)) {
        trial_index++;
        state = "next_trial";
        exit;
    }
    var _m = methods[method_index];
    if (_m.strategy == "full") {
        run_full(_m, trial_sequence, trial_index);
    } else {
        run_delta(_m, trial_sequence, trial_index);
    }
    method_index++;
    exit;
}
