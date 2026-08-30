//important global variables

if (!variable_global_exists("pending_inventory_names")) global.pending_inventory_names = undefined;
if (!variable_global_exists("pending_powerup_names")) global.pending_powerup_names = undefined;
if (!variable_global_exists("pending_room_name")) global.pending_room_name = undefined;


randomise();


// обрезает прохождение мира 2 сразу после сегмента w2_levels1 и переключает
// на комнату World_1_WIPRoom (там текст от разработчика и благодарность за игру).
// чтобы вернуть обычную структуру мира — просто поставь false.
demo_cut_after_world_2_1 = true;

//game pause
game_paused = false;
function toggle_pause()
{
    game_paused = !game_paused;
    if (game_paused)
    {
        pause_lowpass_filter = audio_effect_create(AudioEffectType.LPF2);
        pause_lowpass_filter.cutoff = 500;
        pause_lowpass_filter.q = 1;
        audio_bus_main.effects[0] = pause_lowpass_filter;
    }
    else
    {
        audio_bus_main.effects[0] = undefined;
        pause_lowpass_filter = -1;
    }
}

//game saving system


save_slot = -1; // -1 = новая игра без слота, 0/1/2 = выбранный слот

function get_save_path(_slot) {
    return "save_" + string(_slot) + ".json";
}

function save_exists(_slot) {
    return file_exists(get_save_path(_slot));
}

//function save_game() {
//    if (save_slot < 0) return; // нет выбранного слота — не сохраняем

//    var _inv_data = [];
//    if (instance_exists(InventoryControllerO)) {
//        var _inv = InventoryControllerO.items;
//        for (var i = 0; i < array_length(_inv); i++) {
//            array_push(_inv_data, _inv[i].name);
//        }
//    }

//    var _powerup_data = [];
//    if (instance_exists(PowerUpControllerO)) {
//        var _pw = PowerUpControllerO.powerups;
//        for (var i = 0; i < array_length(_pw); i++) {
//            array_push(_powerup_data, _pw[i].name);
//        }
//    }

//    var _save_struct = {
//        player_hp: player_hp,
//        player_max_hp: player_max_hp,
//        player_money: player_money,
//        levels_completed: levels_completed,
//        run_time: run_time,
//        current_world_index: current_world_index,
//        route: route,
//        route_index: route_index,
//        inventory_names: _inv_data,
//        powerup_names: _powerup_data,
//        current_room_name: room_get_name(room)
//    };

//    var _json = json_stringify(_save_struct);
//    var _file = file_text_open_write(get_save_path(save_slot));
//    file_text_write_string(_file, _json);
//    file_text_close(_file);

//    show_debug_message("Game saved to slot " + string(save_slot));
//}

function save_game(_dest_room_asset) {
    if (save_slot < 0) return;

    if (is_undefined(_dest_room_asset)) {
        capture_current_room_state();
    }

    var _inv_data = [];
    if (instance_exists(InventoryControllerO)) {
        var _inv = InventoryControllerO.items;
        for (var i = 0; i < array_length(_inv); i++) {
            array_push(_inv_data, _inv[i].name);
        }
    }
    var _powerup_data = [];
    if (instance_exists(PowerUpControllerO)) {
        var _pw = PowerUpControllerO.powerups;
        for (var i = 0; i < array_length(_pw); i++) {
            array_push(_powerup_data, _pw[i].name);
        }
    }

    var _curr_room_name = is_undefined(_dest_room_asset)
        ? room_get_name(room)
        : room_get_name(_dest_room_asset);

    var _carried_object_name = (carried_object == noone) ? "" : object_get_name(carried_object);

    var _save_struct = {
        player_hp:           player_hp,
        player_max_hp:       player_max_hp,
        player_money:        player_money,
        levels_completed:    levels_completed,
        run_time:            run_time,
        current_world_index: current_world_index,
        route:               route,
        route_index:         route_index,
        inventory_names:     _inv_data,
        powerup_names:       _powerup_data,
        current_room_name:   _curr_room_name,
        carried_object_name: _carried_object_name,
        room_states:         room_states,
        saved_balloon_hits:  saved_balloon_hits,
        world_stage:         world_stage,
        cigarette_rooms_since_pickup: cigarette_rooms_since_pickup,
        beer_rooms_since_pickup: beer_rooms_since_pickup
    };

    var _json = json_stringify(_save_struct);
    var _file = file_text_open_write(get_save_path(save_slot));
    file_text_write_string(_file, _json);
    file_text_close(_file);
    show_debug_message("Game saved to slot " + string(save_slot));
}


