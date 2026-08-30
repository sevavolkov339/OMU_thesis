shader_set(water_shader);
shader_set_uniform_f(u_time, water_time);
shader_set_uniform_f(u_resolution, water_w, water_h);
// цвета воды — можешь менять
	//shader_set_uniform_f(u_color_shallow, 0.4, 0.8, 1.0, 1.0); // светло-голубой
	//shader_set_uniform_f(u_color_deep,    0.0, 0.2, 0.5, 1.0); // тёмно-синий
shader_set_uniform_f(u_color_shallow, 1.0, 1.0, 1.0, 1.0); // белый
shader_set_uniform_f(u_color_deep,    0.0, 0.0, 0.0, 1.0); // чёрный
draw_surface(water_surf, x, y);
shader_reset();