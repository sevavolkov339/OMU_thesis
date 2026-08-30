//var _surf = surface_create(
//    sprite_get_width(sprite_index) + 2,
//    sprite_get_height(sprite_index) + 2
//);
//surface_set_target(_surf);
//draw_clear_alpha(0, 0);

//var _ox = sprite_get_xoffset(sprite_index) + 1;
//var _oy = sprite_get_yoffset(sprite_index) + 1;

//draw_sprite_ext(sprite_index, image_index, _ox - 1, _oy, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, _ox + 1, _oy, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, _ox, _oy - 1, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, _ox, _oy + 1, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, _ox, _oy, image_xscale, image_yscale, image_angle, c_white, 1);

//surface_reset_target();

//draw_surface_ext(_surf,
//    x - sprite_get_xoffset(sprite_index) - 1,
//    y - sprite_get_yoffset(sprite_index) - 1,
//    1, 1, 0, c_white, image_alpha);
//surface_free(_surf);

// тень под игроком — рисуется здесь (не в Draw GUI), чтобы не отставать от позиции игрока.
// тень остаётся на земле даже во время полёта — поэтому рисуется по настоящим x,y,
// а сам игрок ниже рисуется со смещением fly_visual_y (визуальный подъём в воздух).
// Пропадает, пока игрок в хот-спринг бассейне (под водой тени не видно), и пока он летит
// над пропастью — над тем местом, где нет пола (там просто не на что её отбрасывать)
var _shadow_in_water = place_meeting(x, y, ChillTriggerO);
var _shadow_off_floor = flying && !place_meeting(x, y, floor_objects);
if (!_shadow_in_water && !_shadow_off_floor) {
    draw_sprite(PlayerBallerShadowS, 0, x, y);
}

draw_sprite_ext(sprite_index, image_index, x, y + fly_visual_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// стрелка направления удара для геймпада — следует по кругу вокруг игрока за правым стиком
var _gp = gamepad_index;
if (variable_global_exists("using_gamepad") && global.using_gamepad && gamepad_is_connected(_gp)) {
    var _rx = gamepad_axis_value(_gp, gp_axisrh);
    var _ry = gamepad_axis_value(_gp, gp_axisrv);
    var _deadzone = 0.2;
    if (abs(_rx) > _deadzone || abs(_ry) > _deadzone) {
        var _dir = point_direction(0, 0, _rx, _ry);
        var _radius = 28;
        var _ax = x + lengthdir_x(_radius, _dir);
        var _ay = y + lengthdir_y(_radius, _dir);
        var _arrow_angle = _dir + 90; // спрайт по умолчанию смотрит вниз

        // чёрная обводка в 1 пиксель
        var _o = 1;
        draw_sprite_ext(PlayerKickDirectionArrowS, 0, _ax - _o, _ay, 1, 1, _arrow_angle, c_black, 1);
        draw_sprite_ext(PlayerKickDirectionArrowS, 0, _ax + _o, _ay, 1, 1, _arrow_angle, c_black, 1);
        draw_sprite_ext(PlayerKickDirectionArrowS, 0, _ax, _ay - _o, 1, 1, _arrow_angle, c_black, 1);
        draw_sprite_ext(PlayerKickDirectionArrowS, 0, _ax, _ay + _o, 1, 1, _arrow_angle, c_black, 1);

        draw_sprite_ext(PlayerKickDirectionArrowS, 0, _ax, _ay, 1, 1, _arrow_angle, c_white, 1);
    }
}
