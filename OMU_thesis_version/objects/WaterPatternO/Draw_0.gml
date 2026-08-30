shader_set(shader);
shader_set_uniform_f(u_time, water_time);
draw_self();
shader_reset();