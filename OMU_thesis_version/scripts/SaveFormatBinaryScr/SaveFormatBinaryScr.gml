// фиксированный порядок полей

function SaveStateAsBinary(_state, _path) {
    var _buf = buffer_create(1024, buffer_grow, 1);

    buffer_write(_buf, buffer_f64, _state.player_hp);
    buffer_write(_buf, buffer_f64, _state.player_money);
    buffer_write(_buf, buffer_f64, _state.levels_completed);
    buffer_write(_buf, buffer_f64, _state.player_x);
    buffer_write(_buf, buffer_f64, _state.player_y);

    buffer_write(_buf, buffer_u16, array_length(_state.inventory_names));
    for (var i = 0; i < array_length(_state.inventory_names); i++) {
        buffer_write(_buf, buffer_string, _state.inventory_names[i]);
    }

    buffer_write(_buf, buffer_u16, array_length(_state.floor));
    for (var i = 0; i < array_length(_state.floor); i++) {
        var _fl = _state.floor[i];
        buffer_write(_buf, buffer_f64, _fl.x);
        buffer_write(_buf, buffer_f64, _fl.y);
    }

    buffer_write(_buf, buffer_u16, array_length(_state.walls));
    for (var i = 0; i < array_length(_state.walls); i++) {
        var _w = _state.walls[i];
        buffer_write(_buf, buffer_string, _w.obj);
        buffer_write(_buf, buffer_f64, _w.x);
        buffer_write(_buf, buffer_f64, _w.y);
    }

    buffer_write(_buf, buffer_u16, array_length(_state.enemies));
    for (var i = 0; i < array_length(_state.enemies); i++) {
        var _e = _state.enemies[i];
        buffer_write(_buf, buffer_string, _e.obj);
        buffer_write(_buf, buffer_f64, _e.x);
        buffer_write(_buf, buffer_f64, _e.y);
        buffer_write(_buf, buffer_f64, _e.hp);
    }

    buffer_write(_buf, buffer_u8, is_undefined(_state.chest) ? 0 : 1);
    if (!is_undefined(_state.chest)) {
        buffer_write(_buf, buffer_f64, _state.chest.x);
        buffer_write(_buf, buffer_f64, _state.chest.y);
        buffer_write(_buf, buffer_u8, _state.chest.opened ? 1 : 0);
    }

    buffer_write(_buf, buffer_u16, array_length(_state.items));
    for (var i = 0; i < array_length(_state.items); i++) {
        var _it = _state.items[i];
        buffer_write(_buf, buffer_string, _it.obj);
        buffer_write(_buf, buffer_f64, _it.x);
        buffer_write(_buf, buffer_f64, _it.y);
    }

    buffer_save(_buf, _path);
    var _size = buffer_tell(_buf);
    buffer_delete(_buf);
    return _size;
}

function LoadStateFromBinary(_path) {
    var _buf = buffer_load(_path);

    var _state = {
        player_hp: buffer_read(_buf, buffer_f64),
        player_money: buffer_read(_buf, buffer_f64),
        levels_completed: buffer_read(_buf, buffer_f64),
        player_x: buffer_read(_buf, buffer_f64),
        player_y: buffer_read(_buf, buffer_f64),
        inventory_names: [],
        floor: [],
        walls: [],
        enemies: [],
        chest: undefined,
        items: []
    };

    var _inv_count = buffer_read(_buf, buffer_u16);
    for (var i = 0; i < _inv_count; i++) {
        array_push(_state.inventory_names, buffer_read(_buf, buffer_string));
    }

    var _floor_count = buffer_read(_buf, buffer_u16);
    for (var i = 0; i < _floor_count; i++) {
        array_push(_state.floor, {
            x: buffer_read(_buf, buffer_f64),
            y: buffer_read(_buf, buffer_f64)
        });
    }

    var _wall_count = buffer_read(_buf, buffer_u16);
    for (var i = 0; i < _wall_count; i++) {
        array_push(_state.walls, {
            obj: buffer_read(_buf, buffer_string),
            x: buffer_read(_buf, buffer_f64),
            y: buffer_read(_buf, buffer_f64)
        });
    }

    var _enemy_count = buffer_read(_buf, buffer_u16);
    for (var i = 0; i < _enemy_count; i++) {
        array_push(_state.enemies, {
            obj: buffer_read(_buf, buffer_string),
            x: buffer_read(_buf, buffer_f64),
            y: buffer_read(_buf, buffer_f64),
            hp: buffer_read(_buf, buffer_f64)
        });
    }

    var _has_chest = buffer_read(_buf, buffer_u8);
    if (_has_chest == 1) {
        _state.chest = {
            x: buffer_read(_buf, buffer_f64),
            y: buffer_read(_buf, buffer_f64),
            opened: buffer_read(_buf, buffer_u8) == 1
        };
    }

    var _item_count = buffer_read(_buf, buffer_u16);
    for (var i = 0; i < _item_count; i++) {
        array_push(_state.items, {
            obj: buffer_read(_buf, buffer_string),
            x: buffer_read(_buf, buffer_f64),
            y: buffer_read(_buf, buffer_f64)
        });
    }

    buffer_delete(_buf);
    return _state;
}

