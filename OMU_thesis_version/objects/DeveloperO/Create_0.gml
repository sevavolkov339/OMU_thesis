// текст берём по id, как и остальные тексты в игре
talk_texts = ["Developer_TalkText1"];
var _key = talk_texts[irandom(array_length(talk_texts) - 1)];
var _full = Text(_key);
lines = string_split(_full, "|");

font = SmallFnt;
line_height = string_height("A") - 4;

// печать по буквам, построчно
current_line = 0;
visible_chars = 0;
print_timer = 0;
print_speed = 2;

// анимация появления букв, отдельный набор на каждую строку
line_char_y = [];
line_char_alpha = [];
line_char_y_speed = [];
for (var _i = 0; _i < array_length(lines); _i++) {
    array_push(line_char_y, []);
    array_push(line_char_alpha, []);
    array_push(line_char_y_speed, []);
}
char_fall_height = 6;

state = "typing"; // typing -> done -> exiting (через 3 сек после done уходим в меню)
post_done_timer = 0;
post_done_duration = round(room_speed * 3);
