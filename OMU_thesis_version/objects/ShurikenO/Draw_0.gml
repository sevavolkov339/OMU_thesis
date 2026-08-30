if (teleporting && teleport_white > 0) {
   gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha * teleport_white);
    gpu_set_fog(false, 0, 0, 0);
    // рисуем оригинал под ним с обратной прозрачностью
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha * (1 - teleport_white));
} else {
	//if (held && instance_exists(PlayerBallerO)) {
	//    var _p = PlayerBallerO;
	//    if (keyboard_check(vk_space) && _p.holding_obj) {
	//        // во время замаха — рисуем по реальным x/y (управляется из step_play)
	//        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
	//    } else {
	//        // обычное держание — рисуем у игрока
	//        draw_sprite_ext(sprite_index, image_index,
	//            _p.x - 2 * _p.image_xscale,
	//            _p.y - 10,
	//            image_xscale, image_yscale, image_angle, c_white, 1);
	//    }
	//    exit;
	//}
	// обводка
	draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_black, image_alpha);
	draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_black, image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_black, image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, c_black, image_alpha);
	// сам спрайт
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
}