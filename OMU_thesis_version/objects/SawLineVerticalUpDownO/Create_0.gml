saw_count = 6;
saw_spacing = 15;
saw_mask = [];

// движение
move_speed = 1.1; // чуть медленнее, чем у горизонтальной версии
move_range = 100; // увеличил расстояние
move_dir = 1;
start_y = y;

// три пресета с одним пробелом из двух пропусков
// пробел не может быть на краях (индексы 0,1 и 6,7 должны быть заняты)
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
        var _saw = instance_create_layer(x + i * saw_spacing, y, "EffectsL", SawO);
        saws[i] = _saw;
    } else {
        saws[i] = noone;
    }
}