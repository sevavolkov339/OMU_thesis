//pause
if (GameControllerO.game_paused) exit;


// сигарета: отложенный урон в начале уровня — таймер живёт на этом (непостоянном) контроллере уровня,
// поэтому не может сработать уже в другой комнате
if (cigarette_hit_timer > 0) {
    cigarette_hit_timer -= delta_time / 1000000;
    if (cigarette_hit_timer <= 0) {
        cigarette_hit_timer = -1;
        if (instance_exists(PlayerBallerO)) {
            with (PlayerBallerO) {
                // во время полёта на крыльях и в первые секунды уровня сигарета тоже не наносит урон
                if (!flying && spawn_invuln_timer <= 0) {
                    if (blink_time <= 0) {
                        GameControllerO.slow_mo(0.6, 0.3);
                        hp -= 1;
                        stunned = true;
                        stun_time = room_speed * 0.2;
                        var kb = 5;
                        var dir = random(360); // случайное направление отталкивания
                        knockback_spd_x = lengthdir_x(kb, dir);
                        knockback_spd_y = lengthdir_y(kb, dir);
                        audio_play_sound(Player_Hit_Snd, 0, 0);
                        image_alpha = 1;
                        blink_time = room_speed * 1.5;
                        alarm[1] = 1;
                    } else {
                        hp -= 1;
                    }

                    // поп-ап "-1 {heart} from {cigarette}"
                    var _popup = instance_create_layer(x, y - 24, "EffectsL", ItemPopupInfoO);
                    _popup.parts = [
                        { type: "text",   value: "-1 " },
                        { type: "sprite", value: HealthS },
                        { type: "text",   value: " from " },
                        { type: "sprite", value: SigarettIconS }
                    ];
                }
            }
            GameControllerO.player_hp = PlayerBallerO.hp;
        }
    }
}


//for saves
if (!inventory_applied && instance_exists(GameControllerO)) {
    GameControllerO.apply_pending_inventory_and_powerups();
    inventory_applied = true;
}



// удаляем объекты айтемов которых больше нет в инвентаре
if (instance_exists(InventoryControllerO)) {
    var _all_items = EveryItemScr();
    for (var _i = 0; _i < array_length(_all_items); _i++) {
        var _item_data = _all_items[_i];
        if (_item_data.type == "Heart") continue;
        if (_item_data.obj == noone) continue;
        if (!InventoryControllerO.has_item(_item_data.name)) {
            with (_item_data.obj) {
                instance_destroy();
            }
        }
    }
}

if (!level_started)
{
    start_level();
    level_started = true;
}
// ждём игрока
if (!enemies_spawned && instance_exists(PlayerBallerO))
{
    if (PlayerBallerO.state == PlayerState.PLAY)
    {
        spawn_enemies();
        spawn_inventory_items();
        enemies_spawned = true;
    }
}

// отдельная, независимая от spawn_enemies() логика для комнаты босса: в ней нет ни одной
// (или специально отключена) точки спавна врагов, но предметы на ObjectSpawnPointO должны
// генерироваться рандомно так же, как на обычных уровнях
var _is_boss_room = instance_exists(GameControllerO)
    && (GameControllerO.world_stage == "boss" || GameControllerO.world_stage == "w2_boss");
