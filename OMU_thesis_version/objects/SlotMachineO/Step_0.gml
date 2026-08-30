if (GameControllerO.game_paused) exit;

// толчок от игрока
var touching_player = false;
if (instance_exists(PlayerBallerO)) {
    if (place_meeting(origin_x, origin_y, PlayerBallerO)) {
        touching_player = true;
        if (!was_touching_player) {
            var push_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
            offset_vel_x += lengthdir_x(3, push_dir);
            offset_vel_y += lengthdir_y(3, push_dir);
        }
    }
}
was_touching_player = touching_player;

// пружина возврата offset к нулю
offset_vel_x += (0 - offset_x) * push_stiffness;
offset_vel_y += (0 - offset_y) * push_stiffness;
offset_vel_x *= push_damping;
offset_vel_y *= push_damping;
offset_x += offset_vel_x;
offset_y += offset_vel_y;

// трение
vel_x *= friction_spd;
vel_y *= friction_spd;
if (abs(vel_x) < 0.05) vel_x = 0;
if (abs(vel_y) < 0.05) vel_y = 0;

// отскок от стен
var wall = [WallO, WallTriangleO];
if (place_meeting(origin_x + vel_x, origin_y, wall)) vel_x *= -0.7;
if (place_meeting(origin_x, origin_y + vel_y, wall)) vel_y *= -0.7;

origin_x += vel_x;
origin_y += vel_y;

// шейк
if (shake_timer > 0 || kick_shake_timer > 0) {
    shake_timer = max(shake_timer - 1, 0);
    kick_shake_timer = max(kick_shake_timer - 1, 0);
    x = origin_x + offset_x + irandom_range(-shake_strength, shake_strength);
    y = origin_y + offset_y + irandom_range(-shake_strength, shake_strength);
} else {
    x = origin_x + offset_x;
    y = origin_y + offset_y;
}

// удар ногой
var _gp = instance_exists(PlayerBallerO) ? PlayerBallerO.gamepad_index : 0;
var _kick_pressed = mouse_check_button_pressed(mb_left) || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_shoulderr));
if (_kick_pressed) {
    if (instance_exists(PlayerBallerO)) {
        var dist = point_distance(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
        if (dist < 40) {
            if (state == "idle" || state == "result" || state == "win") {
                if (PlayerBallerO.money >= cost) {
                    var sndd = audio_play_sound(KickInStore_Snd, 0, 0);
                    audio_sound_pitch(sndd, random_range(0.8, 1.3));
                    PlayerBallerO.money -= cost;
                    state = "spin";
                    sprite_index = SlotMachineSpinS;
                    image_index = 0;
                    spin_timer = 0;
                    kick_shake_timer = kick_shake_duration;
                    var kick_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
                    vel_x += lengthdir_x(3, kick_dir);
                    vel_y += lengthdir_y(3, kick_dir);
                } else {
                    kick_shake_timer = kick_shake_duration;
                    var kick_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
                    vel_x += lengthdir_x(3, kick_dir);
                    vel_y += lengthdir_y(3, kick_dir);
                    audio_play_sound(CantDoIt_Snd, 0, false);
                }
            }
        }
    }
}

// спин
if (state == "spin") {
    spin_timer++;
    if (spin_timer >= spin_duration) {
        spin_timer = 0;
        if (random(1) < win_chance) {
            state = "win";
            sprite_index = SlotMachineWinS;
            shake_timer = shake_duration;
            var all_items_raw = EveryItemScr();
            var all_items = [];
            for (var _i = 0; _i < array_length(all_items_raw); _i++) {
                var _it = all_items_raw[_i];
                if (_it.type == "Heart") {
                    array_push(all_items, _it);
                } else if (_it.type == "Item" && !IsItemMaxedOutScr(_it.name)) {
                    array_push(all_items, _it);
                }
            }
            var won_item;
            if (array_length(all_items) > 0) {
                won_item = all_items[irandom(array_length(all_items) - 1)];
            } else {
                // все предметы уже есть у игрока — вместо них выпадает заполнитель
                var _filler_placeholder = undefined;
                var _filler_heart = undefined;
                for (var _i = 0; _i < array_length(all_items_raw); _i++) {
                    if (all_items_raw[_i].name == "Placeholder 1") _filler_placeholder = all_items_raw[_i];
                    if (all_items_raw[_i].type == "Heart") _filler_heart = all_items_raw[_i];
                }
                won_item = (_filler_placeholder != undefined) ? _filler_placeholder : _filler_heart;
            }
            show_debug_message("WON: " + won_item.name);
            var _bubble = instance_create_layer(origin_x, origin_y + 10, "ItemsL", ItemBubbleO);
            _bubble.item = won_item;
            _bubble.vel_y = 5;
            audio_play_sound(PartyHorn_Snd, 1, false);
            audio_play_sound(ConfettiPop_Snd, 1, false);
            var confetti_colors = [c_red, c_yellow, c_lime, c_aqua, c_fuchsia, c_orange, c_white];
            for (var _i = 0; _i < 40; _i++) {
                array_push(confetti, {
                    x: origin_x + random_range(-10, 10),
                    y: origin_y - 20,
                    vx: random_range(-4, 4),
                    vy: random_range(-6, -1),
                    alpha: 1,
                    angle: irandom(359),
                    spin: random_range(-10, 10),
                    col: confetti_colors[irandom(array_length(confetti_colors) - 1)],
                    w: random_range(2, 5),
                    h: random_range(2, 5),
                    lifetime: 0,
                    max_lifetime: irandom_range(60, 100)
                });
            }
        } else {
            state = "result";
            sprite_index = SlotMachineRandomNumberS;
            image_index = irandom(sprite_get_number(SlotMachineRandomNumberS) - 1);
        }
    }
}

// обновление конфети
for (var _i = array_length(confetti) - 1; _i >= 0; _i--) {
    var c = confetti[_i];
    c.x += c.vx;
    c.y += c.vy;
    c.vy += 0.15;
    c.angle += c.spin;
    c.lifetime++;
    var blink_start = c.max_lifetime * 0.2;
    if (c.lifetime > blink_start) {
        var _progress = (c.lifetime - blink_start) / (c.max_lifetime - blink_start);
        var _blink_interval = floor(lerp(8, 2, _progress));
        c.alpha = ((c.lifetime div _blink_interval) mod 2 == 0) ? 1 : 0;
    } else {
        c.alpha = 1;
    }
    if (c.lifetime >= c.max_lifetime) {
        array_delete(confetti, _i, 1);
    }
}

// change layer based on player position
if (instance_exists(PlayerBallerO)) {
    if (PlayerBallerO.y < (y - 30)) {
        layer = layer_get_id("StoreL");
    } else if (PlayerBallerO.y > (y - 30)) {
        layer = layer_get_id("MachinesL");
    }
}