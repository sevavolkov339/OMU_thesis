fade_progress = 0;    // 0 = прозрачный, 1 = полностью чёрный
fade_speed = 0;
fade_mode = "none"; // "in" = темнеет, "out" = светлеет
fade_done = false;

// дизер-паттерн Байера 4x4
bayer = [
     0,  8,  2, 10,
    12,  4, 14,  6,
     3, 11,  1,  9,
    15,  7, 13,  5
];

fade_surface = -1;

function fade_in(_speed) {
    fade_mode = "in";
    fade_speed = _speed;
    fade_done = false;
}

function fade_out(_speed) {
    fade_mode = "out";
    fade_speed = _speed;
    fade_done = false;
}

fade_progress = 1; // начинаем с полностью чёрного
fade_out(0.05); // сразу начинаем фейд аут
