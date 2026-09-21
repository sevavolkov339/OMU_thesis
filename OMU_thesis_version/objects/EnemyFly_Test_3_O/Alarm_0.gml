// pause
if (GameControllerO.game_paused) {
    alarm_set(0, 1);
    exit;
}

if (puff_stunned) {
    alarm_set(0, 1);
    exit;
}

// jump point search - jumps in a straight/diagonal line until it either hits
function jps_blocked(_grid, _gw, _gh, _gx, _gy) {
    if (_gx < 0 || _gy < 0 || _gx >= _gw || _gy >= _gh) return true;
    return (_grid[_gx][_gy] == 1);
}

function jps_jump(_grid, _gw, _gh, _cx, _cy, _dx, _dy, _ex, _ey) {
    var _nx = _cx + _dx;
    var _ny = _cy + _dy;
    if (jps_blocked(_grid, _gw, _gh, _nx, _ny)) return -1;
    if (_nx == _ex && _ny == _ey) return _nx + _ny * _gw;

    if (_dx != 0 && _dy != 0) {
        // diagonal step - forced neighbour on either flank means stop here
        if ((!jps_blocked(_grid, _gw, _gh, _nx - _dx, _ny + _dy) && jps_blocked(_grid, _gw, _gh, _nx - _dx, _ny)) ||
            (!jps_blocked(_grid, _gw, _gh, _nx + _dx, _ny - _dy) && jps_blocked(_grid, _gw, _gh, _nx, _ny - _dy))) {
            return _nx + _ny * _gw;
        }
        // a diagonal jump also counts as a jump point if either straight
        if (jps_jump(_grid, _gw, _gh, _nx, _ny, _dx, 0, _ex, _ey) != -1) return _nx + _ny * _gw;
        if (jps_jump(_grid, _gw, _gh, _nx, _ny, 0, _dy, _ex, _ey) != -1) return _nx + _ny * _gw;
    } else if (_dx != 0) {
        if ((!jps_blocked(_grid, _gw, _gh, _nx, _ny + 1) && jps_blocked(_grid, _gw, _gh, _nx - _dx, _ny + 1)) ||
            (!jps_blocked(_grid, _gw, _gh, _nx, _ny - 1) && jps_blocked(_grid, _gw, _gh, _nx - _dx, _ny - 1))) {
            return _nx + _ny * _gw;
        }
    } else {
        if ((!jps_blocked(_grid, _gw, _gh, _nx + 1, _ny) && jps_blocked(_grid, _gw, _gh, _nx + 1, _ny - _dy)) ||
            (!jps_blocked(_grid, _gw, _gh, _nx - 1, _ny) && jps_blocked(_grid, _gw, _gh, _nx - 1, _ny - _dy))) {
            return _nx + _ny * _gw;
        }
    }

    return jps_jump(_grid, _gw, _gh, _nx, _ny, _dx, _dy, _ex, _ey);
}

// directions actually worth a jump from here, based on where we came from
function jps_prune_directions(_grid, _gw, _gh, _cx, _cy, _pdx, _pdy) {
    var _dirs = [];

    if (_pdx == 0 && _pdy == 0) {
        return [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]];
    }

    if (_pdx != 0 && _pdy != 0) {
        if (!jps_blocked(_grid, _gw, _gh, _cx, _cy + _pdy)) array_push(_dirs, [0, _pdy]);
        if (!jps_blocked(_grid, _gw, _gh, _cx + _pdx, _cy)) array_push(_dirs, [_pdx, 0]);
        if (!jps_blocked(_grid, _gw, _gh, _cx + _pdx, _cy + _pdy)) array_push(_dirs, [_pdx, _pdy]);
        if (jps_blocked(_grid, _gw, _gh, _cx - _pdx, _cy) && !jps_blocked(_grid, _gw, _gh, _cx - _pdx, _cy + _pdy)) array_push(_dirs, [-_pdx, _pdy]);
        if (jps_blocked(_grid, _gw, _gh, _cx, _cy - _pdy) && !jps_blocked(_grid, _gw, _gh, _cx + _pdx, _cy - _pdy)) array_push(_dirs, [_pdx, -_pdy]);
    } else if (_pdx != 0) {
        if (!jps_blocked(_grid, _gw, _gh, _cx + _pdx, _cy)) array_push(_dirs, [_pdx, 0]);
        if (jps_blocked(_grid, _gw, _gh, _cx, _cy + 1) && !jps_blocked(_grid, _gw, _gh, _cx + _pdx, _cy + 1)) array_push(_dirs, [_pdx, 1]);
        if (jps_blocked(_grid, _gw, _gh, _cx, _cy - 1) && !jps_blocked(_grid, _gw, _gh, _cx + _pdx, _cy - 1)) array_push(_dirs, [_pdx, -1]);
    } else {
        if (!jps_blocked(_grid, _gw, _gh, _cx, _cy + _pdy)) array_push(_dirs, [0, _pdy]);
        if (jps_blocked(_grid, _gw, _gh, _cx + 1, _cy) && !jps_blocked(_grid, _gw, _gh, _cx + 1, _cy + _pdy)) array_push(_dirs, [1, _pdy]);
        if (jps_blocked(_grid, _gw, _gh, _cx - 1, _cy) && !jps_blocked(_grid, _gw, _gh, _cx - 1, _cy + _pdy)) array_push(_dirs, [-1, _pdy]);
    }

    return _dirs;
}

if instance_exists(PlayerTestO) {

    var _bench_t0 = get_timer();

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

    var _gscore = ds_map_create();
    var _from = ds_map_create();
    var _closed = ds_map_create();
    var _dir_x = ds_map_create();
    var _dir_y = ds_map_create();
    var _open = ds_priority_create();
    ds_map_add(_gscore, _start_key, 0);
    ds_map_add(_dir_x, _start_key, 0);
    ds_map_add(_dir_y, _start_key, 0);
    ds_priority_add(_open, _start_key, point_distance(_sx, _sy, _ex, _ey));

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
        var _base_g = _gscore[? _key];
        var _pdx = _dir_x[? _key];
        var _pdy = _dir_y[? _key];

        var _dirs = jps_prune_directions(_grid, _gw, _gh, _cx, _cy, _pdx, _pdy);

        for (var d = 0; d < array_length(_dirs); d++) {
            var _ddx = _dirs[d][0];
            var _ddy = _dirs[d][1];
            var _jump_key = jps_jump(_grid, _gw, _gh, _cx, _cy, _ddx, _ddy, _ex, _ey);
            if (_jump_key == -1) continue;

            var _jx = _jump_key mod _gw;
            var _jy = _jump_key div _gw;
            var _ng = _base_g + point_distance(_cx, _cy, _jx, _jy);

            if (!ds_map_exists(_gscore, _jump_key) || _ng < _gscore[? _jump_key]) {
                ds_map_set(_gscore, _jump_key, _ng);
                ds_map_set(_from, _jump_key, _key);
                ds_map_set(_dir_x, _jump_key, _ddx);
                ds_map_set(_dir_y, _jump_key, _ddy);
                ds_priority_add(_open, _jump_key, _ng + point_distance(_jx, _jy, _ex, _ey));
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

    ds_map_destroy(_gscore);
    ds_map_destroy(_from);
    ds_map_destroy(_closed);
    ds_map_destroy(_dir_x);
    ds_map_destroy(_dir_y);
    ds_priority_destroy(_open);

    path_start(path, 0.5 * path_spd_scale, path_action_stop, true);

    BenchmarkControllerO.report_path_time(get_timer() - _bench_t0);

    alarm_set(0, 10);
}
