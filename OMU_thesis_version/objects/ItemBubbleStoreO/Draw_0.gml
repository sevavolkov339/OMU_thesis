var draw_x = x + shake_x;
var draw_y = y;
var bubble_img = popped ? min(pop_timer, sprite_get_number(ItemBubbleS) - 1) : 0;
var bsc_x = popped ? 1 : bubble_scale_x;
var bsc_y = popped ? 1 : bubble_scale_y;

// айтем без squash
if (!popped && item != noone) {
    draw_sprite_ext(item.sprite, 0, draw_x, draw_y, 1, 1, 0, c_white, 1);
}

// бабл со squash поверх
var _mx = matrix_build(draw_x, draw_y, 0, 0, 0, 0, bsc_x, bsc_y, 1);
var _prev = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_multiply(_mx, _prev));
draw_sprite_ext(ItemBubbleS, bubble_img, 0, 0, 1, 1, 0, c_white, 1);
matrix_set(matrix_world, _prev);

// эффект покупки — ПОСЛЕ сброса матрицы
if (bought_effect && bought_visible && item != noone) {
    draw_sprite_ext(item.sprite, 0, x, bought_item_y, 1, 1, 0, c_white, 1);
}