//function load_game(_slot) {
//    if (!save_exists(_slot)) return false;

//    var _file = file_text_open_read(get_save_path( _slot));
//    var _json = "";
//    while (!file_text_eof(_file)) {
//        _json += file_text_read_string(_file);
//        file_text_readln(_file);
//    }
//    file_text_close(_file);

//    var _data = json_parse(_json);

//    save_slot = _slot;
//    player_hp = _data.player_hp;
//    player_max_hp = _data.player_max_hp;
//    player_money = _data.player_money;
//    levels_completed = _data.levels_completed;
//    run_time = _data.run_time;
//    current_world_index = _data.current_world_index;
//    route = _data.route;
//    route_index = _data.route_index;

//    // сохраняем для применения после смены комнаты (инвентарь/повер-апы создаются позже)
//    global.pending_inventory_names = _data.inventory_names;
//    global.pending_powerup_names = _data.powerup_names;
//    global.pending_room_name = _data.current_room_name;

//    return true;
//}


function load_game(_slot) {
    if (!save_exists(_slot)) return false;

    var _file = file_text_open_read(get_save_path(_slot));
    var _json = "";
    while (!file_text_eof(_file)) {
        _json += file_text_read_string(_file);
        file_text_readln(_file);
    }
    file_text_close(_file);

    var _data = json_parse(_json);

    save_slot            = _slot;
    player_hp            = _data.player_hp;
    player_max_hp        = _data.player_max_hp;
    player_money         = _data.player_money;
    levels_completed     = _data.levels_completed;
    run_time             = _data.run_time;
    current_world_index  = _data.current_world_index;
    route                = _data.route;
    route_index          = _data.route_index;
    saved_balloon_hits    = variable_struct_exists(_data, "saved_balloon_hits") ? _data.saved_balloon_hits : 0;
    world_stage           = variable_struct_exists(_data, "world_stage") ? _data.world_stage : "levels1";
    cigarette_rooms_since_pickup = variable_struct_exists(_data, "cigarette_rooms_since_pickup") ? _data.cigarette_rooms_since_pickup : 0;
    beer_rooms_since_pickup = variable_struct_exists(_data, "beer_rooms_since_pickup") ? _data.beer_rooms_since_pickup : 0;
    pending_room_change = noone;
    pending_room_change_timer = 0;
    level_music_suppressed = false;

    // фикс типов route после json_parse
    for (var i = 0; i < array_length(route); i++) {
        route[i] = round(real(route[i]));
    }

    // восстанавливаем состояния комнат
    room_states = variable_struct_exists(_data, "room_states") ? _data.room_states : {};

    carried_object = noone;
    if (variable_struct_exists(_data, "carried_object_name") && _data.carried_object_name != "") {
        var _carried_asset = asset_get_index(_data.carried_object_name);
        if (_carried_asset >= 0) carried_object = _carried_asset;
    }

    clear_loaded_run_controllers();

    global.pending_inventory_names = variable_struct_exists(_data, "inventory_names") ? _data.inventory_names : [];
    global.pending_powerup_names   = variable_struct_exists(_data, "powerup_names") ? _data.powerup_names : [];
    global.pending_room_name       = _data.current_room_name;

    return true;
}

function clear_loaded_run_controllers() {
    if (instance_exists(InventoryControllerO)) {
        InventoryControllerO.items = [];
    }

    if (instance_exists(PowerUpControllerO)) {
        for (var i = 0; i < array_length(PowerUpControllerO.spawned_objects); i++) {
            if (instance_exists(PowerUpControllerO.spawned_objects[i])) {
                instance_destroy(PowerUpControllerO.spawned_objects[i]);
            }
        }
        PowerUpControllerO.powerups = [];
        PowerUpControllerO.spawned_objects = [];
    }
}

function delete_save(_slot) {
    if (save_exists(_slot)) {
        file_delete(get_save_path(_slot));
    }
}

