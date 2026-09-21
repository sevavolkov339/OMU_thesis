// --- один раз: показать, какая конфигурация реально стоит в игре
if (!announced) {
    announced = true;
    var _label = cfg_name + ": " + (cfg_pathfinder == "flow" ? "flow field" : "A*") + " + "
        + (cfg_generator == "proc" ? "procedural placement" : "BSP");
    window_set_caption("OMU  |  " + _label);
    show_debug_message("pipeline validation " + _label + "  ->  " + results_path);
}

if (room == Combat_Room && instance_exists(GameControllerO)) {

    // --- проверка, что прогон идёт в своей конфигурации; иначе сразу сказать, а не
    if (instance_exists(CombatRoomControllerO)) {
        var _expected = (cfg_generator == "proc") ? GenerateProceduralRoomScr : GenerateBSPRoomScr;
        if (!warned_generator && CombatRoomControllerO.active_generator != _expected) {
            warned_generator = true;
            warned_order = true;
            show_message(cfg_name + ": уровень построен не тем генератором. Логгер появился позже CombatRoomControllerO - поставь его в Main_Menu_Room. Этот прогон не засчитывать.");
        } else if (!warned_order && GameControllerO.levels_completed == 0 && !level1_logged) {
            warned_order = true;
            show_message(cfg_name + ": уровень 1 сгенерирован до появления логгера и не записан. Поставь логгер в Main_Menu_Room (или в начало Instance Creation Order в Combat_Room). Этот прогон не засчитывать.");
        }
    }

    // ловим просадки кадра, не объяснённые самими подсистемами
    // load_game() уже точно мерят себя через get_timer() и сами пишут over_budget в своей строке.
    // это отдельный, более грубый сигнал "игра в целом заикнулась в этот момент"
    // GameControllerO.slow_mo() (урон, вход в дверь) нарочно понижает game_set_speed() - такие кадры
    // не считаем ни просадкой, ни кадрами уровня, и время поиска пути в них тоже не
    if (GameControllerO.slow_mo_timer <= 0) {
        sync_level();
        acc_frames++;
        var _flies = instance_number(EnemyFlyO);
        if (!GameControllerO.game_paused && _flies > 0) {
            acc_combat_frames++;
            acc_enemy_frames += _flies;
        }
        if (delta_time > frame_budget_us) {
            log_row("frame_spike", GameControllerO.levels_completed + 1, 0, 0, _flies, delta_time, 0);
        }
    }
} else if (room != Main_Menu_Room) {
    // уровень закончился не дверью в следующий Combat_Room
    flush_pathfinding();
}
