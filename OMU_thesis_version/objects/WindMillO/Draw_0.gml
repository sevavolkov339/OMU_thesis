// чёрная обводка в 1 пиксель — рисуем со смещением в 4 стороны (image_index уже учитывает текущий кадр анимации)
var _offset = 1;
var _offsets = [[-_offset,0],[_offset,0],[0,-_offset],[0,_offset]];
for (var i = 0; i < 4; i++) {
    draw_sprite_ext(sprite_index, image_index,
        x + _offsets[i][0], y + _offsets[i][1],
        image_xscale, image_yscale, image_angle, c_black, 1);
}

// оригинал
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);

// лопасти мельницы поверх башни — тоже с чёрной обводкой в 1 пиксель, вращаются со ступенчатым эффектом
var _mill_y = y - 60;
for (var i = 0; i < 4; i++) {
    draw_sprite_ext(BigMill_MillS, 0,
        x + _offsets[i][0], _mill_y + _offsets[i][1],
        1, 1, mill_visual_angle, c_black, 1);
}
draw_sprite_ext(BigMill_MillS, 0, x, _mill_y, 1, 1, mill_visual_angle, c_white, 1);

// подготовка силуэта игрока — обрезаем его по маске самой мельницы (перекрытие альфа-каналов), без диттеринга.
// сам вывод происходит в Draw GUI (Draw_64.gml), чтобы силуэт был виден всегда поверх всего.
// сама мельница (башня + лопасти) при этом продолжает рисоваться как обычно выше, на слое HandsL — тут её видимый рендер не трогаем.
if (player_behind_mill && instance_exists(PlayerBallerO)) {
    var _p = PlayerBallerO;
    // surface размером точно под квад спрайта игрока (с учётом масштаба) — второй проход блендинга
    // покрывает тогда весь surface целиком, и от маски мельницы нигде не остаётся "хвостов" за пределами силуэта игрока
    var _sw = max(1, ceil(sprite_get_width(_p.sprite_index) * abs(_p.image_xscale)));
    var _sh = max(1, ceil(sprite_get_height(_p.sprite_index) * abs(_p.image_yscale)));

    if (!surface_exists(silhouette_surf)) {
        silhouette_surf = surface_create(_sw, _sh);
    } else if (surface_get_width(silhouette_surf) != _sw || surface_get_height(silhouette_surf) != _sh) {
        surface_resize(silhouette_surf, _sw, _sh);
    }

    var _local_cx = _sw * 0.5;
    var _local_cy = _sh * 0.5;

    surface_set_target(silhouette_surf);
    draw_clear_alpha(c_black, 0);

    // 1) сначала рисуем чёрный силуэт игрока обычным alpha-блендингом — так прозрачные пиксели
    // спрайта корректно остаются (0,0,0,0), без "мусорного" цвета в альфа-канале (это и давало странный квадрат по краям)
    draw_sprite_ext(_p.sprite_index, _p.image_index,
        _local_cx, _local_cy,
        _p.image_xscale, _p.image_yscale, 0, c_black, 1);

    // 2) затем накладываем маску мельницы как множитель: результат = силуэт_игрока * альфа_мельницы,
    // цвет самой мельницы при этом отбрасывается (src=bm_zero)
    gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
    draw_sprite_ext(sprite_index, image_index,
        _local_cx + (x - _p.x), _local_cy + (y - _p.y),
        image_xscale, image_yscale, image_angle, c_white, 1);
    gpu_set_blendmode(bm_normal);

    surface_reset_target();

    silhouette_origin_x = _p.x - _local_cx;
    silhouette_origin_y = _p.y - _local_cy;
}