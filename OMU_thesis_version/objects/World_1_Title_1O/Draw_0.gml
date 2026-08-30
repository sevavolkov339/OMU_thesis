// первая часть видна, пока не начала печататься вторая — обе части рисуются в одном и том же месте
if (phase == "typing1" || phase == "pause") {
    draw_typed_wave_text(part1, visible_chars1, char1_shake_timer, char1_shake_duration, char1_shake_strength, font1, x, y);
}
draw_typed_wave_text(part2, visible_chars2, char2_shake_timer, char2_shake_duration, char2_shake_strength, font2, x, y);
