origin_x = x;
origin_y = y;
// эффект покупки
bought_effect = false;
bought_item_y = 0;
bought_item_alpha = 1;
bought_blink_timer = 0;
bought_blink_speed = 8;
bought_visible = true;
// айтем внутри
item = noone;
mask_index = ItemBubbleS;
pop_par_sys = -1;
pop_par_type = -1;
// физика
float_timer = random(pi * 2);
float_x = 0;
float_y = 0;
vel_x = 0;
vel_y = 0;
friction_spd = 0.88;
// дыхание
bubble_scale_x = 1;
bubble_scale_y = 1;
bubble_scale_x_speed = 0;
bubble_scale_y_speed = 0;
// лопание
popped = false;
pop_timer = 0;
// тряска
shake_x = 0;
cant_afford_shake = 0;
// стены
wall = [WallO, WallTriangleO];
// диалоговое окно с описанием предмета
desc_bubble_scale_x = 0;
desc_bubble_scale_y = 0;
desc_bubble_scale_x_speed = 0;
desc_bubble_scale_y_speed = 0;
desc_bubble_scale_stiffness = 0.3;
desc_bubble_scale_damping = 0.6;
desc_bubble_visible = false;
desc_bubble_radius = 40;
desc_bubble_pad = 4;
desc_bubble_h = 20;
desc_bubble_current_w = 0;
desc_bubble_target_w = 0;
desc_bubble_w_speed = 0;
desc_bubble_w_stiffness = 0.4;
desc_bubble_w_damping = 0.6;
desc_bubble_visible_chars = 0;
desc_bubble_print_timer = 0;
desc_bubble_print_speed = 2;
desc_bubble_char_y = [];
desc_bubble_char_alpha = [];
desc_bubble_char_y_speed = [];
desc_bubble_char_fall_height = 6;
desc_bubble_text = "";
desc_bubble_pages = [];
desc_bubble_page_index = 0;
desc_bubble_page_timer = 0;
desc_bubble_page_delay = 0.3 * room_speed; //пол сек
desc_bubble_finished = false;