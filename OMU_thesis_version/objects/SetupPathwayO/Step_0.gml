//pause
if (GameControllerO.game_paused) exit;

// rebuild every 10 frames, same cadence the others re-search on
flow_field_timer++;
if (flow_field_timer < 10 || !instance_exists(PlayerTestO)) exit;
flow_field_timer = 0;

var _bench_t0 = get_timer();

var _goal_gx = clamp(floor(PlayerTestO.x / cell_size), 0, grid_w - 1);
var _goal_gy = clamp(floor(PlayerTestO.y / cell_size), 0, grid_h - 1);

var _cost = array_create(grid_w);
for (var gx = 0; gx < grid_w; gx++) {
    _cost[gx] = array_create(grid_h, -1);
    for (var gy = 0; gy < grid_h; gy++) flow_dir[gx][gy] = -1;
}

var _dx = [1, -1, 0, 0];
var _dy = [0, 0, 1, -1];

// flood fill from the goal, same idea as dijkstra but run once for everyone
var _queue = ds_queue_create();
_cost[_goal_gx][_goal_gy] = 0;
ds_queue_enqueue(_queue, _goal_gx + _goal_gy * grid_w);

while (!ds_queue_empty(_queue)) {
    var _packed = ds_queue_dequeue(_queue);
    var _cx = _packed mod grid_w;
    var _cy = _packed div grid_w;

    for (var d = 0; d < 4; d++) {
        var _nx = _cx + _dx[d];
        var _ny = _cy + _dy[d];
        if (_nx < 0 || _ny < 0 || _nx >= grid_w || _ny >= grid_h) continue;
        if (coarse_grid[_nx][_ny] == 1) continue;
        if (_cost[_nx][_ny] != -1) continue;

        _cost[_nx][_ny] = _cost[_cx][_cy] + 1;
        ds_queue_enqueue(_queue, _nx + _ny * grid_w);
    }
}
ds_queue_destroy(_queue);

// every reached cell points at whichever neighbour is one step closer to the goal
for (var gx = 0; gx < grid_w; gx++) {
    for (var gy = 0; gy < grid_h; gy++) {
        if (_cost[gx][gy] <= 0) continue; // unreached, or the goal cell itself

        var _best_cost = _cost[gx][gy];
        var _best_dx = 0;
        var _best_dy = 0;
        var _has_best = false;

        for (var d = 0; d < 4; d++) {
            var _nx = gx + _dx[d];
            var _ny = gy + _dy[d];
            if (_nx < 0 || _ny < 0 || _nx >= grid_w || _ny >= grid_h) continue;
            if (_cost[_nx][_ny] == -1) continue;
            if (_cost[_nx][_ny] < _best_cost) {
                _best_cost = _cost[_nx][_ny];
                _best_dx = _dx[d];
                _best_dy = _dy[d];
                _has_best = true;
            }
        }

        if (_has_best) flow_dir[gx][gy] = point_direction(0, 0, _best_dx, _best_dy);
    }
}

if (instance_exists(BenchmarkControllerO)) {
    BenchmarkControllerO.report_path_time(get_timer() - _bench_t0);
}
