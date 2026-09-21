// pause
if (GameControllerO.game_paused) {
    alarm_set(0, 1);
    exit;
}

if (puff_stunned) {
    alarm_set(0, 1);
    exit;
}

if instance_exists(PlayerTestO) {

    var _bench_t0 = get_timer();

    // dijkstra - expand outward from this enemy, cheapest reached cell first
    var _grid = SetupPathwayO.coarse_grid;
    var _gw = SetupPathwayO.grid_w;
    var _gh = SetupPathwayO.grid_h;
    var _cs = SetupPathwayO.cell_size;

    var _sx = clamp(floor(x / _cs), 0, _gw - 1);
    var _sy = clamp(floor(y / _cs), 0, _gh - 1);
    var _ex = clamp(floor(PlayerTestO.x / _cs), 0, _gw - 1);
    var _ey = clamp(floor(PlayerTestO.y / _cs), 0, _gh - 1);

    target_x = PlayerTestO.x;
    target_y = PlayerTestO.y;

    var _start_key = _sx + _sy * _gw;
    var _goal_key = _ex + _ey * _gw;

    var _cost = ds_map_create();
    var _from = ds_map_create();
    var _closed = ds_map_create();
    var _open = ds_priority_create();
    ds_map_add(_cost, _start_key, 0);
    ds_priority_add(_open, _start_key, 0);

    var _dx = [1, -1, 0, 0, 1, 1, -1, -1];
    var _dy = [0, 0, 1, -1, 1, -1, 1, -1];
    var _dcost = [1, 1, 1, 1, 1.4142, 1.4142, 1.4142, 1.4142];

    var _found = false;
    while (!ds_priority_empty(_open)) {
        var _key = ds_priority_delete_min(_open);
        if (ds_map_exists(_closed, _key)) continue;
        ds_map_set(_closed, _key, true);

        if (_key == _goal_key) {
            _found = true;
            break;
        }

        var _cx = _key mod _gw;
        var _cy = _key div _gw;
        var _base_cost = _cost[? _key];

        for (var d = 0; d < 8; d++) {
            var _nx = _cx + _dx[d];
            var _ny = _cy + _dy[d];
            if (_nx < 0 || _ny < 0 || _nx >= _gw || _ny >= _gh) continue;
            if (_grid[_nx][_ny] == 1) continue;

            var _nkey = _nx + _ny * _gw;
            var _ncost = _base_cost + _dcost[d];
            if (!ds_map_exists(_cost, _nkey) || _ncost < _cost[? _nkey]) {
                ds_map_set(_cost, _nkey, _ncost);
                ds_map_set(_from, _nkey, _key);
                ds_priority_add(_open, _nkey, _ncost);
            }
        }
    }

    path_delete(path);
    path = path_add();
    path_add_point(path, x, y, 100);

    if (_found) {
        var _chain = [];
        var _walk = _goal_key;
        while (_walk != _start_key) {
            array_push(_chain, _walk);
            _walk = _from[? _walk];
        }
        for (var i = array_length(_chain) - 1; i >= 0; i--) {
            var _k = _chain[i];
            var _px = (_k mod _gw) * _cs + _cs / 2;
            var _py = (_k div _gw) * _cs + _cs / 2;
            path_add_point(path, _px, _py, 100);
        }
        path_add_point(path, target_x, target_y, 100);
    }

    ds_map_destroy(_cost);
    ds_map_destroy(_from);
    ds_map_destroy(_closed);
    ds_priority_destroy(_open);

    path_start(path, 0.5 * path_spd_scale, path_action_stop, true);

    BenchmarkControllerO.report_path_time(get_timer() - _bench_t0);

    alarm_set(0, 10);
}
