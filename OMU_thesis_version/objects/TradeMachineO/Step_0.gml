if (GameControllerO.game_paused) exit;


// убираем предложения на предметы
for (var _i = array_length(trades) - 1; _i >= 0; _i--) {
    if (IsItemMaxedOutScr(trades[_i].receive.name)) {
        array_delete(trades, _i, 1);
    }
}
if (array_length(trades) == 0) {
    if (sprite_frame_timer <= 0) sprite_frame = 2;
    current_trade_index = 0;
} else if (current_trade_index >= array_length(trades)) {
    current_trade_index = current_trade_index mod array_length(trades);
}


// толчок от игрока, переключает трейд
var touching_player = false;
if (instance_exists(PlayerBallerO)) {
    if (place_meeting(origin_x, origin_y, PlayerBallerO)) {
        touching_player = true;
        if (!was_touching_player) {
            var push_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
            offset_vel_x += lengthdir_x(2, push_dir);
            offset_vel_y += lengthdir_y(2, push_dir);
            if (array_length(trades) > 0) {
                current_trade_index = (current_trade_index + 1) mod array_length(trades);
            }
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

// управление кадром спрайта
if (sprite_frame_timer > 0) {
    sprite_frame_timer--;
    if (sprite_frame_timer <= 0) {
        sprite_frame = (array_length(trades) == 0) ? 2 : 0;
    }
}
image_index = sprite_frame;
image_speed = 0;

// кулдаун трейда, защита от спама
if (trade_cooldown > 0) trade_cooldown--;

// пинок, лкм рядом
var _gp = instance_exists(PlayerBallerO) ? PlayerBallerO.gamepad_index : 0;
var _kick_pressed = mouse_check_button_pressed(mb_left) || (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_shoulderr));
if (_kick_pressed && trade_cooldown <= 0) {
    if (instance_exists(PlayerBallerO)) {
        var dist = point_distance(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
        if (dist < 40) {
            // сразу ставим кулдаун до любой логики
            trade_cooldown = trade_cooldown_duration;

            if (array_length(trades) == 0) {
                // нет трейдов, просто толкаем
                kick_shake_timer = kick_shake_duration;
                var kick_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
                vel_x += lengthdir_x(3, kick_dir);
                vel_y += lengthdir_y(3, kick_dir);
                audio_play_sound(CantDoIt_Snd, 0, false);
            } else {
                var sndd = audio_play_sound(KickInStore_Snd, 0, 0);
                audio_sound_pitch(sndd, random_range(0.8, 1.3));
                var trade = trades[current_trade_index];
                if (instance_exists(InventoryControllerO)) {
                    var removed = InventoryControllerO.remove_item(trade.give.name);
                    if (removed) {
                        // трейд успешен
                        var sndd = audio_play_sound(TradeMachineSpitOut_Snd, 0, 0);
                        audio_sound_pitch(sndd, random_range(0.8, 1.3));
                        var _bubble = instance_create_layer(origin_x, origin_y - 10, "ItemsL", ItemBubbleO);
                        _bubble.item = trade.receive;
                        _bubble.vel_y = 5;
                        kick_shake_timer = kick_shake_duration;
                        var kick_dir = point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y);
                        vel_x += lengthdir_x(3, kick_dir);
                        vel_y += lengthdir_y(3, kick_dir);
                        sprite_frame = 1;
                        sprite_frame_timer = sprite_frame_duration;
                        // удаляем использованный трейд из массива
                        array_delete(trades, current_trade_index, 1);
                        if (array_length(trades) == 0) {
                            sprite_frame = 2;
                            sprite_frame_timer = 0;
                        } else {
                            current_trade_index = current_trade_index mod array_length(trades);
                        }
                    } else {
                        // нет нужного предмета
                        kick_shake_timer = kick_shake_duration;
                        vel_x += lengthdir_x(2, point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y));
                        vel_y += lengthdir_y(2, point_direction(PlayerBallerO.x, PlayerBallerO.y, origin_x, origin_y));
                        audio_play_sound(CantDoIt_Snd, 0, false);
                    }
                }
            }
        }
    }
}

// change layer based on player position

if (instance_exists(PlayerBallerO)) {
    if (PlayerBallerO.y < (y - 30)) {
        layer = layer_get_id("StoreL");
    }
	else if (PlayerBallerO.y > (y - 30)){
        layer = layer_get_id("MachinesL");
    }
}
