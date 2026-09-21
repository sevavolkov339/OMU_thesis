// генератор комнаты, по умолчанию bsp
active_generator = GenerateBSPRoomScr;
if (instance_exists(PipelineValidationO) && PipelineValidationO.cfg_generator == "proc") {
    active_generator = GenerateProceduralRoomScr;
}

grid_w = 16;
grid_h = 9;
cell_size = 24;

wall_target = 10; // было 20 - многовато вместе с заливкой вырезанной части формы (L/крест)
enemy_target = 4;
chest_target = 1;
item_target = 3;
min_items = 2; // генератор берёт irandom(item_target), это может дать и 0 - подстраховываемся
min_spacing = 1.5;

enemy_types = [EnemyFlyO];
item_objects = [BombO, BumerangO, OldTvO, PuffFishO, RockO, ShotgunO, ShurikenO, TrashCanO];

// центр большого канваса комнаты (1152x648) - тут и стоят твои ручные стены-границы
origin_x = 384;
origin_y = 216;

levels_to_boss = 10;

level_completed = false;
player_ref = noone;

// снимок уровня в его НАЧАЛЬНОМ состоянии - собирается один раз
level_start_snapshot = undefined;

// place_meeting() проверяет маску ВЫЗЫВАЮЩЕГО инстанса, а у CombatRoomControllerO своего
// спрайта нет вообще - так что place_meeting отсюда почти ничего не находил
function cell_clear(_ccx, _ccy, _blockers) {
    return collision_rectangle(_ccx - 10, _ccy - 10, _ccx + 10, _ccy + 10, _blockers, false, true) == noone;
}

// компаньон-объекты инвентарных айтемов - та же логика
function spawn_inventory_companions() {
    if (!instance_exists(InventoryControllerO) || !instance_exists(player_ref)) return;
    var _inv_items = InventoryControllerO.items;
    for (var i = 0; i < array_length(_inv_items); i++) {
        var _item = _inv_items[i];
        if (_item.type == "Heart") continue;
        if (_item.obj == noone) continue;

        var _iangle = irandom(360);
        var _idist = 20 + i * 12;
        var _isx = player_ref.x + lengthdir_x(_idist, _iangle);
        var _isy = player_ref.y + lengthdir_y(_idist, _iangle);
        instance_create_layer(_isx, _isy, "UIL", _item.obj);
    }
}

// хвост общий для обеих веток - и свежей генерации, и восстановления из сохранения
function finish_level_setup() {
    // стены только что появились - грид у SetupPathwayO уже мог собраться пустым до этого
    if (instance_exists(SetupPathwayO)) {
        mp_grid_add_instances(SetupPathwayO.grid, WallForEnemiesO, 0);
        mp_grid_add_instances(SetupPathwayO.grid, WallInteriorO, 0);
        // a* врагов (EnemyFlyO/Alarm_0) ходит по coarse_grid, а не по этому mp_grid - тот
        SetupPathwayO.rebuild_coarse_pathing();
    }

    // камера фиксированная, показывает всю сгенерированную комнату целиком
    if (instance_exists(CameraControllerO)) {
        CameraControllerO.following = false;
        CameraControllerO.moving = false;
        CameraControllerO.clean_cam_x = origin_x;
        CameraControllerO.clean_cam_y = origin_y;
        camera_set_view_pos(CameraControllerO.cam, origin_x, origin_y);
    }

    // чёрный -> прозрачный переход при заходе на уровень
    if (instance_exists(FadeTransitionO)) {
        FadeTransitionO.fade_progress = 1;
        FadeTransitionO.fade_out(0.05);
    } else {
        var _f = instance_create_layer(0, 0, "UIL", FadeTransitionO);
        _f.fade_progress = 1;
        _f.fade_out(0.05);
    }

    // отслеживаем количество айтемов в инвентаре
    prev_inv_count = instance_exists(InventoryControllerO) ? array_length(InventoryControllerO.items) : 0;
}

