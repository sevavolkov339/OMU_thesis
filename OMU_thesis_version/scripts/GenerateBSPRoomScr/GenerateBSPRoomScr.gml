// keeps splitting the biggest region until the partition lines add up
function GenerateBSPRoomScr(_gw, _gh, _wall_target, _enemy_target, _chest_target, _item_target, _item_objects, _min_spacing) {
    var _shape_index = irandom(2);
    var _shape = LevelGenShape(_shape_index, _gw, _gh);

    var _wall_grid = array_create(_gw);
    for (var gx = 0; gx < _gw; gx++) _wall_grid[gx] = array_create(_gh, false);

    var _min_region = 3;
    var _regions = [[0, 0, _gw, _gh]]; // [x0, y0, x1, y1) per region
    var _wall_count = 0;
    var _pass = 0;

    while (_wall_count < _wall_target && _pass < 200) {
        _pass++;
        if (array_length(_regions) == 0) break;

        // split the largest region first, so walls end up roughly even
        var _best_i = 0;
        var _best_area = -1;
        for (var i = 0; i < array_length(_regions); i++) {
            var _r = _regions[i];
            var _area = (_r[2] - _r[0]) * (_r[3] - _r[1]);
            if (_area > _best_area) { _best_area = _area; _best_i = i; }
        }

        var _r = _regions[_best_i];
        var _rx0 = _r[0], _ry0 = _r[1], _rx1 = _r[2], _ry1 = _r[3];
        var _rw = _rx1 - _rx0;
        var _rh = _ry1 - _ry0;

        var _can_h = (_rw >= _min_region * 2);
        var _can_v = (_rh >= _min_region * 2);
        if (!_can_h && !_can_v) {
            array_delete(_regions, _best_i, 1);
            continue;
        }

        var _split_h = _can_h && (_can_v ? (_rw >= _rh) : true);
        array_delete(_regions, _best_i, 1);

        if (_split_h) {
            var _cut = irandom_range(_rx0 + _min_region, _rx1 - _min_region);
            var _door_y = irandom_range(_ry0, _ry1 - 1); // one gap so the split stays connected
            for (var gy = _ry0; gy < _ry1; gy++) {
                if (gy == _door_y) continue;
                if (_shape[_cut][gy] == 1 && !_wall_grid[_cut][gy]) {
                    _wall_grid[_cut][gy] = true;
                    _wall_count++;
                }
            }
            array_push(_regions, [_rx0, _ry0, _cut, _ry1]);
            array_push(_regions, [_cut + 1, _ry0, _rx1, _ry1]);
        } else {
            var _cut = irandom_range(_ry0 + _min_region, _ry1 - _min_region);
            var _door_x = irandom_range(_rx0, _rx1 - 1);
            for (var gx = _rx0; gx < _rx1; gx++) {
                if (gx == _door_x) continue;
                if (_shape[gx][_cut] == 1 && !_wall_grid[gx][_cut]) {
                    _wall_grid[gx][_cut] = true;
                    _wall_count++;
                }
            }
            array_push(_regions, [_rx0, _ry0, _rx1, _cut]);
            array_push(_regions, [_rx0, _cut + 1, _rx1, _ry1]);
        }
    }

    var _walls = [];
    for (var gx = 0; gx < _gw; gx++) {
        for (var gy = 0; gy < _gh; gy++) {
            if (_wall_grid[gx][gy]) array_push(_walls, { gx: gx, gy: gy, obj: WallForEnemiesO });
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
