// та же генерация комнаты что и в CombatRoomControllerO - чистые данные
active_generator = GenerateBSPRoomScr;
grid_w = 16;
grid_h = 9;
cell_size = 24;
wall_target = 10;
enemy_target = 4;
chest_target = 1;
item_target = 3;
min_spacing = 1.5;
item_objects = [BombO, BumerangO, OldTvO, PuffFishO, RockO, ShotgunO, ShurikenO, TrashCanO];

// реальные имена инвентарных айтемов (EveryItemScr, без Heart/Placeholder)
item_names = ["YoYo", "Balloon", "Birdie", "Crow", "Cigarette", "Beer", "Angel Wings", "Aim", "Pills", "Piggy Bank"];

max_depth = 20; // сколько уровней "прошёл" симулированный забег к моменту сохранения
trials_per_config = 30;

// json нативно уже есть, оборачиваем в ту же сигнатуру (state, path) / (path)
function SaveStateAsJson(_state, _path) {
    var _json = json_stringify(_state);
    var _file = file_text_open_write(_path);
    file_text_write_string(_file, _json);
    file_text_close(_file);
}
function LoadStateFromJson(_path) {
    var _file = file_text_open_read(_path);
    var _json = "";
    while (!file_text_eof(_file)) {
        _json += file_text_read_string(_file);
        file_text_readln(_file);
    }
    file_text_close(_file);
    return json_parse(_json);
}

// точный размер файла на диске - для всех трёх форматов одинаково
function get_file_size(_path) {
    if (!file_exists(_path)) return 0;
    var _f = file_bin_open(_path, 0);
    var _size = file_bin_size(_f);
    file_bin_close(_f);
    return _size;
}

// шесть связок формат x стратегия
methods = [
    { format: "json",   ext: "json", strategy: "full",  write: SaveStateAsJson,   read: LoadStateFromJson },
    { format: "json",   ext: "json", strategy: "delta", write: SaveStateAsJson,   read: LoadStateFromJson },
    { format: "ini",    ext: "ini",  strategy: "full",  write: SaveStateAsIni,    read: LoadStateFromIni },
    { format: "ini",    ext: "ini",  strategy: "delta", write: SaveStateAsIni,    read: LoadStateFromIni },
    { format: "binary", ext: "bin",  strategy: "full",  write: SaveStateAsBinary, read: LoadStateFromBinary },
    { format: "binary", ext: "bin",  strategy: "delta", write: SaveStateAsBinary, read: LoadStateFromBinary },
];

results_path = working_directory + "saveload_benchmark.csv";
var _f = file_text_open_write(results_path);
file_text_write_string(_f, "format,strategy,depth,trial,write_time_us,read_time_us,file_size_bytes\n");
file_text_close(_f);
show_debug_message("save/load benchmark results file (reset): " + results_path);

function log_row(_format, _strategy, _depth, _trial, _write_us, _read_us, _size) {
    var _line = _format + "," + _strategy + "," + string(_depth) + "," + string(_trial) + ","
        + string(_write_us) + "," + string(_read_us) + "," + string(_size) + "\n";
    var _ff = file_text_open_append(results_path);
    file_text_write_string(_ff, _line);
    file_text_close(_ff);
}

