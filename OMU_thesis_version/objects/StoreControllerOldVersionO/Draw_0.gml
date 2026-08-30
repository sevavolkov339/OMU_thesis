if (!store_open) exit;

var slot_w = 24;
var gap = items_gap;
var item_i = 0;
var trade_i = 0;

for (var i = 0; i < array_length(offers); i++) {
    var offer = offers[i];
    var is_trade = (offer.type == "trade") ||
                   (offer.type == "bought" && variable_struct_exists(offer, "was_trade") && offer.was_trade);

    if (offer.type == "bought") {
        if (is_trade) trade_i++; else item_i++;
        continue;
    }

    var sc_x = hover_scale[i] * squash_scale_x[i];
    var sc_y = hover_scale[i] * squash_scale_y[i];
    var slot_cx, slot_cy;

    if (offer.type != "trade") {
        slot_cx = x + items_offset_x + item_i * (slot_w + gap);
        slot_cy = y + items_offset_y + hover_y_offset[i];
        item_i++;
    } else {
        slot_cx = x + trades_offset_x;
        slot_cy = y + trades_offset_y + trade_i * trade_row_gap + hover_y_offset[i];
        trade_i++;
    }

    var wobble = hover_wobble[i];

    gpu_set_fog(squash_active[i], c_white, squash_white[i] - 0.01, squash_white[i]);
    draw_set_alpha(1);

    var _mx = matrix_build(slot_cx, slot_cy, 0, 0, 0, wobble, sc_x, sc_y, 1);
    var _prev = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_mx, _prev));

    if (offer.type == "buy" || offer.type == "heart") {
        draw_sprite(offer.item.sprite, 0, 0, 0);
    } else if (offer.type == "trade") {
        draw_sprite(offer.give.sprite, 0, -10, 0);
        draw_sprite(offer.receive.sprite, 0, 10, 0);
        draw_sprite(TradeArrowS, 0, 0, 0);
    }

    matrix_set(matrix_world, _prev);
    gpu_set_fog(false, c_white, 0, 0);
    draw_set_alpha(1);
}