// свежая процедурная генерация - обычный путь при входе через дверь/старте нового уровня
function materialize_generated(_spec) {
    // для лога PipelineValidationO - сколько стен генератор реально положил сам
    last_walls_achieved = array_length(_spec.walls);

    // пол - FloorTileO по клеткам
    for (var i = 0; i < array_length(_spec.floor); i++) {
        var _c = _spec.floor[i];
        instance_create_layer(origin_x + _c.gx * cell_size + cell_size / 2, origin_y + _c.gy * cell_size + cell_size / 2, "EnvironmentL", FloorTileO);
    }

    // один инстанс на клетку стены - WallForEnemiesO/WallInteriorO (из генератора) уже ровно
    for (var i = 0; i < array_length(_spec.walls); i++) {
        var _c = _spec.walls[i];
        var _wx = origin_x + _c.gx * cell_size + cell_size / 2;
        var _wy = origin_y + _c.gy * cell_size + cell_size / 2;
        instance_create_layer(_wx, _wy, "WallsL", _c.obj);
    }

    // граница самой формы комнаты
    var _shape_mask = LevelGenShape(_spec.shape, grid_w, grid_h);
    var _wall_grid = array_create(grid_w);
    for (var gx = 0; gx < grid_w; gx++) _wall_grid[gx] = array_create(grid_h, false);
    for (var i = 0; i < array_length(_spec.walls); i++) {
        _wall_grid[_spec.walls[i].gx][_spec.walls[i].gy] = true;
    }
    for (var gx = 0; gx < grid_w; gx++) {
        for (var gy = 0; gy < grid_h; gy++) {
            if (_shape_mask[gx][gy] == 1) continue;
            instance_create_layer(origin_x + gx * cell_size + cell_size / 2, origin_y + gy * cell_size + cell_size / 2, "WallsL", WallForEnemiesO);
        }
    }

    // сплошное кольцо стен вокруг всей сетки
    for (var gx = -1; gx <= grid_w; gx++) {
        instance_create_layer(origin_x + gx * cell_size + cell_size / 2, origin_y - cell_size / 2, "WallsL", WallForEnemiesO);
        instance_create_layer(origin_x + gx * cell_size + cell_size / 2, origin_y + grid_h * cell_size + cell_size / 2, "WallsL", WallForEnemiesO);
    }
    for (var gy = 0; gy < grid_h; gy++) {
        instance_create_layer(origin_x - cell_size / 2, origin_y + gy * cell_size + cell_size / 2, "WallsL", WallForEnemiesO);
        instance_create_layer(origin_x + grid_w * cell_size + cell_size / 2, origin_y + gy * cell_size + cell_size / 2, "WallsL", WallForEnemiesO);
    }

    // тот же связный кусок пола
    reachable_mask = LevelGenLargestComponent(_shape_mask, grid_w, grid_h, _wall_grid);

    // игрок обязательно раньше врагов - EnemyO/EnemyFlyO читают PlayerBallerO.x/y
    var _px = origin_x + _spec.player.gx * cell_size + cell_size / 2;
    var _py = origin_y + _spec.player.gy * cell_size + cell_size / 2;
    player_ref = instance_create_layer(_px, _py, "PlayerL", PlayerBallerO);

    spawn_inventory_companions();

    // реальный объект мухи вместо тестового
    for (var i = 0; i < array_length(_spec.enemies); i++) {
        var _c = _spec.enemies[i];
        var _ex = origin_x + _c.gx * cell_size + cell_size / 2;
        var _ey = origin_y + _c.gy * cell_size + cell_size / 2;
        var _obj = enemy_types[irandom(array_length(enemy_types) - 1)];
        instance_create_layer(_ex, _ey, "EnemiesL", _obj);
    }

    // сундук - не берём координаты генератора напрямую
    if (array_length(_spec.chest) > 0 && array_length(_spec.floor) > 0) {
        var _chest_blockers = [WallForEnemiesO, WallInteriorO, PlayerBallerO];
        var _cx = 0, _cy = 0, _c_tries = 0, _c_found = false;
        do {
            var _cc = _spec.floor[irandom(array_length(_spec.floor) - 1)];
            _c_tries++;
            if (_cc.gx < 1 || _cc.gx > grid_w - 2 || _cc.gy < 1 || _cc.gy > grid_h - 2) continue;
            if (reachable_mask[_cc.gx][_cc.gy] != 1) continue;
            _cx = origin_x + _cc.gx * cell_size + cell_size / 2;
            _cy = origin_y + _cc.gy * cell_size + cell_size / 2;
            _c_found = cell_clear(_cx, _cy, _chest_blockers);
        } until (_c_found || _c_tries >= 200);
        if (_c_found) {
            instance_create_layer(_cx, _cy, "EffectsL", BoxChestO);
        }
    }

    for (var i = 0; i < array_length(_spec.items); i++) {
        var _c = _spec.items[i];
        instance_create_layer(origin_x + _c.gx * cell_size + cell_size / 2, origin_y + _c.gy * cell_size + cell_size / 2, "EffectsL", _c.obj);
    }

    // генератор сам решает сколько предметов класть (irandom(item_target) - может выпасть и 0)
    var _missing = min_items - array_length(_spec.items);
    if (_missing > 0 && array_length(_spec.floor) > 0) {
        var _blockers = [WallForEnemiesO, WallInteriorO, BoxChestO, EnemyO, PlayerBallerO, BombO, BumerangO, OldTvO, PuffFishO, RockO, ShotgunO, ShurikenO, TrashCanO];
        for (var i = 0; i < _missing; i++) {
            var _tries = 0, _found = false, _ix = 0, _iy = 0;
            do {
                var _fc = _spec.floor[irandom(array_length(_spec.floor) - 1)];
                _ix = origin_x + _fc.gx * cell_size + cell_size / 2;
                _iy = origin_y + _fc.gy * cell_size + cell_size / 2;
                _tries++;
                _found = cell_clear(_ix, _iy, _blockers);
            } until (_found || _tries >= 200);
            if (_found) {
                var _extra_obj = item_objects[irandom(array_length(item_objects) - 1)];
                instance_create_layer(_ix, _iy, "EffectsL", _extra_obj);
            }
        }
    }
}

