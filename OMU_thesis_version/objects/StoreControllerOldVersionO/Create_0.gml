store_open = false;
store_used = false;
open_radius = 500;
hover_scale = [1, 1, 1, 1, 1, 1, 1];
hover_scale_speed = [0, 0, 0, 0, 0, 0, 0];
hover_scale_target = [1, 1, 1, 1, 1, 1, 1];
hover_y_offset = [0, 0, 0, 0, 0, 0, 0];
hover_y_speed = [0, 0, 0, 0, 0, 0, 0];
hover_wobble = [0, 0, 0, 0, 0, 0, 0];
hover_wobble_speed = [0, 0, 0, 0, 0, 0, 0];
hover_stiffness = 0.3;
hover_damping = 0.6;
hover_y_stiffness = 0.25;
hover_y_damping = 0.55;
squash_scale_x = [1, 1, 1, 1, 1, 1, 1];
squash_scale_y = [1, 1, 1, 1, 1, 1, 1];
squash_white = [0, 0, 0, 0, 0, 0, 0];
squash_active = [false, false, false, false, false, false, false];
hover_timer = 0;
offers = [];
items_offset_x = 2;
items_offset_y = 0;
trades_offset_x = 154;
trades_offset_y = -28;
trade_row_gap = 15;
items_gap = -2;

function generate_offers() {
    offers = [];
    var all_items = EveryItemScr();
    var buy_pool = [];
    for (var i = 0; i < array_length(all_items); i++) {
        if (all_items[i].type != "Heart") array_push(buy_pool, all_items[i]);
    }
    array_shuffle(buy_pool);
    for (var i = 0; i < min(3, array_length(buy_pool)); i++) {
        array_push(offers, { type: "buy", item: buy_pool[i] });
    }
    for (var i = 0; i < array_length(all_items); i++) {
        if (all_items[i].type == "Heart") {
            array_push(offers, { type: "heart", item: all_items[i] });
            break;
        }
    }
    if (instance_exists(InventoryControllerO)) {
        var inv = InventoryControllerO.items;
        if (array_length(inv) > 0) {
            var inv_copy = [];
            for (var _i = 0; _i < array_length(inv); _i++) {
                array_push(inv_copy, inv[_i]);
            }
            var all_items2 = EveryItemScr();
            var trade_count = min(3, array_length(inv_copy));
            for (var i = 0; i < trade_count; i++) {
                var give_i = irandom(array_length(inv_copy) - 1);
                var give_item = inv_copy[give_i];
                array_delete(inv_copy, give_i, 1);
                var receive_pool = [];
                for (var _j = 0; _j < array_length(all_items2); _j++) {
                    if (all_items2[_j].name != give_item.name) {
                        array_push(receive_pool, all_items2[_j]);
                    }
                }
                if (array_length(receive_pool) == 0) continue;
                var receive_item = receive_pool[irandom(array_length(receive_pool) - 1)];
                array_push(offers, { type: "trade", give: give_item, receive: receive_item });
            }
        }
    }
}

function do_offer(_index) {
    if (_index < 0 || _index >= array_length(offers)) return;
    if (!instance_exists(PlayerBallerO)) return;
    var offer = offers[_index];
    if (offer.type == "buy") {
        if (PlayerBallerO.money < offer.item.cost) return;
        PlayerBallerO.money -= offer.item.cost;
        if (instance_exists(InventoryControllerO)) InventoryControllerO.add_item(offer.item);
    } else if (offer.type == "heart") {
        if (PlayerBallerO.money < offer.item.cost) return;
        PlayerBallerO.money -= offer.item.cost;
        PlayerBallerO.hp = min(PlayerBallerO.hp + 1, PlayerBallerO.max_hp);
    } else if (offer.type == "trade") {
        if (!instance_exists(InventoryControllerO)) return;
        var removed = InventoryControllerO.remove_item(offer.give.name);
        if (!removed) return;
        if (offer.receive.type == "Heart") {
            PlayerBallerO.hp = min(PlayerBallerO.hp + 1, PlayerBallerO.max_hp);
        } else {
            InventoryControllerO.add_item(offer.receive);
        }
    }
    // триггерим бабл благодарности
    if (instance_exists(SellerO)) {
        SellerO.trigger_thanks_bubble();
    }
}

cant_afford_index = -1;
cant_afford_shake = 0;

function trigger_squash(_index) {
    var offer = offers[_index];
    if (offer.type == "buy" || offer.type == "heart") {
        if (!instance_exists(PlayerBallerO)) return;
        if (PlayerBallerO.money < offer.item.cost) {
            cant_afford_index = _index;
            cant_afford_shake = 10;
            return;
        }
    }
    squash_active[_index] = true;
    squash_scale_x[_index] = 1;
    squash_scale_y[_index] = 1;
    squash_white[_index] = 0;
}