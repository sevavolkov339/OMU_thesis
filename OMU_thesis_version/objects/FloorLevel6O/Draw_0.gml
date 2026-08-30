//var _ox = sprite_get_xoffset(sprite_index);
//var _oy = sprite_get_yoffset(sprite_index);
//draw_set_color(c_black);
//draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_black, 1);
//draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, c_black, 1);


////draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, make_colour_rgb(71, 246, 65), 1);
//draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 1); 

draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, c_black, 1);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, obj_color, 1);