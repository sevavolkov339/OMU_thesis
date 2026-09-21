// все враги зачищены - открываем дверь на выход
if (!level_completed && instance_number(EnemyO) == 0 && instance_number(EnemyFlyO) == 0) {
    level_completed = true;

    var _blockers = [WallForEnemiesO, WallInteriorO, BoxChestO, PlayerBallerO];
    var _door_x = 0, _door_y = 0, _tries = 0, _found = false;
    do {
        var _gx = irandom(grid_w - 1);
        var _gy = irandom(grid_h - 1);
        _door_x = origin_x + _gx * cell_size + cell_size / 2;
        _door_y = origin_y + _gy * cell_size + cell_size / 2;
        _tries++;
        // reachable_mask - тот же самый связный кусок пола, который генератор использовал
        var _not_on_edge = (_gx >= 1 && _gx <= grid_w - 2 && _gy >= 1 && _gy <= grid_h - 2);
        _found = _not_on_edge && cell_clear(_door_x, _door_y, _blockers) && reachable_mask[_gx][_gy] == 1;
    } until (_found || _tries >= 200);

    instance_create_layer(_door_x, _door_y, "ExitL", DoorO);
}

// мгновенный спавн компаньона новому предмету в инвентаре
if (instance_exists(InventoryControllerO) && instance_exists(player_ref)) {
    var _inv = InventoryControllerO.items;
    var _inv_count = array_length(_inv);
    if (_inv_count > prev_inv_count) {
        for (var i = prev_inv_count; i < _inv_count; i++) {
            var _item = _inv[i];
            if (_item.type == "Heart") continue;
            if (_item.obj == noone) continue;
            var _iangle = irandom(360);
            var _idist = 20 + i * 12;
            instance_create_layer(player_ref.x + lengthdir_x(_idist, _iangle), player_ref.y + lengthdir_y(_idist, _iangle), "UIL", _item.obj);
        }
    }
    prev_inv_count = _inv_count;
}
