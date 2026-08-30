store_open = false;
open_radius = 500;
items_gap = 16;

function shuffle_array_manual(_arr) {
    var _n = array_length(_arr);
    for (var i = _n - 1; i > 0; i--) {
        var j = irandom(i);
        var _tmp = _arr[i];
        _arr[i] = _arr[j];
        _arr[j] = _tmp;
    }
    return _arr;
}

// нельзя предлагать предмет, который у игрока уже есть — см. IsItemMaxedOutScr
// (кроме Birdie, можно иметь до 3х, и Placeholder 1 — чистый заполнитель)
function is_item_maxed_out(_name) {
    return IsItemMaxedOutScr(_name);
}

function generate_offers() {
    with (ItemBubbleStoreO) instance_destroy();

    var all_items = EveryItemScr();
    var spacing = 30;

    // уже купленные предметы в этой конкретной комнате магазина
    var _bought = [];
    if (instance_exists(GameControllerO)) {
        var _store_state = GameControllerO.get_current_room_state();
        if (_store_state != undefined) _bought = _store_state.store_bought;
    }

    // пытаемся восстановить ранее сгенерированный набор слотов
    var _saved_offers = undefined;
    if (instance_exists(GameControllerO)) {
        _saved_offers = GameControllerO.get_store_offers();
    }

    if (_saved_offers != undefined && array_length(_saved_offers) > 0) {
        var count = array_length(_saved_offers);
        var start_x = x - (count - 1) * spacing * 0.5;
        for (var i = 0; i < count; i++) {
            var _name = _saved_offers[i];
            if (_name == "") continue;
            if (array_contains(_bought, _name)) continue;
            if (is_item_maxed_out(_name)) continue;

            for (var j = 0; j < array_length(all_items); j++) {
                if (all_items[j].name == _name) {
                    var b = instance_create_layer(start_x + i * spacing, y, layer, ItemBubbleStoreO);
                    b.item = all_items[j];
                    break;
                }
            }
        }
        return;
    }

    // первая генерация для этой комнаты
    // предметы, которые у игрока уже есть в инвентаре, повторно в магазине не предлагаем
    var buy_pool = [];
    for (var i = 0; i < array_length(all_items); i++) {
        var _it = all_items[i];
        if (_it.type == "Item" && !array_contains(_bought, _it.name) && !is_item_maxed_out(_it.name)) {
            array_push(buy_pool, _it);
        }
    }
    buy_pool = shuffle_array_manual(buy_pool);
    var item_count = min(3, array_length(buy_pool));

    var _slot_items = [];
    for (var i = 0; i < item_count; i++) {
        array_push(_slot_items, buy_pool[i]);
    }

    // не хватило непроданных предметов на все слоты — добираем сердечками/плейсхолдером,
    // они не подчиняются правилу "один такой предмет в инвентаре" и всегда доступны как заполнитель
    var _missing_slots = 3 - item_count;
    if (_missing_slots > 0) {
        var _filler_placeholder = undefined;
        var _filler_heart = undefined;
        for (var i = 0; i < array_length(all_items); i++) {
            if (all_items[i].name == "Placeholder 1") _filler_placeholder = all_items[i];
            if (all_items[i].type == "Heart") _filler_heart = all_items[i];
        }
        var _filler = (_filler_placeholder != undefined) ? _filler_placeholder : _filler_heart;
        if (_filler != undefined) {
            for (var i = 0; i < _missing_slots; i++) {
                array_push(_slot_items, _filler);
            }
        }
    }

    for (var i = 0; i < array_length(all_items); i++) {
        if (all_items[i].type == "Heart" && !array_contains(_bought, all_items[i].name)) {
            array_push(_slot_items, all_items[i]);
            break;
        }
    }

    // ручной шафл всего набора слотов — гарантированно рандомные позиции
    _slot_items = shuffle_array_manual(_slot_items);

    var count = array_length(_slot_items);
    var start_x = x - (count - 1) * spacing * 0.5;
    var _offer_names = [];

    for (var i = 0; i < count; i++) {
        var b = instance_create_layer(start_x + i * spacing, y, layer, ItemBubbleStoreO);
        b.item = _slot_items[i];
        array_push(_offer_names, _slot_items[i].name);
    }

    if (instance_exists(GameControllerO)) {
        GameControllerO.mark_store_offers(_offer_names);
    }
}