if (GameControllerO.game_paused) exit;

// эффект покупки, предмет летит вверх и мигает
if (bought_effect) {
    bought_item_y -= 0.8;
    bought_blink_timer++;
    if (bought_blink_timer >= floor(bought_blink_speed)) {
        bought_blink_timer = 0;
        bought_visible = !bought_visible;
        bought_blink_speed *= 0.75;
    }
    if (bought_blink_speed < 0.5) {
        bought_effect = false;
        bought_visible = false;
    }
}

// лопание
if (popped) {
    pop_timer += sprite_get_speed(ItemBubbleS) / game_get_speed(gamespeed_fps);
    if (pop_timer >= sprite_get_number(ItemBubbleS) && !bought_effect) {
        instance_destroy();
    }
    exit;
}

// дыхание через пружину
float_timer += 0.04;
var breath_target_x = sin(float_timer * 1.3) * 0.08 + 1;
var breath_target_y = cos(float_timer * 1.1) * 0.08 + 1;
bubble_scale_x_speed += (breath_target_x - bubble_scale_x) * 0.3;
bubble_scale_x_speed *= 0.6;
bubble_scale_x += bubble_scale_x_speed;
bubble_scale_y_speed += (breath_target_y - bubble_scale_y) * 0.3;
bubble_scale_y_speed *= 0.6;
bubble_scale_y += bubble_scale_y_speed;

// левитация, только визуальная
var base_float_x = sin(float_timer * 0.5) * 1.2;
var base_float_y = cos(float_timer * 0.4) * 1.8;

// трение
vel_x *= friction_spd;
vel_y *= friction_spd;
if (abs(vel_x) < 0.05) vel_x = 0;
if (abs(vel_y) < 0.05) vel_y = 0;

// отскок от стен
var _wall = [WallO, WallTriangleO];
if (place_meeting(origin_x + vel_x, origin_y, _wall)) vel_x *= -0.7;
if (place_meeting(origin_x, origin_y + vel_y, _wall)) vel_y *= -0.7;

origin_x += vel_x;
origin_y += vel_y;

// финальная позиция = origin + левитация
x = origin_x + base_float_x;
y = origin_y + base_float_y;

// тряска
if (cant_afford_shake > 0) {
    cant_afford_shake--;
    shake_x = sin(cant_afford_shake * 1.8) * 3;
} else {
    shake_x = 0;
}

// диалоговое окно с описанием
if (instance_exists(PlayerBallerO) && item != noone && !popped) {
    var _dist = point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y);
    
    // найти ближайший бабл к игроку
    var _nearest_id = noone;
    var _nearest_dist = infinity;
    with (ItemBubbleStoreO) {
        if (!popped && item != noone) {
            var _d = point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y);
            if (_d < _nearest_dist) {
                _nearest_dist = _d;
                _nearest_id = id;
            }
        }
    }
    
    var _should_show = (_nearest_id == id && _dist < desc_bubble_radius);
    
    // игрок вышел из зоны, сбрасываем finished
    if (!_should_show) {
        if (desc_bubble_visible) {
            desc_bubble_visible = false;
            desc_bubble_visible_chars = 0;
            desc_bubble_char_y = [];
            desc_bubble_char_alpha = [];
            desc_bubble_char_y_speed = [];
        }
        desc_bubble_finished = false;
    }
    
    // игрок вошёл в зону и текст ещё не был показан до конца
    if (_should_show && !desc_bubble_visible && !desc_bubble_finished) {
        desc_bubble_visible = true;
        var _price_page = string(item.cost);
        var _desc_pages = string_split(item.description, "|");
        desc_bubble_pages = array_concat([_price_page], _desc_pages);
        desc_bubble_page_index = 0;
        desc_bubble_text = desc_bubble_pages[0];
        desc_bubble_visible_chars = 0;
        desc_bubble_print_timer = 0;
        desc_bubble_page_timer = 0;
        desc_bubble_char_y = [];
        desc_bubble_char_alpha = [];
        desc_bubble_char_y_speed = [];
    }
}

// scale пружина
var _desc_target = desc_bubble_visible ? 1 : 0;
var _dsx = _desc_target - desc_bubble_scale_x;
desc_bubble_scale_x_speed += _dsx * desc_bubble_scale_stiffness;
desc_bubble_scale_x_speed *= desc_bubble_scale_damping;
desc_bubble_scale_x += desc_bubble_scale_x_speed;
var _dsy = _desc_target - desc_bubble_scale_y;
desc_bubble_scale_y_speed += _dsy * desc_bubble_scale_stiffness;
desc_bubble_scale_y_speed *= desc_bubble_scale_damping;
desc_bubble_scale_y += desc_bubble_scale_y_speed;

