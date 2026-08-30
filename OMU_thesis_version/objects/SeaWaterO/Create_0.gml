water_shader = WaterShd;
water_time = 0;
// размер поверхности воды
water_w = 384;
water_h = 216;
water_surf = surface_create(water_w, water_h);

u_time       = shader_get_uniform(water_shader, "u_time");
u_resolution = shader_get_uniform(water_shader, "u_resolution");
u_color_shallow = shader_get_uniform(water_shader, "u_color_shallow");
u_color_deep    = shader_get_uniform(water_shader, "u_color_deep");

x = 384;
y = 216;