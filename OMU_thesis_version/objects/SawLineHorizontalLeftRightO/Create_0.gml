saw_count = 6;
saw_spacing = 15;
saw_mask = [];

// движение
move_speed = 1.5;
move_range = 100; // увеличил расстояние
move_dir = 1;
start_x = x;

// три пресета с одним пробелом из двух пропусков
var presets = [
    [true, true, false, false, true, true, true, true], // пробел посередине ближе к верху
    [true, true, true, false, false, true, true, true], // пробел по центру
    [true, true, true, true, false, false, true, true], // пробел посередине ближе к низу
];

// выбираем рандомный пресет
saw_mask = presets[irandom(array_length(presets) - 1)];

// спавним пилы
saws = array_create(saw_count);
for (var i = 0; i < saw_count; i++) {
    if (saw_mask[i]) {
        var _saw = instance_create_layer(x, y + i * saw_spacing, "EffectsL", SawO);
        saws[i] = _saw;
    } else {
        saws[i] = noone;
    }
}