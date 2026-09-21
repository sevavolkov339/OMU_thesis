// INI умеет только плоские section/key/value

function SaveStateAsIni(_state, _path) {
    ini_open(_path);

    ini_write_real("player", "hp", _state.player_hp);
    ini_write_real("player", "money", _state.player_money);
    ini_write_real("player", "levels_completed", _state.levels_completed);
    ini_write_real("player", "x", _state.player_x);
    ini_write_real("player", "y", _state.player_y);

    ini_write_real("inventory", "count", array_length(_state.inventory_names));
    for (var i = 0; i < array_length(_state.inventory_names); i++) {
        ini_write_string("inventory", "item_" + string(i), _state.inventory_names[i]);
    }

    ini_write_real("floor", "count", array_length(_state.floor));
    for (var i = 0; i < array_length(_state.floor); i++) {
        var _fl = _state.floor[i];
        ini_write_real("floor", "tile_" + string(i) + "_x", _fl.x);
        ini_write_real("floor", "tile_" + string(i) + "_y", _fl.y);
    }

    ini_write_real("walls", "count", array_length(_state.walls));
    for (var i = 0; i < array_length(_state.walls); i++) {
        var _w = _state.walls[i];
        var _k = "wall_" + string(i) + "_";
        ini_write_string("walls", _k + "obj", _w.obj);
        ini_write_real("walls", _k + "x", _w.x);
        ini_write_real("walls", _k + "y", _w.y);
    }

    ini_write_real("enemies", "count", array_length(_state.enemies));
    for (var i = 0; i < array_length(_state.enemies); i++) {
        var _e = _state.enemies[i];
        var _ek = "enemy_" + string(i) + "_";
        ini_write_string("enemies", _ek + "obj", _e.obj);
        ini_write_real("enemies", _ek + "x", _e.x);
        ini_write_real("enemies", _ek + "y", _e.y);
        ini_write_real("enemies", _ek + "hp", _e.hp);
    }

    ini_write_real("chest", "exists", is_undefined(_state.chest) ? 0 : 1);
    if (!is_undefined(_state.chest)) {
        ini_write_real("chest", "x", _state.chest.x);
        ini_write_real("chest", "y", _state.chest.y);
        ini_write_real("chest", "opened", _state.chest.opened ? 1 : 0);
    }

    ini_write_real("items", "count", array_length(_state.items));
    for (var i = 0; i < array_length(_state.items); i++) {
        var _it = _state.items[i];
        var _ik = "item_" + string(i) + "_";
        ini_write_string("items", _ik + "obj", _it.obj);
        ini_write_real("items", _ik + "x", _it.x);
        ini_write_real("items", _ik + "y", _it.y);
    }

    ini_close();
}

function LoadStateFromIni(_path) {
    ini_open(_path);

    var _state = {
        player_hp: ini_read_real("player", "hp", 0),
        player_money: ini_read_real("player", "money", 0),
        levels_completed: ini_read_real("player", "levels_completed", 0),
        player_x: ini_read_real("player", "x", 0),
        player_y: ini_read_real("player", "y", 0),
        inventory_names: [],
        floor: [],
        walls: [],
        enemies: [],
        chest: undefined,
        items: []
    };

    var _inv_count = ini_read_real("inventory", "count", 0);
    for (var i = 0; i < _inv_count; i++) {
        array_push(_state.inventory_names, ini_read_string("inventory", "item_" + string(i), ""));
    }

    var _floor_count = ini_read_real("floor", "count", 0);
    for (var i = 0; i < _floor_count; i++) {
        array_push(_state.floor, {
            x: ini_read_real("floor", "tile_" + string(i) + "_x", 0),
            y: ini_read_real("floor", "tile_" + string(i) + "_y", 0)
        });
    }

    var _wall_count = ini_read_real("walls", "count", 0);
    for (var i = 0; i < _wall_count; i++) {
        var _k = "wall_" + string(i) + "_";
        array_push(_state.walls, {
            obj: ini_read_string("walls", _k + "obj", ""),
            x: ini_read_real("walls", _k + "x", 0),
            y: ini_read_real("walls", _k + "y", 0)
        });
    }

    var _enemy_count = ini_read_real("enemies", "count", 0);
    for (var i = 0; i < _enemy_count; i++) {
        var _ek = "enemy_" + string(i) + "_";
        array_push(_state.enemies, {
            obj: ini_read_string("enemies", _ek + "obj", ""),
            x: ini_read_real("enemies", _ek + "x", 0),
            y: ini_read_real("enemies", _ek + "y", 0),
            hp: ini_read_real("enemies", _ek + "hp", 0)
        });
    }

    if (ini_read_real("chest", "exists", 0) == 1) {
        _state.chest = {
            x: ini_read_real("chest", "x", 0),
            y: ini_read_real("chest", "y", 0),
            opened: ini_read_real("chest", "opened", 0) == 1
        };
    }

    var _item_count = ini_read_real("items", "count", 0);
    for (var i = 0; i < _item_count; i++) {
        var _ik = "item_" + string(i) + "_";
        array_push(_state.items, {
            obj: ini_read_string("items", _ik + "obj", ""),
            x: ini_read_real("items", _ik + "x", 0),
            y: ini_read_real("items", _ik + "y", 0)
        });
    }

    ini_close();
    return _state;
}
