if (GameControllerO.game_paused) exit;

wave_timer += 0.08;

// затухание тряски уже появившихся букв
for (var _i = 0; _i < array_length(char1_shake_timer); _i++) {
    if (char1_shake_timer[_i] > 0) char1_shake_timer[_i]--;
}
for (var _i = 0; _i < array_length(char2_shake_timer); _i++) {
    if (char2_shake_timer[_i] > 0) char2_shake_timer[_i]--;
}

switch (phase) {
    case "intro_delay":
        intro_delay_timer++;
        if (intro_delay_timer >= intro_delay_duration) {
            phase = "typing1";
        }
    break;

    case "typing1":
        if (visible_chars1 < string_length(part1)) {
            print_timer1++;
            if (print_timer1 >= print_speed1) {
                print_timer1 = 0;
                visible_chars1++;
                array_push(char1_shake_timer, char1_shake_duration);
                audio_play_sound(BigTitleTypeSnd, 0, 0);
            }
        } else {
            phase = "pause";
            pause_timer = 0;
        }
    break;

    case "pause":
        pause_timer++;
        if (pause_timer >= pause_duration) {
            phase = "typing2";
        }
    break;

    case "typing2":
        if (visible_chars2 < string_length(part2)) {
            print_timer2++;
            if (print_timer2 >= print_speed2) {
                print_timer2 = 0;
                visible_chars2++;
                array_push(char2_shake_timer, char2_shake_duration);
                audio_play_sound(SmallTitleTypeSnd, 0, 0);
            }
        } else {
            phase = "done";
        }
    break;

    case "done":
        post_done_timer++;
        if (post_done_timer >= post_done_duration) {
            phase = "transitioning"; // защита от повторного вызова
            GameControllerO.title_finished();
        }
    break;
}
