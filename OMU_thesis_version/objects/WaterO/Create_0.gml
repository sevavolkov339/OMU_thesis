water_shader = WaterShd;
water_time = 0;
// размер поверхности воды
water_w = 160;
water_h = 80;
water_surf = surface_create(water_w, water_h);

u_time       = shader_get_uniform(water_shader, "u_time");
u_resolution = shader_get_uniform(water_shader, "u_resolution");
u_color_shallow = shader_get_uniform(water_shader, "u_color_shallow");
u_color_deep    = shader_get_uniform(water_shader, "u_color_deep");