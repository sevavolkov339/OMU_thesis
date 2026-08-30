// рисуем сердце внутри пока не лопнул
if (!popped) {
    draw_sprite_ext(HealthS, 0, x, y, 1, 1, 0, c_white, 1);
}
// рисуем бабл поверх
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, 1);