// одна и та же случайная последовательность на весь трайл - раздаётся ВСЕМ шести связкам
function build_trial_sequence() {
    var _seq = array_create(max_depth);
    var _inv = [];
    var _money = 0;

    for (var d = 1; d <= max_depth; d++) {
        var _spec = active_generator(grid_w, grid_h, wall_target, enemy_target, chest_target, item_target, item_objects, min_spacing);

        // пол - самый большой список во всём payload'е (обычно 100+ клеток против ~10 стен)
        var _floor = [];
        for (var i = 0; i < array_length(_spec.floor); i++) {
            var _fc = _spec.floor[i];
            array_push(_floor, { x: _fc.gx * cell_size, y: _fc.gy * cell_size });
        }

        var _walls = [];
        for (var i = 0; i < array_length(_spec.walls); i++) {
            var _c = _spec.walls[i];
            array_push(_walls, { obj: object_get_name(_c.obj), x: _c.gx * cell_size, y: _c.gy * cell_size });
        }
        var _enemies = [];
        for (var i = 0; i < array_length(_spec.enemies); i++) {
            var _c = _spec.enemies[i];
            array_push(_enemies, { obj: "EnemyFlyO", x: _c.gx * cell_size, y: _c.gy * cell_size, hp: 3 });
        }
        var _chest = (array_length(_spec.chest) > 0)
            ? { x: _spec.chest[0].gx * cell_size, y: _spec.chest[0].gy * cell_size, opened: false }
            : undefined;
        var _items = [];
        for (var i = 0; i < array_length(_spec.items); i++) {
            var _c = _spec.items[i];
            array_push(_items, { obj: object_get_name(_c.obj), x: _c.gx * cell_size, y: _c.gy * cell_size });
        }

        // прогресс игрока - инвентарь и деньги правдоподобно растут вместе с глубиной
        var _new_items = [];
        if (irandom(2) == 0) { // примерно раз в 3 уровня - как открыть сундук не на каждом уровне
            var _name = item_names[irandom(array_length(item_names) - 1)];
            array_push(_new_items, _name);
            array_push(_inv, _name);
        }
        var _money_gain = irandom_range(0, 15);
        _money += _money_gain;
        var _hp = irandom_range(1, 100);

        var _inv_copy = array_create(array_length(_inv));
        array_copy(_inv_copy, 0, _inv, 0, array_length(_inv));

        _seq[d - 1] = {
            floor: _floor, walls: _walls, enemies: _enemies, chest: _chest, items: _items,
            player_x: _spec.player.gx * cell_size, player_y: _spec.player.gy * cell_size,
            player_hp: _hp,
            player_money: _money,
            levels_completed: d,
            inventory_names: _inv_copy,
            new_items_this_level: _new_items,
            money_gain_this_level: _money_gain
        };
    }
    return _seq;
}

function run_full(_method, _seq, _trial) {
    var _path = working_directory + "sl_" + _method.format + "_full." + _method.ext;
    for (var d = 1; d <= max_depth; d++) {
        var _state = _seq[d - 1];

        // ini_open() дописывает к старому файлу, поэтому чистим сами (в отличие от
        // file_text_open_write/buffer_save для json/binary
        if (file_exists(_path)) file_delete(_path);

        var _t0 = get_timer();
        _method.write(_state, _path);
        var _write_us = get_timer() - _t0;

        var _t1 = get_timer();
        _method.read(_path);
        var _read_us = get_timer() - _t1;

        log_row(_method.format, "full", d, _trial, _write_us, _read_us, get_file_size(_path));
    }
}

function run_delta(_method, _seq, _trial) {
    // чистим прошлые файлы этой связки перед новым прогоном
    for (var d = 1; d <= max_depth; d++) {
        var _p = working_directory + "sl_" + _method.format + "_delta_" + string(d) + "." + _method.ext;
        if (file_exists(_p)) file_delete(_p);
    }

    for (var d = 1; d <= max_depth; d++) {
        var _s = _seq[d - 1];
        // дельта = комната этого уровня целиком (она и так каждый раз с нуля, тут ничего не
        // сократить) + только ПРИРОСТ игрока за этот уровень, не накопленная сумма
        var _delta_state = {
            floor: _s.floor, walls: _s.walls, enemies: _s.enemies, chest: _s.chest, items: _s.items,
            player_x: _s.player_x, player_y: _s.player_y,
            player_hp: _s.player_hp,
            player_money: _s.money_gain_this_level,
            levels_completed: d,
            inventory_names: _s.new_items_this_level
        };
        var _path = working_directory + "sl_" + _method.format + "_delta_" + string(d) + "." + _method.ext;

        var _t0 = get_timer();
        _method.write(_delta_state, _path);
        var _write_us = get_timer() - _t0;

        // чтение = полный реплей лога с диска от начала до текущей глубины - это и есть
        // реальная цена delta log на загрузке, растущая вместе с длиной лога
        var _t1 = get_timer();
        var _acc_money = 0;
        var _acc_inv = [];
        for (var dd = 1; dd <= d; dd++) {
            var _pp = working_directory + "sl_" + _method.format + "_delta_" + string(dd) + "." + _method.ext;
            var _entry = _method.read(_pp);
            _acc_money += _entry.player_money;
            for (var k = 0; k < array_length(_entry.inventory_names); k++) {
                array_push(_acc_inv, _entry.inventory_names[k]);
            }
        }
        var _read_us = get_timer() - _t1;

        var _total_size = 0;
        for (var dd = 1; dd <= d; dd++) {
            var _pp = working_directory + "sl_" + _method.format + "_delta_" + string(dd) + "." + _method.ext;
            _total_size += get_file_size(_pp);
        }

        log_row(_method.format, "delta", d, _trial, _write_us, _read_us, _total_size);
    }
}

trial_index = 0;
method_index = 0;
trial_sequence = undefined;
state = "next_trial";
done = false;
total_configs = trials_per_config * array_length(methods);