if (_is_boss_room && !boss_objects_spawned && instance_exists(PlayerBallerO) && PlayerBallerO.state == PlayerState.PLAY)
{
    boss_objects_spawned = true;
    var boss_obj_spawn_points = [];
    with (ObjectSpawnPointO) { array_push(boss_obj_spawn_points, id); }
    if (array_length(boss_obj_spawn_points) > 0) {
        var boss_min_objects = 2; // в комнате босса предметов должно быть не меньше 2
        var boss_max_possible_obj = min(max(max_objects, boss_min_objects), array_length(boss_obj_spawn_points));
        var boss_obj_count = irandom_range(min(boss_min_objects, boss_max_possible_obj), boss_max_possible_obj);
        array_shuffle(boss_obj_spawn_points);
        for (var _bi = 0; _bi < boss_obj_count; _bi++) {
            var boss_obj_spawn = boss_obj_spawn_points[_bi];
            var boss_obj_type = object_types[irandom(array_length(object_types) - 1)];
            instance_create_layer(boss_obj_spawn.x, boss_obj_spawn.y, "BulletsL", boss_obj_type);
        }
    }
}
// проверка прохождения уровня (в комнате босса не применяется — там нет обычных врагов
// вообще, так что счётчик тут же обнулился бы и уровень считался бы пройденным сразу же
// после старта; сама комната босса завершается по-другому — room_goto() при его смерти)
if (enemies_spawned && !level_completed && !_is_boss_room)
{
    if (instance_number(EnemyO) == 0 && instance_number(EnemyFlyO) == 0)
    {
        var door_points = [];
        with (DoorSpawnPointO) { array_push(door_points, id); }
        if (array_length(door_points) > 0) {
            var safe_points = [];
            for (var _i = 0; _i < array_length(door_points); _i++) {
                var _dp = door_points[_i];
                if (!instance_exists(PlayerBallerO) ||
                    point_distance(_dp.x, _dp.y, PlayerBallerO.x, PlayerBallerO.y) > 16) {
                    array_push(safe_points, _dp);
                }
            }
            var _chosen;
            if (array_length(safe_points) > 0) {
                _chosen = safe_points[irandom(array_length(safe_points) - 1)];
            } else {
                _chosen = door_points[irandom(array_length(door_points) - 1)];
            }
            instance_create_layer(_chosen.x, _chosen.y, "ExitL", DoorO);
            // сохраняем позицию двери для восстановления из сохранения
            GameControllerO.save_door_position(_chosen.x, _chosen.y);
        }
        slowing_down = true;
        level_completed = true;
        show_debug_message("УРОВЕНЬ ПРОЙДЕН");
    }
}
//function spawn_enemies()
//{
//    var spawn_points = array_create(0);
//    with (EnemySpawnPointO)
//    {
//        array_push(spawn_points, id);
//    }
//    if (array_length(spawn_points) == 0) return;
//    var max_possible = min(max_enemies, array_length(spawn_points));
//    var enemy_count = irandom_range(min_enemies, max_possible);
//    array_shuffle(spawn_points);
//    for (var i = 0; i < enemy_count; i++)
//    {
//        var spawn = spawn_points[i];
//        var enemy_obj = enemy_types[irandom(array_length(enemy_types) - 1)];
//        instance_create_layer(
//            spawn.x,
//            spawn.y,
//            "EnemiesL",
//            enemy_obj
//        );
//    }
//    // спавн объектов на ObjectSpawnPointO
//    var obj_spawn_points = [];
//    with (ObjectSpawnPointO) {
//        array_push(obj_spawn_points, id);
//    }
//    if (array_length(obj_spawn_points) > 0) {
//        var max_possible_obj = min(max_objects, array_length(obj_spawn_points));
//        var obj_count = irandom_range(min_objects, max_possible_obj);
//        array_shuffle(obj_spawn_points);
//        for (var i = 0; i < obj_count; i++) {
//            var obj_spawn = obj_spawn_points[i];
//            var obj_type = object_types[irandom(array_length(object_types) - 1)];
//            instance_create_layer(obj_spawn.x, obj_spawn.y, "BulletsL", obj_type);
//        }
//    }
//    GameControllerO.slow_mo(0.3, 0.4);
	
//    // спавним принесённый объект если есть
	
//	if (GameControllerO.carried_object != noone && instance_exists(PlayerBallerO)) {
//	    var _angle = irandom(360);
//	    var _sx = PlayerBallerO.x + lengthdir_x(30, _angle);
//	    var _sy = PlayerBallerO.y + lengthdir_y(30, _angle);
//	    // спавним руку, она сама подхватит carried_object
//	    instance_create_layer(_sx, _sy, "BulletsL", HandPutObjectO);
//	    // GameControllerO.carried_object сбрасывается внутри HandPutObjectO create
//	}	
//    //if (GameControllerO.carried_object != noone && instance_exists(PlayerBallerO)) {
//    //    var _angle = irandom(360);
//    //    var _inst = instance_create_layer(
//    //        PlayerBallerO.x + lengthdir_x(30, _angle),
//    //        PlayerBallerO.y + lengthdir_y(30, _angle),
//    //        "BulletsL",
//    //        GameControllerO.carried_object
//    //    );
//    //    GameControllerO.carried_object = noone; // сбрасываем после спавна
//    //}	
	
