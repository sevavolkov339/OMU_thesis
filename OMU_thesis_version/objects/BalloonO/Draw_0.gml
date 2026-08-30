if (instance_exists(owner)) {
	draw_set_alpha(1);

	// нитка: чёрная обводка + белая линия 1px
	draw_set_color(c_black);
	draw_line_width(x, y, owner.x, owner.y + owner.fly_visual_y, 3);
	draw_set_color(c_white);
	draw_line(x, y, owner.x, owner.y + owner.fly_visual_y);

	// шарик с обводкой
	draw_sprite_ext(BalloonS, 0, x - 1, y,     1, 1, image_angle, c_black, 1);
	draw_sprite_ext(BalloonS, 0, x + 1, y,     1, 1, image_angle, c_black, 1);
	draw_sprite_ext(BalloonS, 0, x,     y - 1, 1, 1, image_angle, c_black, 1);
	draw_sprite_ext(BalloonS, 0, x,     y + 1, 1, 1, image_angle, c_black, 1);
	draw_sprite_ext(BalloonS, 0, x,     y,     1, 1, image_angle, c_white, 1);
}

