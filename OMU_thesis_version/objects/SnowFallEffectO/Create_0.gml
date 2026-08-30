// снегопад для фона мира 2. Ради производительности снежинки — не отдельные инстансы,
// а просто массив данных, который сам объект целиком обновляет и рисует за один проход.

depth = 0;

flakes = [];

max_flakes = 400;
spawn_interval = 1; // кадров между новыми снежинками (пока не достигнут max_flakes)
spawn_timer = 0;

// спавним значительно шире экрана с обеих сторон — тогда даже когда ветер сносит снег
// в одну сторону, с наветренной стороны всегда есть запас, чтобы не оставалось пустот
spawn_min_x = -300;
spawn_max_x = room_width + 300;
spawn_y = -10;

function spawn_snow_flake() {
    var _is_flake = (random(1) < 0.4); // настоящих снежинок меньше, обычного "снега" — больше
    var _f = {
        base_x: random_range(spawn_min_x, spawn_max_x),
        y: spawn_y,
        is_flake: _is_flake,
        frame: _is_flake ? 0 : irandom(3), // у снега кадр — случайный вариант, фиксирован навсегда
        vy: random_range(0.3, 0.6), // падают неспеша
        sway_phase: random(1000),
        sway_speed: random_range(0.025, 0.05),
        sway_amplitude: random_range(3, 8),
        anim_timer: random(1000), // у снежинок — своя фаза цикла анимации, чтобы мерцали не в такт
    };
    array_push(flakes, _f);
}

// сразу заполняем экран снегом на разной высоте, чтобы не начиналось с пустого фона
for (var i = 0; i < max_flakes; i++) {
    spawn_snow_flake();
    flakes[i].y = random_range(0, room_height);
}
