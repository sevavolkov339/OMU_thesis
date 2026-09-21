// пересоздаём surface если она умерла
//if (!surface_exists(surf)) {
//    surf = surface_create(global.gameWidth, global.gameHeight);
//}

//// 1. Рисуем игру на surface
//surface_set_target(surf);
//draw_clear_alpha(c_black, 0);
//draw_surface(application_surface, 0, 0);
//surface_reset_target();

//// 2. Применяем шейдер
//var tex = surface_get_texture(surf);
//var upscale = global.windowWidth / global.gameWidth; // = 1280/384 ≈ 3.33

//shader_set(shd_depixel);
//shader_set_uniform_f(shader_get_uniform(shd_depixel, "u_texel_size"),
//    texture_get_texel_width(tex),
//    texture_get_texel_height(tex));
//shader_set_uniform_f(shader_get_uniform(shd_depixel, "u_upscale"), upscale);
//shader_set_uniform_f(shader_get_uniform(shd_depixel, "u_threshold"), 0.1);

// растягиваем на весь экран GUI
//draw_surface_stretched(surf, 0, 0, global.gameWidth, global.gameHeight);
//shader_reset();