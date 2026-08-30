// Draw Event
shader_set(SpaceShd);
shader_set_uniform_f(shader_get_uniform(SpaceShd, "u_time"), current_time * 0.001);
draw_self(); // просто рисуем спрайт объекта
shader_reset();