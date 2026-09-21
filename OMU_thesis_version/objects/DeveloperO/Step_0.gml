if (GameControllerO.game_paused) exit;

// анимация уже напечатанных букв, отдельно для каждой строки
for (var _li = 0; _li < array_length(line_char_y); _li++) {
    var _cy = line_char_y[_li];
    var _cys = line_char_y_speed[_li];
    var _ca = line_char_alpha[_li];
    for (var _i = 0; _i < array_length(_cy); _i++) {
        var _dy = -_cy[_i];
        _cys[_i] += _dy * 0.4;
        _cys[_i] *= 0.55;
        _cy[_i] += _cys[_i];
        _ca[_i] = min(_ca[_i] + 0.15, 1);
    }
}

switch (state) {
    case "typing":
        var _cur_text = lines[current_line];
        if (visible_chars < string_length(_cur_text)) {
            print_timer++;
            if (print_timer >= print_speed) {
                print_timer = 0;
                visible_chars++;
                array_push(line_char_y[current_line], char_fall_height);
                array_push(line_char_alpha[current_line], 0);
                array_push(line_char_y_speed[current_line], 0);
            }
        } else if (current_line < array_length(lines) - 1) {
            current_line++;
            visible_chars = 0;
            print_timer = 0;
        } else {
            state = "done";
        }
    break;

    case "done":
        post_done_timer++;
        if (post_done_timer >= post_done_duration) {
            state = "exiting"; // защита от повторного вызова
            // ран пройден полностью (босс побеждён) - чистим сейв так же, как при смерти в
            if (GameControllerO.save_slot >= 0) {
                GameControllerO.delete_save(GameControllerO.save_slot);
            }
            GameControllerO.reset_run();
            GameControllerO.save_slot = -1;
            room_goto(Main_Menu_Room);
        }
    break;
}
