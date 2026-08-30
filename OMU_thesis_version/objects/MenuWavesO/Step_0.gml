tide_timer += delta_time / 1000000 * tide_speed;
x = base_x + sin(tide_timer) * tide_amplitude;