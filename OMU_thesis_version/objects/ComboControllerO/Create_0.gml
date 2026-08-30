// восстанавливаем сохранённые значения
if (instance_exists(GameControllerO)) {
    combo = GameControllerO.saved_combo;
    combo_bar = GameControllerO.saved_combo_bar;
} else {
    combo = 0;
    combo_bar = 0;
}

bar_fill = 5;
drain_base = 0.003;
max_combo = 3;
combo_start_fill[0] = 0;
combo_start_fill[1] = 0.75;
combo_start_fill[2] = 0.5;
combo_start_fill[3] = 0.4;


combo_1_bonus = 1;
combo_2_bonus = 2;
combo_3_bonus = 3;

// сигарета — доп. заполнение шкалы комбо за убийство
cigarette_bar_bonus = 3;

// объявлена в Create, а не в Step — Step здесь может завершиться досрочно (exit) на первых
// кадрах комнаты (например пока враги ещё не заспавнились), и тогда функция, объявленная
// внутри Step, вообще не успела бы определиться к моменту, когда враг попытается её вызвать
function add_kill() {
    var _fill = bar_fill;
    if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Cigarette")) {
        _fill += cigarette_bar_bonus;
    }
    combo_bar = min(combo_bar + _fill, 1);
}