function apply_pending_inventory_and_powerups() {
    if (!is_undefined(global.pending_inventory_names) || !is_undefined(global.pending_powerup_names)) {
        clear_loaded_run_controllers();
    }

    if (!is_undefined(global.pending_inventory_names) && instance_exists(InventoryControllerO)) {
        var _all_items = EveryItemScr();
        for (var i = 0; i < array_length(global.pending_inventory_names); i++) {
            var _name = global.pending_inventory_names[i];
            for (var j = 0; j < array_length(_all_items); j++) {
                if (_all_items[j].name == _name) {
                    InventoryControllerO.add_item(_all_items[j]);
                    break;
                }
            }
        }
        global.pending_inventory_names = undefined;
    }
    if (!is_undefined(global.pending_powerup_names) && instance_exists(PowerUpControllerO)) {
        var _all_items2 = EveryItemScr();
        for (var i = 0; i < array_length(global.pending_powerup_names); i++) {
            var _name = global.pending_powerup_names[i];
            for (var j = 0; j < array_length(_all_items2); j++) {
                if (_all_items2[j].name == _name) {
                    PowerUpControllerO.add_powerup(_all_items2[j]);
                    break;
                }
            }
        }
        global.pending_powerup_names = undefined;
    }
}

// Player stats


player_hp = 6;
player_max_hp = 10;
player_money = 1000;

//for close friends test:

//player_hp = 4;
//player_max_hp = 10;
//player_money = 0;

//combo
saved_combo = 0;
saved_combo_bar = 0;

//levels
levels_completed = 0;
shop_every_n_levels = 4;

//balloon item — сколько ударов уже поглощено, сохраняется между комнатами
saved_balloon_hits = 0;

//сигарета — на следующем реально начавшемся уровне нужно нанести отложенный урон
//(флаг разбирается LevelControllerO той самой комнаты, поэтому урон не может "утечь" в другую комнату)
cigarette_pending_hit = false;
//сигарета — считает уровни с момента получения предмета (а не глобальный levels_completed),
//иначе урон срабатывает в случайный момент относительно подбора предмета
cigarette_rooms_since_pickup = 0;

//пиво — держится 3 реальных уровня с момента получения предмета, потом пропадает из инвентаря
beer_rooms_since_pickup = 0;

//time of walkthrough
run_time = 0;

//transitions
coming_from_transition = false;

//text
TranslationScr()

//slow mo
time_scale = 1.0;
slow_mo_timer = 0;
original_speed = game_get_speed(gamespeed_fps);
function slow_mo(_scale, _seconds) {
    time_scale = _scale;
    slow_mo_timer = _seconds;
    game_set_speed(original_speed * _scale, gamespeed_fps);
}

//music controller
pause_lowpass_filter = -1;
store_music = -1;
prev_music = -1;
prev_music_asset = -1;
prev_music_pitch = 1.0;
in_store = false;
in_chestroom = false;
current_music = -1;
current_music_asset = -1;
current_music_pitch = 1.0;
music_pitch_override = false;

//chill room music
in_chillroom = false;
chillroom_bells = -1;
chillroom_ambient = -1;
chillroom_water = -1;

//white transition room sound
in_transition = false;
transition_music = -1;

//carrying obj
carried_object = noone;

function music_play(_track) {
    if (current_music_asset == _track) exit;
    if (audio_exists(current_music)) audio_stop_sound(current_music);
    current_music = audio_play_sound(_track, 10, true);
    current_music_asset = _track;
    current_music_pitch = 1.0;
    music_pitch_override = true;
}
function music_stop() {
    if (audio_exists(current_music)) {
        audio_sound_pitch(current_music, 1.0);
        audio_stop_sound(current_music);
    }
    current_music = -1;
    current_music_asset = -1;
    current_music_pitch = 1.0;
}
// World_1_Test_Track запускается только во время реальных боевых уровней — см. Step_0.gml

// маршрут
store_bubble_desc_owner = noone;
// старые пулы комнат (мир 0/1/2) — оставлены для совместимости со старыми сохранениями,
// но новая система прогрессии (world_stage) их больше не использует напрямую
world_0_rooms = [
    World_1_Room_1
];
world_1_rooms = [World_1_WIPRoom];
world_2_rooms = [];
worlds_rooms = [
    World_1_Room_1,
    World_1_Room_1,
    World_1_Room_1,
];
room_store = World_1_Room_1;
room_chest = World_1_Room_1;
room_chill = World_1_Room_1;
boss_rooms = [
    World_1_Boss_Room_Fly
];
room_boss = boss_rooms[irandom(array_length(boss_rooms) - 1)];
current_world_index = 0;
route = [];
route_index = 0;

