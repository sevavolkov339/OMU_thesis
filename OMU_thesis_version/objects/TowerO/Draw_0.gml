// чёрная обводка в 1 пиксель, рисуем со смещением в 4 стороны
var _offset = 1;
var _offsets = [[-_offset,0],[_offset,0],[0,-_offset],[0,_offset]];
for (var i = 0; i < 4; i++) {
    draw_sprite_ext(sprite_index, image_index,
        x + _offsets[i][0], y + _offsets[i][1],
        image_xscale, image_yscale, image_angle, c_black, 1);
}

// оригинал
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);