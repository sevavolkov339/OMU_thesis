// which cells of the gw x gh box belong to the room, shared by all three gens
function LevelGenShape(_shape_index, _gw, _gh) {
    var _mask = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) _mask[gx] = array_create(_gh, 1);

    switch (_shape_index) {
        case 1:
            // L-shape - carve out the top-right quadrant
            for (var gx = floor(_gw / 2); gx < _gw; gx++) {
                for (var gy = 0; gy < floor(_gh / 2); gy++) {
                    _mask[gx][gy] = 0;
                }
            }
        break;
        case 2:
            // plus/cross shape - carve out all four corners
            var _cx0 = floor(_gw / 3);
            var _cx1 = _gw - floor(_gw / 3);
            var _cy0 = floor(_gh / 3);
            var _cy1 = _gh - floor(_gh / 3);
            for (var gx = 0; gx < _gw; gx++) {
                for (var gy = 0; gy < _gh; gy++) {
                    var _in_h_bar = (gy >= _cy0 && gy < _cy1);
                    var _in_v_bar = (gx >= _cx0 && gx < _cx1);
                    if (!_in_h_bar && !_in_v_bar) _mask[gx][gy] = 0;
                }
            }
        break;
        // case 0 (or anything else): plain rectangle, mask stays all 1
    }
    return _mask;
}

// rejection-sampling scatter, matches algorithm 1's SCATTER
function LevelGenScatter(_shape, _gw, _gh, _occupied, _count, _min_spacing) {
    var _placed = [];
    for (var i = 0; i < _count; i++) {
        var _tries = 0;
        var _found = false;
        var _px = 0, _py = 0;
        do {
            _px = irandom(_gw - 1);
            _py = irandom(_gh - 1);
            _tries++;

            _found = false;
            if (_shape[_px][_py] == 1 && !_occupied[_px][_py]) {
                var _ok = true;
                for (var j = 0; j < array_length(_placed); j++) {
                    if (point_distance(_px, _py, _placed[j][0], _placed[j][1]) < _min_spacing) {
                        _ok = false;
                        break;
                    }
                }
                _found = _ok;
            }
        } until (_found || _tries >= 200);

        if (_found) {
            array_push(_placed, [_px, _py]);
            _occupied[_px][_py] = true;
        }
        // otherwise this slot is just skipped, same as Algorithm 1
    }
    return _placed;
}

// flood fill to the biggest connected open area, so nothing spawns in a
// sealed-off pocket
function LevelGenLargestComponent(_shape, _gw, _gh, _wall_grid) {
    var _visited = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) _visited[gx] = array_create(_gh, false);

    var _best_mask = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) _best_mask[gx] = array_create(_gh, 0);
    var _best_size = 0;

    var _dx = [1, -1, 0, 0];
    var _dy = [0, 0, 1, -1];

    for (var sx = 0; sx < _gw; sx++) {
        for (var sy = 0; sy < _gh; sy++) {
            if (_shape[sx][sy] != 1 || _wall_grid[sx][sy] || _visited[sx][sy]) continue;

            var _cells = [[sx, sy]];
            _visited[sx][sy] = true;
            var _head = 0;
            while (_head < array_length(_cells)) {
                var _c = _cells[_head];
                _head++;
                for (var d = 0; d < 4; d++) {
                    var _nx = _c[0] + _dx[d];
                    var _ny = _c[1] + _dy[d];
                    if (_nx < 0 || _ny < 0 || _nx >= _gw || _ny >= _gh) continue;
                    if (_shape[_nx][_ny] != 1 || _wall_grid[_nx][_ny] || _visited[_nx][_ny]) continue;
                    _visited[_nx][_ny] = true;
                    array_push(_cells, [_nx, _ny]);
                }
            }

            if (array_length(_cells) > _best_size) {
                _best_size = array_length(_cells);
                for (var gx = 0; gx < _gw; gx++) _best_mask[gx] = array_create(_gh, 0);
                for (var i = 0; i < array_length(_cells); i++) {
                    _best_mask[_cells[i][0]][_cells[i][1]] = 1;
                }
            }
        }
    }

    return _best_mask;
}

function GenerateProceduralRoomScr(_gw, _gh, _wall_target, _enemy_target, _chest_target, _item_target, _item_objects, _min_spacing) {
    var _shape_index = irandom(2);
    var _shape = LevelGenShape(_shape_index, _gw, _gh);

    var _wall_grid = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) _wall_grid[gx] = array_create(_gh, false);

    var _wall_pts = LevelGenScatter(_shape, _gw, _gh, _wall_grid, _wall_target, _min_spacing);
    var _walls = [];
    for (var i = 0; i < array_length(_wall_pts); i++) {
        array_push(_walls, { gx: _wall_pts[i][0], gy: _wall_pts[i][1], obj: WallForEnemiesO });
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

    // _wall_grid now doubles as the occupied grid for everything below
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