// новые пулы комнат по сегментам мира 1 (заполняются вручную в редакторе)
world_1_1_rooms = [
	World_1_Room_1

];
world_1_2_rooms = [
	World_1_Room_1

];
world_1_3_rooms = [
	World_1_Room_1
];

// комнаты магазина/сундука/чилла для мира 1: [0]=магазин, [1]=чилл, [2]=сундук
world_1_other_rooms = [World_1_Room_1];

// пулы комнат по сегментам мира 2 (заполняются вручную в редакторе)
world_2_1_rooms = [

World_2_Room_1, 
World_2_Room_2,
World_2_Room_3

];
world_2_2_rooms = [World_2_Room_1];
world_2_3_rooms = [World_2_Room_1];

// комнаты магазина/сундука/чилла для мира 2: [0]=магазин, [1]=чилл, [2]=сундук
world_2_other_rooms = [World_2_Store, World_2_ChillRoom, World_2_ChestRoom];

// комнаты босса мира 2
world_2_boss_rooms = [
    World_2_Boss_Room_Snow
];

// текущий этап прогрессии мира:
// "title1" -> "intro" (World_1_Room_0) -> "levels1" -> "title2" -> "levels2" -> "title3" -> "levels3" -> "title4" -> "boss"
// -> "w2_title1" -> "w2_levels1" -> "w2_title2" -> "w2_levels2" -> "w2_title3" -> "w2_levels3" -> "w2_title4" -> "w2_boss"
world_stage = "title1";

// отложенный переход в комнату (используется после последней двери сегмента уровней —
// музыка обрывается сразу, а сама смена комнаты происходит через pending_room_change_timer шагов)
pending_room_change = noone;
pending_room_change_timer = 0;

// true с момента входа в последнюю дверь сегмента и до старта следующего сегмента —
// не даёт авто-логике музыки уровней (в Step_0) тут же перезапустить трек обратно после music_stop()
level_music_suppressed = false;

function generate_segment_route(_pool) {
    // ровно 10 комнат: 7 боевых + 1 магазин + 1 сундук + 1 чилл, магазин/сундук/чилл на случайных позициях
    var _total = 10;
    var _slot_types = array_create(_total, "combat");

    // позиции магазина/сундука/чилла: никогда не первая комната (позиция 0),
    // и минимум 1 обычный уровень между любыми двумя из них
    var _special_positions = [];
    var _sp_attempts = 0;
    while (array_length(_special_positions) < 3 && _sp_attempts < 1000) {
        _sp_attempts++;
        var _p = irandom_range(1, _total - 1);
        var _valid = true;
        for (var _si = 0; _si < array_length(_special_positions); _si++) {
            if (abs(_p - _special_positions[_si]) < 2) {
                _valid = false;
                break;
            }
        }
        if (_valid) {
            array_push(_special_positions, _p);
        }
    }
    // запасной вариант на случай, если случайный подбор не уложился в лимит попыток
    if (array_length(_special_positions) < 3) {
        _special_positions = [2, 5, 8];
    }
    _slot_types[_special_positions[0]] = "store";
    _slot_types[_special_positions[1]] = "chest";
    _slot_types[_special_positions[2]] = "chill";

    var _final = [];
    var _last_room = -1;
    for (var _i = 0; _i < _total; _i++) {
        switch (_slot_types[_i]) {
            case "store":
                array_push(_final, room_store);
                _last_room = room_store;
            break;
            case "chest":
                array_push(_final, room_chest);
                _last_room = room_chest;
            break;
            case "chill":
                array_push(_final, room_chill);
                _last_room = room_chill;
            break;
            default:
                var _next_room = _last_room;
                var _attempts = 0;
                while (_next_room == _last_room && _attempts < 100) {
                    _next_room = _pool[irandom(array_length(_pool) - 1)];
                    _attempts++;
                }
                array_push(_final, _next_room);
                _last_room = _next_room;
        }
    }

    show_debug_message("=== SEGMENT ROUTE GENERATED ===");
    for (var _i = 0; _i < array_length(_final); _i++) {
        show_debug_message(string(_i) + ": " + room_get_name(_final[_i]));
    }
    return _final;
}

