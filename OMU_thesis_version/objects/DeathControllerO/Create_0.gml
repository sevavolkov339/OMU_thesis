// статистика
run_time = GameControllerO.run_time;
items_list = [];
powerups_list = [];
money = GameControllerO.player_money;
// собираем айтемы
if (instance_exists(InventoryControllerO)) {
    var _inv = InventoryControllerO.items;
    for (var i = 0; i < array_length(_inv); i++) {
        if (_inv[i].type != "Heart" && _inv[i].type != "PowerUp") {
            array_push(items_list, _inv[i]);
        }
    }
}
// собираем павер апы
if (instance_exists(PowerUpControllerO)) {
    var _pw = PowerUpControllerO.powerups;
    for (var i = 0; i < array_length(_pw); i++) {
        array_push(powerups_list, _pw[i]);
    }
}
// глаз
eye_x = x;
eye_y = y + 26;
if (array_length(powerups_list) > 0) eye_y += 20;
sway_timer = random(pi * 2);
eye_scale = 1.0;
eye_target_scale = 1.0;
eye_sx = 1.0;
eye_sy = 1.0;
eye_squash_frame = 0;
squash_timer = 0;
squash_fps = 6;
squash_step = 1.0 / squash_fps;
hovered = false;
prev_hovered = false;
gp_active = false;
// анимация появления строк
row_delays = [0, 0.35, 0.7, 1.05, 0.5];
row_alphas = [0, 0, 0, 0, 0];
row_offset_y = [40, 40, 40, 40, 40];
row_offset_y_spd = [0, 0, 0, 0, 0];
row_float_timer = [0, 0.8, 1.6, 2.4, 3.2];
appear_timer = 0;
// счётчики
counter_time = 0;
counter_money = 0;
counter_speed = 0.025;
counter_progress = 0;
// волновой текст
wave_text_timer = 0;
eye_text = Text("Death_Screen_Exit_Button_Text");

function draw_wave_text(str, dx, dy, alpha) {
    if (alpha <= 0.01) exit;
    draw_set_font(SmallFnt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _total_w = string_width(str);
    var _cx = dx - _total_w * 0.5;
    for (var _i = 0; _i < string_length(str); _i++) {
        var _ch = string_char_at(str, _i + 1);
        var _wave_y = sin(wave_text_timer + _i * 0.5) * 2.5;
        draw_set_alpha(alpha);
        draw_set_color(c_white);
        draw_text(_cx, dy + _wave_y, _ch);
        _cx += string_width(_ch);
    }
    draw_set_alpha(1);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function format_time(_seconds) {
    var _m = floor(_seconds / 60);
    var _s = floor(_seconds mod 60);
    var _ms = floor((_seconds - floor(_seconds)) * 100);
    return ((_m < 10) ? "0" : "") + string(_m) + "."
         + ((_s < 10) ? "0" : "") + string(_s) + "."
         + ((_ms < 10) ? "0" : "") + string(_ms);
}