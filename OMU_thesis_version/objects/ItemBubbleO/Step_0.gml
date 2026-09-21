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
    // пружина scale описания продолжает работать даже после лопания
    var _desc_target = 0;
    var _dsx = _desc_target - desc_bubble_scale_x;
    desc_bubble_scale_x_speed += _dsx * desc_bubble_scale_stiffness;
    desc_bubble_scale_x_speed *= desc_bubble_scale_damping;
    desc_bubble_scale_x += desc_bubble_scale_x_speed;
    var _dsy = _desc_target - desc_bubble_scale_y;
    desc_bubble_scale_y_speed += _dsy * desc_bubble_scale_stiffness;
    desc_bubble_scale_y_speed *= desc_bubble_scale_damping;
    desc_bubble_scale_y += desc_bubble_scale_y_speed;
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

// отскок от стен, проверяем ДО обновления позиции
var _wall = [WallO, WallTriangleO, WallForEnemiesO, WallInteriorO];
var next_ox = origin_x + vel_x;
var next_oy = origin_y + vel_y;

if (place_meeting(next_ox, origin_y, _wall)) {
    vel_x *= -0.8;
    next_ox = origin_x + vel_x;
}
if (place_meeting(origin_x, next_oy, _wall)) {
    vel_y *= -0.8;
    next_oy = origin_y + vel_y;
}

// если всё ещё застрял, выталкиваем
if (place_meeting(next_ox, next_oy, _wall)) {
    var _normal = collision_normal(next_ox, next_oy, _wall, 4, 1);
    if (_normal != -1) {
        origin_x += lengthdir_x(2, _normal);
        origin_y += lengthdir_y(2, _normal);
    }
    vel_x = 0;
    vel_y = 0;
    next_ox = origin_x;
    next_oy = origin_y;
}

origin_x = next_ox;
origin_y = next_oy;

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

// касание игрока, только если бабл остановился
var _is_moving = (abs(vel_x) > 0.05 || abs(vel_y) > 0.05);
if (!popped && !_is_moving && instance_exists(PlayerBallerO)) {
    if (place_meeting(x, y, PlayerBallerO)) {
        if (item == noone) exit;
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
        bought_effect = true;
        bought_item_y = y;
        bought_visible = true;
        bought_blink_timer = 0;
        bought_blink_speed = 8;
        // скрываем текстовый бабл
        desc_bubble_visible = false;
        desc_bubble_visible_chars = 0;
        desc_bubble_char_y = [];
        desc_bubble_char_alpha = [];
        desc_bubble_char_y_speed = [];
    }
}

// диалоговое окно с описанием
if (instance_exists(PlayerBallerO) && item != noone && !popped) {
    var _dist = point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y);
    
    // игрок вышел из зоны, сбрасываем всё
    if (_dist >= desc_bubble_radius) {
        if (desc_bubble_visible) {
            desc_bubble_visible = false;
            desc_bubble_visible_chars = 0;
            desc_bubble_char_y = [];
            desc_bubble_char_alpha = [];
            desc_bubble_char_y_speed = [];
        }
        desc_bubble_finished = false;
    }
    
    // игрок вошёл в зону и текст ещё не был показан
	var _is_still = (abs(vel_x) < 0.05 && abs(vel_y) < 0.05);
	if (_dist < desc_bubble_radius && !desc_bubble_visible && !desc_bubble_finished && _is_still) {
        desc_bubble_visible = true;
        desc_bubble_pages = string_split(item.description, "|");
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
        // текст дописан, ждём потом следующая страница или закрываем
        desc_bubble_page_timer++;
        if (desc_bubble_page_timer >= desc_bubble_page_delay) {
            desc_bubble_page_timer = 0;
            desc_bubble_page_index++;
			if (desc_bubble_page_index >= array_length(desc_bubble_pages)) {
			    // последняя страница, закрываем бабл
			    desc_bubble_visible = false;
			    desc_bubble_finished = true; // <- добавь эту строку
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
desc_bubble_target_w = max(string_width(_desc_visible_str) + desc_bubble_pad * 2, 4);
draw_set_font(-1);
var _dw = desc_bubble_target_w - desc_bubble_current_w;
desc_bubble_w_speed += _dw * desc_bubble_w_stiffness;
desc_bubble_w_speed *= desc_bubble_w_damping;
desc_bubble_current_w += desc_bubble_w_speed;