// генерирует маршрут сегмента из указанного пула и сразу переходит в первую комнату.
// _other_rooms — список [магазин, чилл, сундук] для текущего мира
function start_levels_segment(_pool, _other_rooms) {
    level_music_suppressed = false;
    if (array_length(_other_rooms) >= 3) {
        room_store = _other_rooms[0];
        room_chill = _other_rooms[1];
        room_chest = _other_rooms[2];
    }
    route = generate_segment_route(_pool);
    route_index = 0;

    var _first = route[route_index];
    route_index++;

    if (_first != room_store && _first != room_chest && _first != room_chill) {
        levels_completed++;
        show_debug_message("Levels completed: " + string(levels_completed));
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Cigarette")) {
            cigarette_rooms_since_pickup++;
            if (cigarette_rooms_since_pickup >= 5) {
                cigarette_rooms_since_pickup = 0;
                cigarette_pending_hit = true;
            }
        }
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) {
            beer_rooms_since_pickup++;
            if (beer_rooms_since_pickup >= 3) {
                beer_rooms_since_pickup = 0;
                InventoryControllerO.remove_item("Beer");
            }
        }
    }

    if (save_slot >= 0) {
        save_game(_first);
    }

    room_goto(_first);
}

// true, если игрок сейчас стоит в последней комнате текущего сегмента уровней
// (используется DoorO, чтобы пропустить обычную анимацию входа в дверь для этого случая)
function is_segment_final_door() {
    var _in_any_levels = (world_stage == "levels1" || world_stage == "levels2" || world_stage == "levels3"
        || world_stage == "w2_levels1" || world_stage == "w2_levels2" || world_stage == "w2_levels3");
    return _in_any_levels && route_index >= array_length(route);
}

// последняя дверь сегмента уровней пройдена — музыка обрывается сразу,
// а сама смена комнаты (на следующий титульный экран) происходит через 2 секунды
function advance_to_next_title() {
    music_stop();

    var _dest_room = noone;
    switch (world_stage) {
        case "levels1":
            world_stage = "title2";
            _dest_room = World_1_Title_2_Room;
        break;
        case "levels2":
            world_stage = "title3";
            _dest_room = World_1_Title_3_Room;
        break;
        case "levels3":
            world_stage = "title4";
            _dest_room = World_1_Title_4_Room;
        break;
        case "w2_levels1":
            // ВРЕМЕННО (демо): обрубаем мир 2 здесь и уводим на WIP-экран вместо обычного продолжения.
            // чтобы откатить — см. demo_cut_after_world_2_1 в начале Create_0.
            if (demo_cut_after_world_2_1) {
                world_stage = "demo_end";
                _dest_room = World_1_WIPRoom;
            } else {
                world_stage = "w2_title2";
                _dest_room = World_2_Title_2_Room;
            }
        break;
        case "w2_levels2":
            world_stage = "w2_title3";
            _dest_room = World_2_Title_3_Room;
        break;
        case "w2_levels3":
            world_stage = "w2_title4";
            _dest_room = World_2_Title_4_Room;
        break;
    }

    if (save_slot >= 0) {
        save_game(_dest_room);
    }

    pending_room_change = _dest_room;
    pending_room_change_timer = round(room_speed * 2);
}

// вызывается объектом титульного экрана (World_1_Title_N_O), когда текст дописан и прошли ещё 3 секунды
function title_finished() {
    switch (world_stage) {
        case "title1":
            world_stage = "intro";
            room_goto(World_1_Room_1);
        break;
        case "title2":
            world_stage = "levels2";
            start_levels_segment(world_1_2_rooms, world_1_other_rooms);
        break;
        case "title3":
            world_stage = "levels3";
            start_levels_segment(world_1_3_rooms, world_1_other_rooms);
        break;
        case "title4":
            world_stage = "boss";
            room_boss = boss_rooms[irandom(array_length(boss_rooms) - 1)];
            room_goto(room_boss);
        break;

        case "w2_title1":
            world_stage = "w2_levels1";
            start_levels_segment(world_2_1_rooms, world_2_other_rooms);
        break;
        case "w2_title2":
            world_stage = "w2_levels2";
            start_levels_segment(world_2_2_rooms, world_2_other_rooms);
        break;
        case "w2_title3":
            world_stage = "w2_levels3";
            start_levels_segment(world_2_3_rooms, world_2_other_rooms);
        break;
        case "w2_title4":
            world_stage = "w2_boss";
            room_boss = world_2_boss_rooms[irandom(array_length(world_2_boss_rooms) - 1)];
            room_goto(room_boss);
        break;
    }
}

