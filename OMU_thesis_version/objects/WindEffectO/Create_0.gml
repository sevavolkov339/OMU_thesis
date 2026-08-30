// порывы ветра для фона мира 2. Работает в паре со SnowFallEffectO (оба ставятся
// в комнату отдельно) — сносит снег, а также слегка сдувает игрока и кикаемые предметы.
// Сами полосы ветра рисуются в Draw GUI (Draw_64) — всегда поверх всего, независимо от слоёв комнаты.

state = "idle"; // idle -> blowing -> idle -> ...
state_timer = 0;
wait_duration = room_speed * random_range(3, 9); // пауза между порывами
blow_duration = room_speed * 3; // сам порыв длится 3 секунды

wind_dir = choose(-1, 1); // -1 = влево, 1 = вправо
wind_strength = 0; // 0..1, плавно нарастает и спадает, а не щёлкает мгновенно

// сила, с которой ветер сдувает игрока/предметы на полной силе ветра
player_push = 0.15;
item_push = 0.6;
// насколько сильно гасится/прибавляется скорость при движении против/по ветру (на полной силе ветра)
player_headwind_brake = 0.5;
item_headwind_brake = 0.45;
player_tailwind_boost = 0.3;
item_tailwind_boost = 0.25;

// визуальные полосы ветра — считаются сразу в экранных (GUI) координатах, а не в мировых,
// чтобы не зависеть от камеры/масштаба при отрисовке — это чисто декоративный слой
lines = [];
max_lines = 25;
line_spawn_timer = 0;
line_spawn_interval = 4;

function spawn_wind_line() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    // всегда строго горизонтальные — без наклона, и угол зафиксирован раз и навсегда при спавне
    var _dir = (wind_dir > 0) ? 0 : 180;
    var _life_max = room_speed * random_range(0.6, 1.6); // у каждой линии — своя рандомная длительность жизни
    var _len_max = random_range(14, 90); // сильный разброс длины — от коротких штрихов до длинных полос
    var _stretch = (random(1) < 0.5); // часть линий не сразу полной длины, а вытягиваются со временем
    var _l = {
        x: random_range(0, _gw), // по всей площади экрана, а не только у края
        y: random_range(0, _gh),
        len_max: _len_max,
        len: _stretch ? _len_max * random_range(0.15, 0.35) : _len_max,
        dir: _dir,
        spd: random_range(4, 14), // быстрее и с рандомным разбросом скорости у каждой линии
        stretch: _stretch,
        life: _life_max,
        life_max: _life_max,
    };
    array_push(lines, _l);
}

// сразу заполняем экран полосами, чтобы эффект не начинался с пустоты
for (var i = 0; i < max_lines * 0.5; i++) {
    spawn_wind_line();
    lines[i].life = random_range(0, lines[i].life_max);
}