// ===========================================================================================

function write_binary_str(_buf, _str) {
    var _len = string_length(_str);
    buffer_write(_buf, buffer_u16, _len);
    for (var i = 1; i <= _len; i++) {
        buffer_write(_buf, buffer_u8, ord(string_char_at(_str, i)));
    }
}
function read_binary_str(_buf) {
    var _len = buffer_read(_buf, buffer_u16);
    var _str = "";
    for (var i = 0; i < _len; i++) {
        _str += chr(buffer_read(_buf, buffer_u8));
    }
    return _str;
}

function write_binary_walls_list(_buf, _list) {
    buffer_write(_buf, buffer_u16, array_length(_list));
    for (var i = 0; i < array_length(_list); i++) {
        write_binary_str(_buf, _list[i].obj);
        buffer_write(_buf, buffer_f64, _list[i].x);
        buffer_write(_buf, buffer_f64, _list[i].y);
    }
}
function read_binary_walls_list(_buf) {
    var _n = buffer_read(_buf, buffer_u16);
    var _out = [];
    for (var i = 0; i < _n; i++) {
        var _obj = read_binary_str(_buf);
        var _x = buffer_read(_buf, buffer_f64);
        var _y = buffer_read(_buf, buffer_f64);
        array_push(_out, { obj: _obj, x: _x, y: _y });
    }
    return _out;
}

function write_binary_floor_list(_buf, _list) {
    buffer_write(_buf, buffer_u16, array_length(_list));
    for (var i = 0; i < array_length(_list); i++) {
        buffer_write(_buf, buffer_f64, _list[i].x);
        buffer_write(_buf, buffer_f64, _list[i].y);
    }
}
function read_binary_floor_list(_buf) {
    var _n = buffer_read(_buf, buffer_u16);
    var _out = [];
    for (var i = 0; i < _n; i++) {
        var _x = buffer_read(_buf, buffer_f64);
        var _y = buffer_read(_buf, buffer_f64);
        array_push(_out, { x: _x, y: _y });
    }
    return _out;
}

function write_binary_enemies_list(_buf, _list) {
    buffer_write(_buf, buffer_u16, array_length(_list));
    for (var i = 0; i < array_length(_list); i++) {
        write_binary_str(_buf, _list[i].obj);
        buffer_write(_buf, buffer_f64, _list[i].x);
        buffer_write(_buf, buffer_f64, _list[i].y);
        buffer_write(_buf, buffer_f64, _list[i].hp);
    }
}
function read_binary_enemies_list(_buf) {
    var _n = buffer_read(_buf, buffer_u16);
    var _out = [];
    for (var i = 0; i < _n; i++) {
        var _obj = read_binary_str(_buf);
        var _x = buffer_read(_buf, buffer_f64);
        var _y = buffer_read(_buf, buffer_f64);
        var _hp = buffer_read(_buf, buffer_f64);
        array_push(_out, { obj: _obj, x: _x, y: _y, hp: _hp });
    }
    return _out;
}