function change_room() {
    // сохраняем состояние текущей комнаты перед уходом
    capture_current_room_state();

    // вышли из фиксированной комнаты-якоря (World_1_Room_0) — стартуем первый сегмент уровней
    if (world_stage == "intro") {
        world_stage = "levels1";
        start_levels_segment(world_1_1_rooms, world_1_other_rooms);
        return;
    }

    // мир 1 пройден (босс побеждён, игрок выбрал power-up в TransitionRoom) — начинаем мир 2
    if (world_stage == "boss") {
        world_stage = "w2_title1";
        room_goto(World_2_Title_1_Room);
        return;
    }

    // ВРЕМЕННО (демо): дошли до обрубленного конца — route уже закончился, дальше по нему
    // идти нельзя (обращение за границу массива). Просто остаёмся в WIP-комнате.
    if (world_stage == "demo_end") {
        room_goto(World_1_WIPRoom);
        return;
    }

    // пройдена последняя дверь текущего сегмента уровней — переходим к следующему титульному экрану
    // (обычно DoorO перехватывает этот случай раньше и сюда даже не доходит — см. is_segment_final_door())
    if (is_segment_final_door()) {
        advance_to_next_title();
        return;
    }

    var _next = route[route_index];
    route_index++;

    if (_next != room_store && _next != room_chest && _next != room_chill) {
        levels_completed++;
        show_debug_message("Levels completed: " + string(levels_completed));

        // сигарета: каждые 5 пройденных уровней с момента получения предмета -1 хп
        // (наносится через 1.5 сек после старта этого уровня)
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Cigarette")) {
            cigarette_rooms_since_pickup++;
            if (cigarette_rooms_since_pickup >= 5) {
                cigarette_rooms_since_pickup = 0;
                cigarette_pending_hit = true;
            }
        }

        // пиво: держится 3 пройденных уровня с момента получения предмета, потом пропадает
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) {
            beer_rooms_since_pickup++;
            if (beer_rooms_since_pickup >= 3) {
                beer_rooms_since_pickup = 0;
                InventoryControllerO.remove_item("Beer");
            }
        }
    }

    var _next_key = world_stage + "_r_" + string(route_index - 1);
    if (variable_struct_exists(room_states, _next_key)) {
        var _next_state = room_states[$ _next_key];
        if (variable_struct_exists(_next_state, "room_name") && _next_state.room_name != room_get_name(_next)) {
            variable_struct_remove(room_states, _next_key);
        }
    }

    // автосохранение с новой комнатой как текущей
    if (save_slot >= 0) {
        save_game(_next);
    }

    coming_from_transition = (room == World_1_TransitionRoom);
    room_goto(_next);
}

// saves and runs
total_flowers = 0;

run_active = false; // тикает только когда реально играем в загруженном/новом ране

function reset_run() {
    //player_hp = 6;
    //player_max_hp = 10;
	//player_money = 1000;
	
	//for close friends test:
	
	player_hp = 3;
    player_max_hp = 100;
	player_money = 0;
	
    saved_combo = 0;
    saved_combo_bar = 0;
    levels_completed = 0;
    saved_balloon_hits = 0;
    cigarette_pending_hit = false;
    cigarette_rooms_since_pickup = 0;
    beer_rooms_since_pickup = 0;
    carried_object = noone;
    run_time = 0;
    current_world_index = 0;
    world_stage = "title1";
    route = [];
    route_index = 0;
    pending_room_change = noone;
    pending_room_change_timer = 0;
    level_music_suppressed = false;
    room_states = {}; // очищаем старые состояния комнат
    global.pending_inventory_names = undefined;
    global.pending_powerup_names = undefined;
    global.pending_room_name = undefined;

    // очищаем инвентарь и повер-апы старого рана
    clear_loaded_run_controllers();
}

function go_to_death_screen() {
    room_goto(Death_Room);
}



// room state tracking (ключ по позиции в маршруте, не по имени комнаты)
room_states = {};

