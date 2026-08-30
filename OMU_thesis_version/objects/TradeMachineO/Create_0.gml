// физика
vel_x = 0;
vel_y = 0;
friction_spd = 0.92;
origin_x = x;
origin_y = y;
offset_x = 0;
offset_y = 0;
offset_vel_x = 0;
offset_vel_y = 0;
push_stiffness = 0.15;
push_damping = 0.7;
was_touching_player = false;
// тряска
shake_timer = 0;
shake_duration = 0.3 * room_speed;
shake_strength = 3;
kick_shake_timer = 0;
kick_shake_duration = 0.3 * room_speed;
// трейды
current_trade_index = 0;
trades = [];
trade_done = false;
trade_cooldown = 0;
trade_cooldown_duration = room_speed * 0.3;
// спрайт
sprite_frame = 0;
sprite_frame_timer = 0;
sprite_frame_duration = room_speed * 0.5;
mask_index = TradeMachineS;
// генерация трейдов
function generate_trades() {
    trades = [];
    current_trade_index = 0;
    if (!instance_exists(InventoryControllerO)) {
        sprite_frame = 2;
        return;
    }
    var inv = InventoryControllerO.items;
    if (array_length(inv) == 0) {
        sprite_frame = 2;
        return;
    }
    var all_items = EveryItemScr();
    // только Item и Heart можно отдавать
    var inv_copy = [];
    for (var i = 0; i < array_length(inv); i++) {
        if (inv[i].type == "Item" || inv[i].type == "Heart") {
            array_push(inv_copy, inv[i]);
        }
    }
    if (array_length(inv_copy) == 0) {
        sprite_frame = 2;
        return;
    }
    var trade_count = min(3, array_length(inv_copy));
    for (var i = 0; i < trade_count; i++) {
        var give_i = irandom(array_length(inv_copy) - 1);
        var give_item = inv_copy[give_i];
        array_delete(inv_copy, give_i, 1);
        // только Item и Heart можно получать, и не то, что у игрока уже есть
        var receive_pool = [];
        for (var j = 0; j < array_length(all_items); j++) {
            if (all_items[j].name != give_item.name
                && (all_items[j].type == "Item" || all_items[j].type == "Heart")
                && !IsItemMaxedOutScr(all_items[j].name)) {
                array_push(receive_pool, all_items[j]);
            }
        }
        if (array_length(receive_pool) == 0) continue;
        var receive_item = receive_pool[irandom(array_length(receive_pool) - 1)];
        array_push(trades, { give: give_item, receive: receive_item });
    }
    if (array_length(trades) == 0) {
        sprite_frame = 2;
    }
}
generate_trades();
instance_create_layer(x, y, "PlayerL", WallFollowMachineO);