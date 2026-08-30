if (GameControllerO.game_paused) exit;

function open_box() {
    opened = true;
	if (instance_exists(GameControllerO)) {
	    GameControllerO.mark_chest_opened();
	}	
    image_index = 1;
    image_speed = 0;
    squash_x_speed += 0.8;
    squash_y_speed -= 0.8;
    var all_items_raw = EveryItemScr();
    var all_items = [];
    for (var _i = 0; _i < array_length(all_items_raw); _i++) {
        var _it = all_items_raw[_i];
        if (_it.type == "Heart") {
            array_push(all_items, _it);
        } else if (_it.type == "Item") {
            // предметы, которые у игрока уже есть в инвентаре, из сундука не выпадают
            var _already_owned = instance_exists(InventoryControllerO) && InventoryControllerO.has_item(_it.name);
            if (!_already_owned) {
                array_push(all_items, _it);
            }
        }
    }

    var won_item;
    if (array_length(all_items) > 0) {
        won_item = all_items[irandom(array_length(all_items) - 1)];
    } else {
        // все предметы уже есть в инвентаре — вместо них выпадает заполнитель
        var _filler_placeholder = undefined;
        var _filler_heart = undefined;
        for (var _i = 0; _i < array_length(all_items_raw); _i++) {
            if (all_items_raw[_i].name == "Placeholder 1") _filler_placeholder = all_items_raw[_i];
            if (all_items_raw[_i].type == "Heart") _filler_heart = all_items_raw[_i];
        }
        won_item = (_filler_placeholder != undefined) ? _filler_placeholder : _filler_heart;
    }
    var _bubble = instance_create_layer(x, y + 10, "ItemsL", ItemBubbleO);
    _bubble.item = won_item;
    _bubble.vel_y = 5;
}

// пинок — лкм или геймпад
var _gp = instance_exists(PlayerBallerO) ? PlayerBallerO.gamepad_index : 0;
var _kick_pressed = mouse_check_button_pressed(mb_left) || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_shoulderr));
if (_kick_pressed && instance_exists(PlayerBallerO)) {
    var _dist = point_distance(PlayerBallerO.x, PlayerBallerO.y, x, y);
    if (_dist < 40) {
        var kick_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, x, y);
        vel_x += lengthdir_x(4, kick_dir);
        vel_y += lengthdir_y(4, kick_dir);
        if (!opened) {
            kick_cooldown = 10;
            open_box();
        }
    }
}

// касание игрока
if (instance_exists(PlayerBallerO)) {
    if (place_meeting(x, y, PlayerBallerO) && !opened) {
        if (!was_touching_player) {
            var push_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, x, y);
            vel_x += lengthdir_x(3, push_dir);
            vel_y += lengthdir_y(3, push_dir);
            open_box();
        }
        was_touching_player = true;
    } else {
        was_touching_player = false;
    }
}

// трение
vel_x *= friction_spd;
vel_y *= friction_spd;
if (abs(vel_x) < 0.05) vel_x = 0;
if (abs(vel_y) < 0.05) vel_y = 0;

// отскок от стен
var _wall = [WallO, WallTriangleO];
if (place_meeting(x + vel_x, y, _wall)) vel_x *= -bounce_damp;
if (place_meeting(x, y + vel_y, _wall)) vel_y *= -bounce_damp;

x += vel_x;
y += vel_y;

// squash and stretch пружина
var _dsx = 1 - squash_x;
squash_x_speed += _dsx * squash_stiffness;
squash_x_speed *= squash_damping;
squash_x += squash_x_speed;

var _dsy = 1 - squash_y;
squash_y_speed += _dsy * squash_stiffness;
squash_y_speed *= squash_damping;
squash_y += squash_y_speed;