draw_self();

if (array_length(trades) > 0) {
    var trade = trades[current_trade_index];
    var give_frame = min(1, sprite_get_number(trade.give.sprite) - 1);
    var receive_frame = min(1, sprite_get_number(trade.receive.sprite) - 1);
    draw_sprite(trade.give.sprite, give_frame, x - 8, y - 36);
    draw_sprite(trade.receive.sprite, receive_frame, x + 8, y - 36);
}