function write_binary_items_list(_buf, _list) {
    buffer_write(_buf, buffer_u16, array_length(_list));
    for (var i = 0; i < array_length(_list); i++) {
        write_binary_str(_buf, _list[i].obj);
        buffer_write(_buf, buffer_f64, _list[i].x);
        buffer_write(_buf, buffer_f64, _list[i].y);
    }
}
function read_binary_items_list(_buf) {
    var _n = buffer_read(_buf, buffer_u16);
    var _out = [];
    for (var i = 0; i < _n; i++) {
        var _obj = read_binary_str(_buf);
        var _x = buffer_read(_buf, buffer_f64);
        var _y = buffer_read(_buf, buffer_f64);
        array_push(_out, { obj: _obj, x: _x, y: _y });
    }
    return _out;
}

function write_binary_string_list(_buf, _list) {
    buffer_write(_buf, buffer_u16, array_length(_list));
    for (var i = 0; i < array_length(_list); i++) {
        write_binary_str(_buf, _list[i]);
    }
}
function read_binary_string_list(_buf) {
    var _n = buffer_read(_buf, buffer_u16);
    var _out = [];
    for (var i = 0; i < _n; i++) {
        array_push(_out, read_binary_str(_buf));
    }
    return _out;
}

function write_combat_snapshot(_buf, _snap) {
    buffer_write(_buf, buffer_u8, is_undefined(_snap) ? 0 : 1);
    if (is_undefined(_snap)) return;
    write_binary_walls_list(_buf, _snap.walls);
    write_binary_floor_list(_buf, _snap.floor);
    write_binary_enemies_list(_buf, _snap.enemies);
    buffer_write(_buf, buffer_u8, is_undefined(_snap.chest) ? 0 : 1);
    if (!is_undefined(_snap.chest)) {
        buffer_write(_buf, buffer_f64, _snap.chest.x);
        buffer_write(_buf, buffer_f64, _snap.chest.y);
        buffer_write(_buf, buffer_u8, _snap.chest.opened ? 1 : 0);
    }
    write_binary_items_list(_buf, _snap.items);
    buffer_write(_buf, buffer_f64, _snap.player.x);
    buffer_write(_buf, buffer_f64, _snap.player.y);
}
function read_combat_snapshot(_buf) {
    if (buffer_read(_buf, buffer_u8) == 0) return undefined;
    var _snap = {};
    _snap.walls = read_binary_walls_list(_buf);
    _snap.floor = read_binary_floor_list(_buf);
    _snap.enemies = read_binary_enemies_list(_buf);
    _snap.chest = undefined;
    var _has_chest = buffer_read(_buf, buffer_u8);
    if (_has_chest == 1) {
        var _cx = buffer_read(_buf, buffer_f64);
        var _cy = buffer_read(_buf, buffer_f64);
        var _copened = buffer_read(_buf, buffer_u8) == 1;
        _snap.chest = { x: _cx, y: _cy, opened: _copened };
    }
    _snap.items = read_binary_items_list(_buf);
    var _px = buffer_read(_buf, buffer_f64);
    var _py = buffer_read(_buf, buffer_f64);
    _snap.player = { x: _px, y: _py };
    return _snap;
}

function write_boss_snapshot(_buf, _snap) {
    buffer_write(_buf, buffer_u8, is_undefined(_snap) ? 0 : 1);
    if (is_undefined(_snap)) return;
    buffer_write(_buf, buffer_f64, _snap.x);
    buffer_write(_buf, buffer_f64, _snap.y);
    buffer_write(_buf, buffer_f64, _snap.hp);
    buffer_write(_buf, buffer_u8, _snap.dying ? 1 : 0);
    buffer_write(_buf, buffer_f64, _snap.phase);
    buffer_write(_buf, buffer_f64, _snap.phase_timer);
    buffer_write(_buf, buffer_f64, _snap.direction);
    buffer_write(_buf, buffer_u8, _snap.bleeding ? 1 : 0);
    buffer_write(_buf, buffer_f64, _snap.bleed_damage_timer);
    buffer_write(_buf, buffer_f64, _snap.player.x);
    buffer_write(_buf, buffer_f64, _snap.player.y);
}
function read_boss_snapshot(_buf) {
    if (buffer_read(_buf, buffer_u8) == 0) return undefined;
    var _snap = {};
    _snap.x = buffer_read(_buf, buffer_f64);
    _snap.y = buffer_read(_buf, buffer_f64);
    _snap.hp = buffer_read(_buf, buffer_f64);
    _snap.dying = buffer_read(_buf, buffer_u8) == 1;
    _snap.phase = buffer_read(_buf, buffer_f64);
    _snap.phase_timer = buffer_read(_buf, buffer_f64);
    _snap.direction = buffer_read(_buf, buffer_f64);
    _snap.bleeding = buffer_read(_buf, buffer_u8) == 1;
    _snap.bleed_damage_timer = buffer_read(_buf, buffer_f64);
    var _bpx = buffer_read(_buf, buffer_f64);
    var _bpy = buffer_read(_buf, buffer_f64);
    _snap.player = { x: _bpx, y: _bpy };
    return _snap;
}

