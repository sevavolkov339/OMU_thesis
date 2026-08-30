var _mx = matrix_build(x, y, 0, 0, 0, 0, bubble_scale_x, bubble_scale_y, 1);
var _prev = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_multiply(_mx, _prev));
draw_sprite(PowerUpBubbleS, image_index, 0, 0);
if (!popped && item != noone) {
    draw_sprite(item.sprite, 0, 0, 0);
}
matrix_set(matrix_world, _prev);