function get_current_route_key() {
    // world_stage в ключе — иначе комнаты разных сегментов уровней (у каждого своя нумерация 0..9)
    // делили бы один и тот же room_states-ключ ("r_0", "r_1"...)
    return world_stage + "_r_" + string(route_index - 1);
}

function ensure_room_state() {
    var _key = get_current_route_key();
    if (!variable_struct_exists(room_states, _key)) {
        room_states[$ _key] = {
            room_name: room_get_name(room),
            has_enemy_data: false,
            level_completed: false,
            object_carried: false,
            door_x: -1,
            door_y: -1,
            enemies: [],
            items_on_floor: [],
            objects_on_floor: [],
            store_bought: [],
            chill_healed: false,
            chest_opened: false
        };
    }
    return room_states[$ _key];
}

function get_current_room_state() {
    var _key = get_current_route_key();
    if (variable_struct_exists(room_states, _key)) {
        return room_states[$ _key];
    }
    return undefined;
}

function get_room_state_for(_key) {
    if (variable_struct_exists(room_states, _key)) {
        return room_states[$ _key];
    }
    return undefined;
}

function capture_current_room_state() {
    // не сохраняем состояние меню или экрана смерти
    if (route_index <= 0) return;
    if (room == Main_Menu_Room || room == Death_Room) return;

    var _state = ensure_room_state();
    _state.room_name = room_get_name(room);
    _state.level_completed = instance_exists(LevelControllerO) && LevelControllerO.level_completed;
    _state.has_enemy_data = true;
    _state.enemies = [];

    var _enemy_types_to_save = [EnemyFlowerO, EnemyFlyO, EnemyJawO, EnemySpitterO];
    for (var _t = 0; _t < array_length(_enemy_types_to_save); _t++) {
        var _etype = _enemy_types_to_save[_t];
        var _count = instance_number(_etype);
        for (var _ei = 0; _ei < _count; _ei++) {
            var _inst = instance_find(_etype, _ei);
            array_push(_state.enemies, {
                obj_name: object_get_name(_inst.object_index),
                ex: _inst.x, ey: _inst.y,
                ehp: variable_instance_exists(_inst, "hp") ? _inst.hp : 1
            });
        }
    }

    _state.objects_on_floor = [];
    var _obj_types_to_save = [OldTvO, RockO, TrashCanO, ShurikenO, BombO, ShotgunO, BumerangO];
    for (var _t = 0; _t < array_length(_obj_types_to_save); _t++) {
        var _otype = _obj_types_to_save[_t];
        var _count = instance_number(_otype);
        for (var _oi = 0; _oi < _count; _oi++) {
            var _inst = instance_find(_otype, _oi);
            array_push(_state.objects_on_floor, {
                obj_name: object_get_name(_inst.object_index),
                ox: _inst.x, oy: _inst.y
            });
        }
    }

    _state.items_on_floor = [];
    var _bubble_count = instance_number(ItemBubbleO);
    for (var _bi = 0; _bi < _bubble_count; _bi++) {
        var _b = instance_find(ItemBubbleO, _bi);
        if (!_b.popped && _b.item != noone) {
            var _from_inv = instance_exists(InventoryControllerO) && InventoryControllerO.has_item(_b.item.name);
            if (!_from_inv) {
                array_push(_state.items_on_floor, {
                    item_name: _b.item.name,
                    ix: _b.x, iy: _b.y
                });
            }
        }
    }
}

function save_door_position(_dx, _dy) {
    var _state = ensure_room_state();
    _state.door_x = _dx;
    _state.door_y = _dy;
}

function mark_object_carried() {
    var _state = ensure_room_state();
    _state.object_carried = true;
}

function mark_chill_healed() {
    ensure_room_state().chill_healed = true;
}

function mark_chest_opened() {
    ensure_room_state().chest_opened = true;
}

function mark_store_item_bought(_name) {
    var _state = ensure_room_state();
    if (!array_contains(_state.store_bought, _name)) {
        array_push(_state.store_bought, _name);
    }
}

function mark_store_offers(_names) {
    var _state = ensure_room_state();
    _state.store_offers = _names;
}

function get_store_offers() {
    var _state = get_current_room_state();
    if (_state != undefined && variable_struct_exists(_state, "store_offers")) {
        return _state.store_offers;
    }
    return undefined;
}