function SaveGameStateAsBinary(_state, _path) {
    var _buf = buffer_create(1024, buffer_grow, 1);

    buffer_write(_buf, buffer_f64, _state.player_hp);
    buffer_write(_buf, buffer_f64, _state.player_max_hp);
    buffer_write(_buf, buffer_f64, _state.player_money);
    buffer_write(_buf, buffer_f64, _state.levels_completed);
    buffer_write(_buf, buffer_f64, _state.run_time);
    buffer_write(_buf, buffer_f64, _state.current_world_index);

    buffer_write(_buf, buffer_u16, array_length(_state.route));
    for (var i = 0; i < array_length(_state.route); i++) {
        buffer_write(_buf, buffer_f64, _state.route[i]);
    }
    buffer_write(_buf, buffer_f64, _state.route_index);

    write_binary_string_list(_buf, _state.inventory_names);
    write_binary_string_list(_buf, _state.powerup_names);

    write_binary_str(_buf, _state.current_room_name);
    write_binary_str(_buf, _state.carried_object_name);

    // мелкий мёртвый груз старой room_states-системы (Combat_Room её не читает)
    write_binary_str(_buf, json_stringify(_state.room_states));

    buffer_write(_buf, buffer_f64, _state.saved_balloon_hits);
    write_binary_str(_buf, _state.world_stage);
    buffer_write(_buf, buffer_f64, _state.cigarette_rooms_since_pickup);
    buffer_write(_buf, buffer_f64, _state.beer_rooms_since_pickup);

    write_combat_snapshot(_buf, _state.combat_room_snapshot);
    write_boss_snapshot(_buf, _state.boss_snapshot);

    buffer_save(_buf, _path);
    var _size = buffer_tell(_buf);
    buffer_delete(_buf);
    return _size;
}

function LoadGameStateFromBinary(_path) {
    var _buf = buffer_load(_path);
    var _state = {};

    _state.player_hp = buffer_read(_buf, buffer_f64);
    _state.player_max_hp = buffer_read(_buf, buffer_f64);
    _state.player_money = buffer_read(_buf, buffer_f64);
    _state.levels_completed = buffer_read(_buf, buffer_f64);
    _state.run_time = buffer_read(_buf, buffer_f64);
    _state.current_world_index = buffer_read(_buf, buffer_f64);

    var _route_count = buffer_read(_buf, buffer_u16);
    _state.route = [];
    for (var i = 0; i < _route_count; i++) {
        array_push(_state.route, buffer_read(_buf, buffer_f64));
    }
    _state.route_index = buffer_read(_buf, buffer_f64);

    _state.inventory_names = read_binary_string_list(_buf);
    _state.powerup_names = read_binary_string_list(_buf);

    _state.current_room_name = read_binary_str(_buf);
    _state.carried_object_name = read_binary_str(_buf);

    _state.room_states = json_parse(read_binary_str(_buf));

    _state.saved_balloon_hits = buffer_read(_buf, buffer_f64);
    _state.world_stage = read_binary_str(_buf);
    _state.cigarette_rooms_since_pickup = buffer_read(_buf, buffer_f64);
    _state.beer_rooms_since_pickup = buffer_read(_buf, buffer_f64);

    _state.combat_room_snapshot = read_combat_snapshot(_buf);
    _state.boss_snapshot = read_boss_snapshot(_buf);

    buffer_delete(_buf);
    return _state;
}