//}


function spawn_enemies() {
    var _room_state = GameControllerO.get_current_room_state();

    if (_room_state != undefined && _room_state.has_enemy_data) {
        if (_room_state.level_completed) {
            enemies_spawned = true;
            level_completed = true;

            // восстанавливаем дверь на сохранённой позиции без анимации
            var _dx = variable_struct_exists(_room_state, "door_x") ? _room_state.door_x : -1;
            var _dy = variable_struct_exists(_room_state, "door_y") ? _room_state.door_y : -1;
            if (_dx >= 0 && _dy >= 0) {
                var _door = instance_create_layer(_dx, _dy, "ExitL", DoorO);
                _door.skip_intro = true;
            } else {
                // запасной вариант
                var _door_points = [];
                with (DoorSpawnPointO) { array_push(_door_points, id); }
                if (array_length(_door_points) > 0) {
                    var _dp2 = _door_points[irandom(array_length(_door_points) - 1)];
                    var _door = instance_create_layer(_dp2.x, _dp2.y, "ExitL", DoorO);
                    _door.skip_intro = true;
                }
            }

            // восстанавливаем предметы на полу
            var _saved_items = _room_state.items_on_floor;
            if (array_length(_saved_items) > 0) {
                var _all_items = EveryItemScr();
                for (var i = 0; i < array_length(_saved_items); i++) {
                    var _si = _saved_items[i];
                    for (var j = 0; j < array_length(_all_items); j++) {
                        if (_all_items[j].name == _si.item_name) {
                            var _bubble = instance_create_layer(_si.ix, _si.iy, "ItemsL", ItemBubbleO);
                            _bubble.item = _all_items[j];
                            break;
                        }
                    }
                }
            }

            // восстанавливаем объекты на полу
            if (variable_struct_exists(_room_state, "objects_on_floor")) {
                var _saved_obj = _room_state.objects_on_floor;
                for (var i = 0; i < array_length(_saved_obj); i++) {
                    var _so = _saved_obj[i];
                    var _obj = asset_get_index(_so.obj_name);
                    if (_obj >= 0) {
                        instance_create_layer(_so.ox, _so.oy, "BulletsL", _obj);
                    }
                }
            }

        } else {
            // восстанавливаем врагов
            var _saved_enemies = _room_state.enemies;
            for (var i = 0; i < array_length(_saved_enemies); i++) {
                var _e = _saved_enemies[i];
                var _obj = asset_get_index(_e.obj_name);
                if (_obj >= 0) {
                    var _inst = instance_create_layer(_e.ex, _e.ey, "EnemiesL", _obj);
                    if (variable_instance_exists(_inst, "hp")) _inst.hp = _e.ehp;
                }
            }

            // предметы на полу
            var _saved_items = _room_state.items_on_floor;
            if (array_length(_saved_items) > 0) {
                var _all_items = EveryItemScr();
                for (var i = 0; i < array_length(_saved_items); i++) {
                    var _si = _saved_items[i];
                    for (var j = 0; j < array_length(_all_items); j++) {
                        if (_all_items[j].name == _si.item_name) {
                            var _bubble = instance_create_layer(_si.ix, _si.iy, "ItemsL", ItemBubbleO);
                            _bubble.item = _all_items[j];
                            break;
                        }
                    }
                }
            }

            // объекты на полу
            if (variable_struct_exists(_room_state, "objects_on_floor")) {
                var _saved_obj = _room_state.objects_on_floor;
                for (var i = 0; i < array_length(_saved_obj); i++) {
                    var _so = _saved_obj[i];
                    var _obj = asset_get_index(_so.obj_name);
                    if (_obj >= 0) {
                        instance_create_layer(_so.ox, _so.oy, "BulletsL", _obj);
                    }
                }
            }
        }

        GameControllerO.slow_mo(0.3, 0.4);
        return;
    }

    // первый визит — обычный рандомный спавн
    // (точек спавна врагов может не быть вовсе — например в комнате босса она специально
    // отключена, но это не должно мешать спавну предметов на ObjectSpawnPointO ниже)
    var spawn_points = [];
    with (EnemySpawnPointO) { array_push(spawn_points, id); }
    if (array_length(spawn_points) > 0) {
        var max_possible = min(max_enemies, array_length(spawn_points));
        var enemy_count = irandom_range(min_enemies, max_possible);
        array_shuffle(spawn_points);
        for (var i = 0; i < enemy_count; i++) {
            var spawn = spawn_points[i];
            var enemy_obj = enemy_types[irandom(array_length(enemy_types) - 1)];
            instance_create_layer(spawn.x, spawn.y, "EnemiesL", enemy_obj);
        }
    }

    // в комнате босса предметы на ObjectSpawnPointO спавнит отдельная выделенная логика ниже в Step_0.gml
    var _is_boss_room_here = instance_exists(GameControllerO)
        && (GameControllerO.world_stage == "boss" || GameControllerO.world_stage == "w2_boss");
    if (!_is_boss_room_here) {
        var obj_spawn_points = [];
        with (ObjectSpawnPointO) { array_push(obj_spawn_points, id); }
        if (array_length(obj_spawn_points) > 0) {
            var max_possible_obj = min(max_objects, array_length(obj_spawn_points));
            var obj_count = irandom_range(min_objects, max_possible_obj);
            array_shuffle(obj_spawn_points);
            for (var i = 0; i < obj_count; i++) {
                var obj_spawn = obj_spawn_points[i];
                var obj_type = object_types[irandom(array_length(object_types) - 1)];
                instance_create_layer(obj_spawn.x, obj_spawn.y, "BulletsL", obj_type);
            }
        }
    }

    // принесённый объект с прошлого уровня — переносим ТОЛЬКО в настоящий уровень; если эта
    // комната — магазин, чилл или сундук, откладываем перенос до следующего полноценного уровня
    // (carried_object остаётся выставленным и просто ждёт там, где он реально нужен)
    var _in_level_room_here = instance_exists(GameControllerO) && (
        GameControllerO.world_stage == "levels1" || GameControllerO.world_stage == "levels2" || GameControllerO.world_stage == "levels3"
        || GameControllerO.world_stage == "w2_levels1" || GameControllerO.world_stage == "w2_levels2" || GameControllerO.world_stage == "w2_levels3"
    ) && room != GameControllerO.room_store && room != GameControllerO.room_chill && room != GameControllerO.room_chest;

    if (_in_level_room_here && GameControllerO.carried_object != noone && instance_exists(PlayerBallerO)) {
        var _angle = irandom(360);
        instance_create_layer(
            PlayerBallerO.x + lengthdir_x(30, _angle),
            PlayerBallerO.y + lengthdir_y(30, _angle),
            "BulletsL", HandPutObjectO
        );
    }

    GameControllerO.slow_mo(0.3, 0.4);
}

function spawn_inventory_items()
{
    if (!instance_exists(InventoryControllerO)) return;
    if (!instance_exists(PlayerBallerO)) return;
    
    var _items = InventoryControllerO.items;
    for (var i = 0; i < array_length(_items); i++) {
        var _item = _items[i];
        if (_item.type == "Heart") continue;
        if (_item.obj == noone) continue;
        
        var _angle = irandom(360);
        var _dist = 20 + i * 12;
        var _sx = PlayerBallerO.x + lengthdir_x(_dist, _angle);
        var _sy = PlayerBallerO.y + lengthdir_y(_dist, _angle);
        
        instance_create_layer(_sx, _sy, "BulletsL", _item.obj);
    }
}
//// debug: смена комнаты по N
//if (keyboard_check_pressed(ord("N"))) {
//    LevelControllerO.change_room();
//}
// плавное замедление всех объектов после завершения уровня
if (slowing_down) {
    var all_stopped = true;
    with (BulletBounceO) {
        if (speed > 0) {
            speed = lerp(speed, 0, 0.06);
            if (speed < 0.1) speed = 0;
        }
        if (speed > 0) all_stopped = false;
    }
    if (all_stopped) {
        slowing_down = false;
    }
}