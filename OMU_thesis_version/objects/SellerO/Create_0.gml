

// во втором мире у продавца другой спрайт
var _in_world_2 = instance_exists(GameControllerO) && string_pos("w2_", GameControllerO.world_stage) == 1;
if (_in_world_2) {
    sprite_index = SellerWorld2S;
}

bubble_visible = false;
bubble_radius = 80;
bubble_text = "";
bubble_texts = ["Seller_HelloText1", "Seller_HelloText2", "Seller_HelloText3"];
bubble_alpha = 0;
bubble_fade_speed = 0.08;
bubble_pad = 6;
bubble_w = 120;
bubble_h = 40;

bubble_parts = [];
bubble_part_index = 0;
bubble_part_timer = 0;
bubble_part_duration = 1 * room_speed;
bubble_current_text = "";

hello_bubble_played = false;

// squash анимация окна
bubble_scale_x = 0;
bubble_scale_y = 0;
bubble_scale_x_speed = 0;
bubble_scale_y_speed = 0;
bubble_scale_stiffness = 0.3;
bubble_scale_damping = 0.6;
bubble_target_scale = 0;

// печать текста
bubble_print_timer = 0;
bubble_print_speed = 2; // кадров на букву
bubble_visible_chars = 0;

bubble_current_w = 0;
bubble_target_w = 0;
bubble_w_speed = 0;
bubble_w_stiffness = 0.4;
bubble_w_damping = 0.6;

// анимация букв
bubble_char_y = []; // смещение по y для каждой буквы
bubble_char_alpha = []; // прозрачность каждой буквы
bubble_char_y_speed = [];
bubble_char_fall_height = 6; // откуда падает буква


// thanks bubble logic

thanks_bubble_played = false;
thanks_texts = ["Seller_ThanksText1", "Seller_ThanksText2", "Seller_ThanksText3", "Seller_ThanksText4", "Seller_ThanksText5", "Seller_ThanksText6"];

function trigger_thanks_bubble() {
    if (bubble_visible) exit;
    bubble_visible = true;
    bubble_playing = true;
    var key = thanks_texts[irandom(array_length(thanks_texts) - 1)];
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

