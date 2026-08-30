tide_timer += delta_time / 1000000 * tide_speed;
// ease — sin замедляется на краях, что даёт естественную задержку
x = base_x + sin(tide_timer) * tide_amplitude;