// печать букв
if (desc_bubble_visible) {
    var _text_done = (desc_bubble_visible_chars >= string_length(desc_bubble_text));
    if (!_text_done) {
        desc_bubble_print_timer++;
        if (desc_bubble_print_timer >= desc_bubble_print_speed) {
            desc_bubble_print_timer = 0;
            desc_bubble_visible_chars++;
            array_push(desc_bubble_char_y, desc_bubble_char_fall_height);
            array_push(desc_bubble_char_alpha, 0);
            array_push(desc_bubble_char_y_speed, 0);
        }
    } else {
        desc_bubble_page_timer++;
        if (desc_bubble_page_timer >= desc_bubble_page_delay) {
            desc_bubble_page_timer = 0;
            desc_bubble_page_index++;
            if (desc_bubble_page_index >= array_length(desc_bubble_pages)) {
                desc_bubble_visible = false;
                desc_bubble_finished = true;
                desc_bubble_visible_chars = 0;
                desc_bubble_char_y = [];
                desc_bubble_char_alpha = [];
                desc_bubble_char_y_speed = [];
            } else {
                desc_bubble_text = desc_bubble_pages[desc_bubble_page_index];
                desc_bubble_visible_chars = 0;
                desc_bubble_char_y = [];
                desc_bubble_char_alpha = [];
                desc_bubble_char_y_speed = [];
            }
        }
    }
}

// анимация букв
for (var _i = 0; _i < array_length(desc_bubble_char_y); _i++) {
    var _dy = -desc_bubble_char_y[_i];
    desc_bubble_char_y_speed[_i] += _dy * 0.4;
    desc_bubble_char_y_speed[_i] *= 0.55;
    desc_bubble_char_y[_i] += desc_bubble_char_y_speed[_i];
    desc_bubble_char_alpha[_i] = min(desc_bubble_char_alpha[_i] + 0.15, 1);
}

// ширина пружина
draw_set_font(SmallFnt);
var _desc_visible_str = string_copy(desc_bubble_text, 1, desc_bubble_visible_chars);
var _icon_w = (desc_bubble_page_index == 0 && !desc_bubble_finished) ? sprite_get_width(AppleBlackIconS) + 2 : 0;
desc_bubble_target_w = max(string_width(_desc_visible_str) + desc_bubble_pad * 2 + _icon_w, 4);
draw_set_font(-1);
var _dw = desc_bubble_target_w - desc_bubble_current_w;
desc_bubble_w_speed += _dw * desc_bubble_w_stiffness;
desc_bubble_w_speed *= desc_bubble_w_damping;
desc_bubble_current_w += desc_bubble_w_speed;

// касание игрока
if (!popped && instance_exists(PlayerBallerO)) {
    var px = PlayerBallerO.x;
    var py = PlayerBallerO.y;
    if (place_meeting(x, y, PlayerBallerO)) {
        if (item == noone) exit;
        var can_afford = (PlayerBallerO.money >= item.cost);
        if (can_afford) {
            PlayerBallerO.money -= item.cost;
			if (instance_exists(GameControllerO)) {
			    GameControllerO.mark_store_item_bought(item.name);
			}
			if (instance_exists(GameControllerO)) {
			    GameControllerO.mark_store_item_bought(item.name);
    
			    // помечаем слот как пустой в сохранённых офферах
			    var _offers = GameControllerO.get_store_offers();
			    if (_offers != undefined) {
			        for (var _oi = 0; _oi < array_length(_offers); _oi++) {
			            if (_offers[_oi] == item.name) {
			                _offers[_oi] = "";
			                break;
			            }
			        }
			        GameControllerO.mark_store_offers(_offers);
			    }
			}			
            if (item.type == "Heart") {
                PlayerBallerO.hp = min(PlayerBallerO.hp + 1, PlayerBallerO.max_hp);
            } else {
                if (instance_exists(InventoryControllerO)) {
                    InventoryControllerO.add_item(item);
                }
            }
            popped = true;
            pop_timer = 0;
            audio_play_sound(StoreBuy_Snd, 0, false);
            with (SellerO) {
                trigger_thanks_bubble();
            }
            bought_effect = true;
            bought_item_y = y;
            bought_visible = true;
            bought_blink_timer = 0;
            bought_blink_speed = 8;
        } else {
            var push_dir = point_direction(px, py, origin_x, origin_y);
            var push_spd = 2;
            vel_x = lengthdir_x(push_spd, push_dir);
            vel_y = lengthdir_y(push_spd, push_dir);
            if (cant_afford_shake <= 0) {
                audio_play_sound(CantDoIt_Snd, 0, false);
            }
            cant_afford_shake = 15;
        }
    }
}