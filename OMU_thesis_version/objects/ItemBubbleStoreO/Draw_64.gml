if (desc_bubble_scale_x > 0.05 && desc_bubble_scale_y > 0.05) {
    var cam = CameraControllerO.cam;
    var cx = camera_get_view_x(cam);
    var cy = camera_get_view_y(cam);
    draw_set_font(SmallFnt);
    var tail_h = sprite_get_height(TextBubbleTailS);
    var gx = round(x - cx);
    var gy = round(y - cy + 22);
    var bw = max(round(desc_bubble_current_w), 4);
    var bh = desc_bubble_h;
    var bcx = gx;
    var bcy = round(gy - bh * 0.5 - tail_h - 16);
    var _bmx = matrix_build(bcx, bcy, 0, 0, 0, 0, desc_bubble_scale_x, desc_bubble_scale_y, 1);
    var _bprev = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_bmx, _bprev));
    var lx = (-bw * 0.5) - 1;
    var ly = -bh * 0.5;
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(lx - 2, ly - 2, lx + bw + 2, ly + bh + 2, false);
    draw_set_color(c_white);
    draw_rectangle(lx - 1, ly - 1, lx + bw + 1, ly + bh + 1, false);
    draw_set_color(c_black);
    draw_rectangle(lx, ly, lx + bw, ly + bh, false);
    draw_sprite_ext(TextBubbleTailS, 0, -17.5, ly + bh + 17, 1, 1, 0, c_white, 1);
    matrix_set(matrix_world, _bprev);
    matrix_set(matrix_world, matrix_build_identity());
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _desc_str = string_copy(desc_bubble_text, 1, desc_bubble_visible_chars);
    var _total_w = string_width(_desc_str);
    var _is_price_page = (desc_bubble_page_index == 0 && !desc_bubble_finished);
    var _icon_w = _is_price_page ? sprite_get_width(apple_icon_sprite) + 2 : 0;
    var _char_x = round(bcx - (_total_w + _icon_w) * 0.5);
    var _char_y = round(bcy - string_height("A") * 0.5) - 1;
    
    // иконка яблока на странице цены
    if (_is_price_page && desc_bubble_visible_chars > 0) {
        var _icon_alpha = (array_length(desc_bubble_char_alpha) > 0) ? desc_bubble_char_alpha[0] : 1;
        var _icon_y_off = (array_length(desc_bubble_char_y) > 0) ? desc_bubble_char_y[0] : 0;
        draw_set_alpha(_icon_alpha * desc_bubble_scale_y);
        draw_sprite_ext(apple_icon_sprite, 0, _char_x + 8, _char_y + _icon_y_off + string_height("A") * 0.5 + 1, 1, 1, 0, c_white, _icon_alpha * desc_bubble_scale_y);
        _char_x += _icon_w;
    }
    
    for (var _i = 0; _i < string_length(_desc_str); _i++) {
        var _ch = string_char_at(_desc_str, _i + 1);
        var _cy_off = (_i < array_length(desc_bubble_char_y)) ? desc_bubble_char_y[_i] : 0;
        var _ca = (_i < array_length(desc_bubble_char_alpha)) ? desc_bubble_char_alpha[_i] : 1;
        draw_set_alpha(_ca * desc_bubble_scale_y);
        draw_set_color(c_black);
        draw_text(_char_x + 1, _char_y + _cy_off, _ch);
        draw_text(_char_x - 1, _char_y + _cy_off, _ch);
        draw_text(_char_x, _char_y + _cy_off + 1, _ch);
        draw_text(_char_x, _char_y + _cy_off - 1, _ch);
        draw_set_color(c_white);
        draw_text(_char_x, _char_y + _cy_off, _ch);
        _char_x += string_width(_ch);
    }
    
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}