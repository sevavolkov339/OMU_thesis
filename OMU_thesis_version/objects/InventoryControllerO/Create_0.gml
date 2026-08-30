//items = []; // массив предметов игрока

//function add_item(_item_data) {
//    // если type == "Ball" — только один такой предмет
//    if (_item_data.type == "Ball") {
//        for (var i = 0; i < array_length(items); i++) {
//            if (items[i].type == "Ball") {
//                show_debug_message("Already have a Ball item!");
//                return false;
//            }
//        }
//    }
//    array_push(items, _item_data);
//    return true;
//}

//function has_item(_name) {
//    for (var i = 0; i < array_length(items); i++) {
//        if (items[i].name == _name) return true;
//    }
//    return false;
//}

//function remove_item(_name) {
//    for (var i = 0; i < array_length(items); i++) {
//        if (items[i].name == _name) {
//            array_delete(items, i, 1);
//            return true;
//        }
//    }
//    return false;
//}

items = [];

function add_item(_item_data) {
    // если type == "Ball" — только один такой предмет
    if (_item_data.type == "Ball") {
        for (var i = 0; i < array_length(items); i++) {
            if (items[i].type == "Ball") {
                show_debug_message("Already have a Ball item!");
                return false;
            }
        }
    }
    array_push(items, _item_data);

    // счётчик комнат до урона от сигареты начинается со следующей комнаты после получения предмета
    if (_item_data.name == "Cigarette" && instance_exists(GameControllerO)) {
        GameControllerO.cigarette_rooms_since_pickup = 0;
    }

    // счётчик комнат до исчезновения пива начинается со следующей комнаты после получения предмета
    if (_item_data.name == "Beer" && instance_exists(GameControllerO)) {
        GameControllerO.beer_rooms_since_pickup = 0;
    }

    return true;
}

function has_item(_name) {
    for (var i = 0; i < array_length(items); i++) {
        if (items[i].name == _name) return true;
    }
    return false;
}

function count_item(_name) {
    var _count = 0;
    for (var i = 0; i < array_length(items); i++) {
        if (items[i].name == _name) _count++;
    }
    return _count;
}

function remove_item(_name) {
    for (var i = 0; i < array_length(items); i++) {
        if (items[i].name == _name) {
            // уничтожаем объект в игре если он существует
            var _item = items[i];
            if (variable_struct_exists(_item, "obj") && _item.obj != noone && instance_exists(_item.obj)) {
                instance_destroy(_item.obj);
            }
            // также ищем объект по типу если obj не задан
            // например BalloonO для предмета Balloon
            var _obj_name = _name + "O";
            var _obj_asset = asset_get_index(_obj_name);
            if (_obj_asset >= 0 && instance_exists(_obj_asset)) {
                with (_obj_asset) {
                    instance_destroy();
                }
            }
            array_delete(items, i, 1);
            return true;
        }
    }
    return false;
}