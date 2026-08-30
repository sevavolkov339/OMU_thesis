methods = [
    { obj: EnemyFly_Test_1_O, name: "dijkstra" },
    { obj: EnemyFly_Test_2_O, name: "astar" },
    { obj: EnemyFly_Test_3_O, name: "jps" },
    { obj: EnemyFly_Test_4_O, name: "flowfield" },
    { obj: EnemyFly_Test_5_O, name: "navmesh" }
];

enemy_counts = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
trials_per_config = 30;

settle_frames = 15;
measure_frames = 60;

method_index = 0;
count_index = 0;
trial_index = 0;
state = "spawn";
state_timer = 0;
done = false;

spawned = [];
path_time_sum = 0;
path_time_count = 0;

total_configs = array_length(methods) * array_length(enemy_counts);

results_path = working_directory + "pathfinding_benchmark.csv";
var _f = file_text_open_write(results_path);
file_text_write_string(_f, "method,enemy_count,trial,mean_us,samples\n");
file_text_close(_f);
show_debug_message("benchmark results file (reset): " + results_path);

function report_path_time(_us) {
    path_time_sum += _us;
    path_time_count++;
}

function random_open_cell() {
    var _grid = SetupPathwayO.coarse_grid;
    var _gw = SetupPathwayO.grid_w;
    var _gh = SetupPathwayO.grid_h;
    var _cs = SetupPathwayO.cell_size;

    var _cam = view_camera[0];
    var _vx = camera_get_view_x(_cam);
    var _vy = camera_get_view_y(_cam);
    var _vw = camera_get_view_width(_cam);
    var _vh = camera_get_view_height(_cam);

    var _gx_min = clamp(floor(_vx / _cs), 0, _gw - 1);
    var _gx_max = clamp(ceil((_vx + _vw) / _cs) - 1, 0, _gw - 1);
    var _gy_min = clamp(floor(_vy / _cs), 0, _gh - 1);
    var _gy_max = clamp(ceil((_vy + _vh) / _cs) - 1, 0, _gh - 1);

    var _gx = 0, _gy = 0, _tries = 0;
    do {
        _gx = irandom_range(_gx_min, _gx_max);
        _gy = irandom_range(_gy_min, _gy_max);
        _tries++;
    } until (_grid[_gx][_gy] == 0 || _tries > 500);

    return [_gx * _cs + _cs / 2, _gy * _cs + _cs / 2];
}

function clear_spawned() {
    for (var i = 0; i < array_length(spawned); i++) {
        if (instance_exists(spawned[i])) instance_destroy(spawned[i]);
    }
    spawned = [];
}

function draw_outlined(_x, _y, _text) {
    draw_set_color(c_black);
    draw_text(_x - 1, _y - 1, _text);
    draw_text(_x,     _y - 1, _text);
    draw_text(_x + 1, _y - 1, _text);
    draw_text(_x - 1, _y,     _text);
    draw_text(_x + 1, _y,     _text);
    draw_text(_x - 1, _y + 1, _text);
    draw_text(_x,     _y + 1, _text);
    draw_text(_x + 1, _y + 1, _text);
    draw_set_color(c_white);
    draw_text(_x, _y, _text);
}