// восстановление из сохранения - точные позиции/хп с момента сохранения
function materialize_from_snapshot(_snap) {
    for (var i = 0; i < array_length(_snap.floor); i++) {
        var _f = _snap.floor[i];
        instance_create_layer(_f.x, _f.y, "EnvironmentL", FloorTileO);
    }

    var _wall_grid = array_create(grid_w);
    for (var gx = 0; gx < grid_w; gx++) _wall_grid[gx] = array_create(grid_h, false);

    for (var i = 0; i < array_length(_snap.walls); i++) {
        var _w = _snap.walls[i];
        instance_create_layer(_w.x, _w.y, "WallsL", asset_get_index(_w.obj));

        // для reachable_mask ниже - только клетки внутри самой сетки 0..grid_w-1/0..grid_h-1
        var _gx = round((_w.x - origin_x - cell_size / 2) / cell_size);
        var _gy = round((_w.y - origin_y - cell_size / 2) / cell_size);
        if (_gx >= 0 && _gx < grid_w && _gy >= 0 && _gy < grid_h) {
            _wall_grid[_gx][_gy] = true;
        }
    }

    // форма уже "запечена" в список стен на момент сохранения
    var _shape_mask = array_create(grid_w);
    for (var gx = 0; gx < grid_w; gx++) _shape_mask[gx] = array_create(grid_h, 1);
    reachable_mask = LevelGenLargestComponent(_shape_mask, grid_w, grid_h, _wall_grid);

    player_ref = instance_create_layer(_snap.player.x, _snap.player.y, "PlayerL", PlayerBallerO);

    spawn_inventory_companions();

    for (var i = 0; i < array_length(_snap.enemies); i++) {
        var _en = _snap.enemies[i];
        var _e = instance_create_layer(_en.x, _en.y, "EnemiesL", asset_get_index(_en.obj));
        if (instance_exists(_e)) _e.hp = _en.hp;
    }

    if (!is_undefined(_snap.chest)) {
        var _c = instance_create_layer(_snap.chest.x, _snap.chest.y, "EffectsL", BoxChestO);
        if (instance_exists(_c) && _snap.chest.opened) {
            _c.opened = true;
            _c.image_index = 1;
            _c.image_speed = 0;
        }
    }

    for (var i = 0; i < array_length(_snap.items); i++) {
        var _it = _snap.items[i];
        instance_create_layer(_it.x, _it.y, "EffectsL", asset_get_index(_it.obj));
    }
}

// снимок уровня в его начальном состоянии - вызывается один раз сразу после
// GameControllerO.capture_combat_room_snapshot() на произвольный момент сохранения
function capture_level_start_snapshot() {
    var _walls = [];
    with (WallForEnemiesO) { array_push(_walls, { obj: "WallForEnemiesO", x: x, y: y }); }
    with (WallInteriorO)   { array_push(_walls, { obj: "WallInteriorO", x: x, y: y }); }

    var _floor = [];
    with (FloorTileO) { array_push(_floor, { x: x, y: y }); }

    var _enemies = [];
    with (EnemyFlyO) { array_push(_enemies, { obj: "EnemyFlyO", x: x, y: y, hp: hp }); }

    var _chest = undefined;
    with (BoxChestO) { _chest = { x: x, y: y, opened: opened }; }

    var _items = [];
    for (var i = 0; i < array_length(item_objects); i++) {
        var _obj_id = item_objects[i];
        var _obj_name = object_get_name(_obj_id);
        with (_obj_id) { array_push(_items, { obj: _obj_name, x: x, y: y }); }
    }

    var _player = { x: 0, y: 0 };
    with (PlayerBallerO) { _player = { x: x, y: y }; }

    return {
        walls: _walls, floor: _floor, enemies: _enemies,
        chest: _chest, items: _items, player: _player
    };
}

function generate_level() {
    level_completed = false;
    last_walls_achieved = 0;
    var _t0 = get_timer();

    var _from_snapshot = !is_undefined(global.pending_combat_snapshot);
    if (_from_snapshot) {
        var _snap = global.pending_combat_snapshot;
        global.pending_combat_snapshot = undefined;
        materialize_from_snapshot(_snap);
        level_start_snapshot = _snap;
    } else {
        var _spec = active_generator(grid_w, grid_h, wall_target, enemy_target, chest_target, item_target, item_objects, min_spacing);
        materialize_generated(_spec);
        level_start_snapshot = capture_level_start_snapshot();
    }

    finish_level_setup();

    // валидационный лог - только для свежей генерации
    if (!_from_snapshot && instance_exists(PipelineValidationO) && variable_instance_exists(PipelineValidationO, "log_level_gen")) {
        PipelineValidationO.log_level_gen(
            GameControllerO.levels_completed + 1,
            wall_target,
            last_walls_achieved,
            instance_number(EnemyFlyO),
            get_timer() - _t0
        );
    }
}

generate_level();
