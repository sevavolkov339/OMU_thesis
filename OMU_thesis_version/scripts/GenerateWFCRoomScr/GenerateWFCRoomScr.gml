// tile ids: 0 = floor, 1 = wall edge, 2 = wall interior

function WfcCompatibleMask(_tile) {
    if (_tile == 0) return 3; // 011 - floor -> neighbour must be floor or edge
    if (_tile == 1) return 7; // 111 - wall edge -> anything goes
    return 6; // 110 - interior -> neighbour must be edge or interior
}

function WfcEntropy(_mask) {
    var _n = 0;
    if (_mask & 1) _n++;
    if (_mask & 2) _n++;
    if (_mask & 4) _n++;
    return _n;
}

function WfcWeightedPick(_mask, _w_floor, _w_edge, _w_interior) {
    var _wf = (_mask & 1) ? _w_floor : 0;
    var _we = (_mask & 2) ? _w_edge : 0;
    var _wi = (_mask & 4) ? _w_interior : 0;
    var _total = _wf + _we + _wi;
    if (_total <= 0) return 0;
    var _r = random(_total);
    if (_r < _wf) return 0;
    if (_r < _wf + _we) return 1;
    return 2;
}

function GenerateWFCRoomScr(_gw, _gh, _wall_target, _enemy_target, _chest_target, _item_target, _item_objects, _min_spacing) {
    var _shape_index = irandom(2);
    var _shape = LevelGenShape(_shape_index, _gw, _gh);

    var _total_in_shape = 0;
    for (var gx = 0; gx < _gw; gx++) {
        for (var gy = 0; gy < _gh; gy++) {
            if (_shape[gx][gy] == 1) _total_in_shape++;
        }
    }

    var _density = (_total_in_shape > 0) ? clamp(_wall_target / _total_in_shape, 0, 0.9) : 0;
    var _w_floor = 1 - _density;
    var _w_edge = _density * 0.6;
    var _w_interior = _density * 0.4;

    var _possible = array_create(_gw);
    var _resolved = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) {
        _possible[gx] = array_create(_gh, 7); // all three tiles still possible
        _resolved[gx] = array_create(_gh, -1);
    }

    var _dx = [1, -1, 0, 0];
    var _dy = [0, 0, 1, -1];

    var _remaining = _total_in_shape;
    var _guard = 0;
    while (_remaining > 0 && _guard < 5000) {
        _guard++;

        var _best_gx = -1, _best_gy = -1, _best_entropy = 4;
        for (var gx = 0; gx < _gw; gx++) {
            for (var gy = 0; gy < _gh; gy++) {
                if (_shape[gx][gy] != 1 || _resolved[gx][gy] != -1) continue;
                var _e = WfcEntropy(_possible[gx][gy]);
                if (_e < _best_entropy) {
                    _best_entropy = _e;
                    _best_gx = gx;
                    _best_gy = gy;
                }
            }
        }
        if (_best_gx == -1) break;

        var _tile = WfcWeightedPick(_possible[_best_gx][_best_gy], _w_floor, _w_edge, _w_interior);
        _resolved[_best_gx][_best_gy] = _tile;
        _remaining--;

        var _queue = [[_best_gx, _best_gy]];
        while (array_length(_queue) > 0) {
            var _cell = _queue[0];
            array_delete(_queue, 0, 1);
            var _cx = _cell[0], _cy = _cell[1];
            var _allowed = WfcCompatibleMask(_resolved[_cx][_cy]);

            for (var d = 0; d < 4; d++) {
                var _nx = _cx + _dx[d];
                var _ny = _cy + _dy[d];
                if (_nx < 0 || _ny < 0 || _nx >= _gw || _ny >= _gh) continue;
                if (_shape[_nx][_ny] != 1 || _resolved[_nx][_ny] != -1) continue;

                var _before = _possible[_nx][_ny];
                var _after = _before & _allowed;
                if (_after == _before) continue;

                _possible[_nx][_ny] = _after;
                if (WfcEntropy(_after) == 1) {
                    var _forced = (_after & 1) ? 0 : ((_after & 2) ? 1 : 2);
                    _resolved[_nx][_ny] = _forced;
                    _remaining--;
                    array_push(_queue, [_nx, _ny]);
                } else if (_after == 0) {
                    // shouldn't happen, but fall back to floor instead of hanging
                    _resolved[_nx][_ny] = 0;
                    _remaining--;
                    array_push(_queue, [_nx, _ny]);
                }
            }
        }
    }

    var _wall_grid = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) _wall_grid[gx] = array_create(_gh, false);

    var _walls = [];
    for (var gx = 0; gx < _gw; gx++) {
        for (var gy = 0; gy < _gh; gy++) {
            if (_shape[gx][gy] != 1) continue;
            var _t = _resolved[gx][gy];
            if (_t == 1) {
                _wall_grid[gx][gy] = true;
                array_push(_walls, { gx: gx, gy: gy, obj: WallForEnemiesO });
            } else if (_t == 2) {
                _wall_grid[gx][gy] = true;
                array_push(_walls, { gx: gx, gy: gy, obj: WallInteriorO });
            }
        }
    }

    var _floor = [];
    for (var gx = 0; gx < _gw; gx++) {
        for (var gy = 0; gy < _gh; gy++) {
            if (_shape[gx][gy] == 1 && !_wall_grid[gx][gy]) {
                array_push(_floor, { gx: gx, gy: gy });
            }
        }
    }

    var _reachable = LevelGenLargestComponent(_shape, _gw, _gh, _wall_grid);

    var _player_pt = LevelGenScatter(_reachable, _gw, _gh, _wall_grid, 1, 0);
    var _enemy_pts = LevelGenScatter(_reachable, _gw, _gh, _wall_grid, _enemy_target, _min_spacing);
    var _chest_pts = LevelGenScatter(_reachable, _gw, _gh, _wall_grid, _chest_target, _min_spacing);
    var _item_pts = LevelGenScatter(_reachable, _gw, _gh, _wall_grid, irandom(_item_target), _min_spacing);

    var _enemies = [];
    for (var i = 0; i < array_length(_enemy_pts); i++) array_push(_enemies, { gx: _enemy_pts[i][0], gy: _enemy_pts[i][1] });

    var _chest = [];
    for (var i = 0; i < array_length(_chest_pts); i++) array_push(_chest, { gx: _chest_pts[i][0], gy: _chest_pts[i][1] });

    var _items = [];
    for (var i = 0; i < array_length(_item_pts); i++) {
        var _obj = _item_objects[irandom(array_length(_item_objects) - 1)];
        array_push(_items, { gx: _item_pts[i][0], gy: _item_pts[i][1], obj: _obj });
    }

    var _player = (array_length(_player_pt) > 0) ? { gx: _player_pt[0][0], gy: _player_pt[0][1] } : { gx: 0, gy: 0 };

    return {
        walls: _walls,
        floor: _floor,
        enemies: _enemies,
        chest: _chest,
        items: _items,
        player: _player,
        shape: _shape_index
    };
}
