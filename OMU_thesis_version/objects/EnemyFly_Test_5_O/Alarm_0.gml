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

    target_x = PlayerTestO.x;
    target_y = PlayerTestO.y;

    path_delete(path);
    path = path_add();
    path_add_point(path, x, y, 100);

    if (SetupPathwayO.clear_line_with_margin(x, y, target_x, target_y)) {
        // straight line to the player is already clear - no graph needed
        path_add_point(path, target_x, target_y, 100);

    } else {
        // snap onto whichever waypoint is nearest and actually visible from here
        var _wx = SetupPathwayO.waypoint_x;
        var _wy = SetupPathwayO.waypoint_y;
        var _edges = SetupPathwayO.waypoint_edges;
        var _count = array_length(_wx);

        var _start_i = -1; var _start_d = infinity;
        var _goal_i = -1; var _goal_d = infinity;
        for (var i = 0; i < _count; i++) {
            var _d1 = point_distance(x, y, _wx[i], _wy[i]);
            if (_d1 < _start_d && SetupPathwayO.clear_line_with_margin(x, y, _wx[i], _wy[i])) {
                _start_d = _d1; _start_i = i;
            }
            var _d2 = point_distance(target_x, target_y, _wx[i], _wy[i]);
            if (_d2 < _goal_d && SetupPathwayO.clear_line_with_margin(target_x, target_y, _wx[i], _wy[i])) {
                _goal_d = _d2; _goal_i = i;
            }
        }

        if (_start_i == -1 || _goal_i == -1) {
            // некуда идти - точка старта уже в пути, просто стоим
        } else {
            // small a* over the waypoint graph - a handful of nodes, not
            var _gscore = ds_map_create();
            var _from = ds_map_create();
            var _closed = ds_map_create();
            var _open = ds_priority_create();
            ds_map_add(_gscore, _start_i, 0);
            ds_priority_add(_open, _start_i, point_distance(_wx[_start_i], _wy[_start_i], _wx[_goal_i], _wy[_goal_i]));

            var _found = false;
            while (!ds_priority_empty(_open)) {
                var _cur = ds_priority_delete_min(_open);
                if (ds_map_exists(_closed, _cur)) continue;
                ds_map_set(_closed, _cur, true);
                if (_cur == _goal_i) { _found = true; break; }

                var _neighbours = _edges[_cur];
                for (var i = 0; i < array_length(_neighbours); i++) {
                    var _n = _neighbours[i];
                    var _ng = _gscore[? _cur] + point_distance(_wx[_cur], _wy[_cur], _wx[_n], _wy[_n]);
                    if (!ds_map_exists(_gscore, _n) || _ng < _gscore[? _n]) {
                        ds_map_set(_gscore, _n, _ng);
                        ds_map_set(_from, _n, _cur);
                        ds_priority_add(_open, _n, _ng + point_distance(_wx[_n], _wy[_n], _wx[_goal_i], _wy[_goal_i]));
                    }
                }
            }

            if (_found) {
                var _chain = [];
                var _walk = _goal_i;
                while (_walk != _start_i) {
                    array_push(_chain, _walk);
                    _walk = _from[? _walk];
                }
                for (var i = array_length(_chain) - 1; i >= 0; i--) {
                    path_add_point(path, _wx[_chain[i]], _wy[_chain[i]], 100);
                }
                path_add_point(path, target_x, target_y, 100);
            }

            ds_map_destroy(_gscore);
            ds_map_destroy(_from);
            ds_map_destroy(_closed);
            ds_priority_destroy(_open);
        }
    }

    path_start(path, 0.5 * path_spd_scale, path_action_stop, true);

    BenchmarkControllerO.report_path_time(get_timer() - _bench_t0);

    alarm_set(0, 10);
}
