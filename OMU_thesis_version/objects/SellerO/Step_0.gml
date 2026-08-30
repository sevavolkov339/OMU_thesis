if (!instance_exists(PlayerBallerO)) exit;

var dist = point_distance(x, y, PlayerBallerO.x, PlayerBallerO.y);

if (dist < bubble_radius && !bubble_visible && bubble_scale_x <= 0.05 && !hello_bubble_played) {
    hello_bubble_played = true;
    bubble_visible = true;
    bubble_playing = true;
    var key = bubble_texts[irandom(array_length(bubble_texts) - 1)];
    var full_text = Text(key);
	bubble_parts = string_split(full_text, "|");
    bubble_part_index = 0;
    bubble_part_timer = 0;
    bubble_current_text = array_length(bubble_parts) > 0 ? bubble_parts[0] : "";
    bubble_visible_chars = 0;
    bubble_print_timer = 0;
    bubble_char_y = [];
    bubble_char_alpha = [];
    bubble_char_y_speed = [];
}

if (dist >= bubble_radius && bubble_visible && !bubble_playing) {
    bubble_visible = false;
    bubble_part_index = 0;
    bubble_part_timer = 0;
}

if (bubble_visible && array_length(bubble_parts) > 0) {
    if (bubble_visible_chars >= string_length(bubble_current_text)) {
        bubble_part_timer++;
        if (bubble_part_timer >= bubble_part_duration) {
            bubble_part_timer = 0;
            if (bubble_part_index < array_length(bubble_parts) - 1) {
                bubble_part_index++;
                bubble_current_text = bubble_parts[bubble_part_index];
                bubble_visible_chars = 0;
                bubble_print_timer = 0;
                bubble_char_y = [];
                bubble_char_alpha = [];
                bubble_char_y_speed = [];
            } else {
                bubble_visible = false;
                bubble_playing = false;
            }
        }
    }
}

if (bubble_visible) {
    bubble_target_scale = 1;
} else {
    bubble_target_scale = 0;
}

var _dsx = bubble_target_scale - bubble_scale_x;
bubble_scale_x_speed += _dsx * bubble_scale_stiffness;
bubble_scale_x_speed *= bubble_scale_damping;
bubble_scale_x += bubble_scale_x_speed;

var _dsy = bubble_target_scale - bubble_scale_y;
bubble_scale_y_speed += _dsy * bubble_scale_stiffness;
bubble_scale_y_speed *= bubble_scale_damping;
bubble_scale_y += bubble_scale_y_speed;

bubble_alpha = bubble_scale_x > 0.05 ? 1 : 0;

if (bubble_visible) {
    bubble_print_timer++;
    if (bubble_print_timer >= bubble_print_speed) {
        bubble_print_timer = 0;
        if (bubble_visible_chars < string_length(bubble_current_text)) {
            bubble_visible_chars++;
            array_push(bubble_char_y, bubble_char_fall_height);
            array_push(bubble_char_alpha, 0);
            array_push(bubble_char_y_speed, 0);
        }
    }
}

for (var _i = 0; _i < array_length(bubble_char_y); _i++) {
    var _dy = -bubble_char_y[_i];
    bubble_char_y_speed[_i] += _dy * 0.4;
    bubble_char_y_speed[_i] *= 0.55;
    bubble_char_y[_i] += bubble_char_y_speed[_i];
    bubble_char_alpha[_i] = min(bubble_char_alpha[_i] + 0.15, 1);
}

// пружина ширины — используем SmallFnt чтобы string_width был правильным
draw_set_font(SmallFnt);
var visible_str = string_copy(bubble_current_text, 1, bubble_visible_chars);
bubble_target_w = max(string_width(visible_str) + bubble_pad * 2, 10);
draw_set_font(-1);

var _dw = bubble_target_w - bubble_current_w;
bubble_w_speed += _dw * bubble_w_stiffness;
bubble_w_speed *= bubble_w_damping;
bubble_current_w += bubble_w_speed;