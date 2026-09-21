// pause
if (GameControllerO.game_paused) exit;

// rebuild every 10 frames, same cadence the others re-search on
flow_field_timer++;

// поле строим, только пока оно кому-то нужно
var _goal = noone;
var _live = false;
if (instance_exists(PlayerTestO)) {
    _goal = PlayerTestO;
} else if (instance_exists(PipelineValidationO) && PipelineValidationO.cfg_pathfinder == "flow"
        && instance_exists(PlayerBallerO) && instance_exists(EnemyFlyO)) {
    _goal = PlayerBallerO;
    _live = true;
}

if (flow_field_timer < 10 || _goal == noone) exit;
flow_field_timer = 0;

var _bench_t0 = get_timer();

var _goal_gx = clamp(floor(_goal.x / cell_size), 0, grid_w - 1);
var _goal_gy = clamp(floor(_goal.y / cell_size), 0, grid_h - 1);

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
if (_live) {
    PipelineValidationO.add_path_time(get_timer() - _bench_t0);
}

// диагностика: то же поле, но обходим только залитые клетки
if (_live && PipelineValidationO.cfg_diag) {
    if (!variable_instance_exists(id, "diag_cost")) {
        diag_cost = array_create(grid_w);
        diag_dir = array_create(grid_w);
        for (var gx = 0; gx < grid_w; gx++) {
            diag_cost[gx] = array_create(grid_h, -1);
            diag_dir[gx] = array_create(grid_h, -1);
        }
        diag_visited = array_create(grid_w * grid_h, 0);
        diag_n = 0;
    }

    var _d0 = get_timer();

    // сброс только прошлых залитых клеток
    for (var i = 0; i < diag_n; i++) {
        var _k = diag_visited[i];
        diag_cost[_k mod grid_w][_k div grid_w] = -1;
        diag_dir[_k mod grid_w][_k div grid_w] = -1;
    }
    diag_n = 0;

    // та же заливка от игрока, с запоминанием залитых клеток
    var _dq = ds_queue_create();
    diag_cost[_goal_gx][_goal_gy] = 0;
    ds_queue_enqueue(_dq, _goal_gx + _goal_gy * grid_w);
    diag_visited[diag_n] = _goal_gx + _goal_gy * grid_w;
    diag_n++;
    while (!ds_queue_empty(_dq)) {
        var _p = ds_queue_dequeue(_dq);
        var _px = _p mod grid_w;
        var _py = _p div grid_w;
        for (var d = 0; d < 4; d++) {
            var _nx = _px + _dx[d];
            var _ny = _py + _dy[d];
            if (_nx < 0 || _ny < 0 || _nx >= grid_w || _ny >= grid_h) continue;
            if (coarse_grid[_nx][_ny] == 1) continue;
            if (diag_cost[_nx][_ny] != -1) continue;
            diag_cost[_nx][_ny] = diag_cost[_px][_py] + 1;
            var _nk = _nx + _ny * grid_w;
            ds_queue_enqueue(_dq, _nk);
            diag_visited[diag_n] = _nk;
            diag_n++;
        }
    }
    ds_queue_destroy(_dq);

    // направления только для залитых клеток, тем же правилом, что и выше
    for (var i = 0; i < diag_n; i++) {
        var _k = diag_visited[i];
        var _vx = _k mod grid_w;
        var _vy = _k div grid_w;
        if (diag_cost[_vx][_vy] <= 0) continue;
        var _best_cost = diag_cost[_vx][_vy];
        var _best_dx = 0;
        var _best_dy = 0;
        var _has_best = false;
        for (var d = 0; d < 4; d++) {
            var _nx = _vx + _dx[d];
            var _ny = _vy + _dy[d];
            if (_nx < 0 || _ny < 0 || _nx >= grid_w || _ny >= grid_h) continue;
            if (diag_cost[_nx][_ny] == -1) continue;
            if (diag_cost[_nx][_ny] < _best_cost) {
                _best_cost = diag_cost[_nx][_ny];
                _best_dx = _dx[d];
                _best_dy = _dy[d];
                _has_best = true;
            }
        }
        if (_has_best) diag_dir[_vx][_vy] = point_direction(0, 0, _best_dx, _best_dy);
    }

    var _shadow_us = get_timer() - _d0;

    // сверка вне замера: во всех залитых клетках урезанное поле должно совпасть
    var _mismatch = 0;
    for (var i = 0; i < diag_n; i++) {
        var _k = diag_visited[i];
        if (diag_dir[_k mod grid_w][_k div grid_w] != flow_dir[_k mod grid_w][_k div grid_w]) _mismatch++;
    }
    PipelineValidationO.add_diag(_shadow_us, diag_n, _mismatch);
}
