powerups = [];
spawned_objects = [];

function add_powerup(_item_data) {
    for (var i = 0; i < array_length(powerups); i++) {
        if (powerups[i].name == _item_data.name) {
            show_debug_message("Already have powerup: " + _item_data.name);
            return false;
        }
    }
    array_push(powerups, _item_data);
    // спавним объект паверапа
    if (variable_struct_exists(_item_data, "powerup_obj") && _item_data.powerup_obj != noone) {
        var _inst = instance_create_layer(0, 0, "CodingStuffL", _item_data.powerup_obj);
        array_push(spawned_objects, _inst);
        show_debug_message("PowerUp spawned: " + _item_data.name);
    }
    show_debug_message("PowerUp added: " + _item_data.name);
    return true;
}

function has_powerup(_name) {
    for (var i = 0; i < array_length(powerups); i++) {
        if (powerups[i].name == _name) return true;
    }
    return false;
}

function remove_powerup(_name) {
    for (var i = 0; i < array_length(powerups); i++) {
        if (powerups[i].name == _name) {
            array_delete(powerups, i, 1);
            return true;
        }
    }
    return false;
}