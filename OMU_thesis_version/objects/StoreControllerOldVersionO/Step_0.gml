if (GameControllerO.game_paused) exit;

if (instance_exists(PlayerBallerO)) {
    var dist = distance_to_object(PlayerBallerO);
    if (dist < open_radius && !store_open) {
        store_open = true;
        generate_offers();
    } else if (dist >= open_radius && store_open) {
        store_open = false;
    }
}

if (!store_open) exit;

hover_timer += 0.08;

if (cant_afford_shake > 0) cant_afford_shake--;


var slot_w = 24;
var gap = items_gap;
var mx = mouse_x;
var my = mouse_y;

for (var i = 0; i < array_length(offers); i++) {
    var diff = hover_scale_target[i] - hover_scale[i];
    hover_scale_speed[i] += diff * hover_stiffness;
    hover_scale_speed[i] *= hover_damping;
    hover_scale[i] += hover_scale_speed[i];

    var y_diff = -hover_y_offset[i];
    hover_y_speed[i] += y_diff * hover_y_stiffness;
    hover_y_speed[i] *= hover_y_damping;
    hover_y_offset[i] += hover_y_speed[i];

    var w_diff = -hover_wobble[i];
    hover_wobble_speed[i] += w_diff * 0.2;
    hover_wobble_speed[i] *= 0.7;
    hover_wobble[i] += hover_wobble_speed[i];
}

var item_i = 0;
var trade_i = 0;

for (var i = 0; i < array_length(offers); i++) {
    var offer = offers[i];
    var is_trade = (offer.type == "trade") ||
                   (offer.type == "bought" && variable_struct_exists(offer, "was_trade") && offer.was_trade);

    if (squash_active[i]) {
        squash_scale_x[i] = lerp(squash_scale_x[i], 2.5, 0.3);
        squash_scale_y[i] = lerp(squash_scale_y[i], 0, 0.3);
        squash_white[i]   = lerp(squash_white[i], 1, 0.15);
        if (squash_white[i] > 0.99) {
            do_offer(i);
            offers[i] = { type: "bought", was_trade: (offer.type == "trade") };
            squash_active[i] = false;
            squash_scale_x[i] = 1;
            squash_scale_y[i] = 1;
            squash_white[i] = 0;
        }
        if (is_trade) trade_i++; else item_i++;
        continue;
    }

    if (offer.type == "bought") {
        if (is_trade) trade_i++; else item_i++;
        continue;
    }

    var slot_cx, slot_cy_base;
    if (offer.type != "trade") {
        slot_cx = x + items_offset_x + item_i * (slot_w + gap);
        slot_cy_base = y + items_offset_y;
        item_i++;
    } else {
        slot_cx = x + trades_offset_x;
        slot_cy_base = y + trades_offset_y + trade_i * trade_row_gap;
        trade_i++;
    }

    var spr = (offer.type == "trade") ? offer.give.sprite : offer.item.sprite;
    var spr_w = sprite_get_width(spr);
    var spr_h = sprite_get_height(spr);
    var sx = slot_cx - spr_w * 0.5;
    var sy = slot_cy_base - spr_h * 0.5;

    if (point_in_rectangle(mx, my, sx, sy, sx + spr_w, sy + spr_h)) {
        hover_scale_target[i] = 1.5;
        hover_y_speed[i] -= 0.4;
        hover_wobble[i] = sin(hover_timer * 4 + i) * 5;
        if (mouse_check_button_pressed(mb_left)) {
            trigger_squash(i);
        }
    } else {
        hover_scale_target[i] = 1;
        hover_wobble[i] = lerp(hover_wobble[i], 0, 0.1);
    }
}