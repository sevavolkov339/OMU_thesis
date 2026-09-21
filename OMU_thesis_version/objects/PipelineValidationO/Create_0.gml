// логгер валидационного прогона всего пайплайна разом
//   PipelineValidationO_1 = C1: A* + BSP            PipelineValidationO_3 = C3: flow field + BSP
//   PipelineValidationO_2 = C2: A* + procedural     PipelineValidationO_4 = C4: flow field + procedural
// сохранение во всех четырёх binary + full snapshot

var _me = id;
var _duplicate = false;
with (PipelineValidationO) {
    if (id == _me) continue;
    if (object_index == PipelineValidationO && other.object_index != PipelineValidationO) {
        instance_destroy();
    } else {
        _duplicate = true;
    }
}
if (_duplicate) {
    show_debug_message("pipeline validation: лишний логгер " + object_get_name(object_index) + " убран");
    instance_destroy();
    exit;
}

// --- конфигурация, дочерние объекты перезаписывают её после event_inherited()
cfg_name       = "C1";
cfg_pathfinder = "astar"; // "astar" | "flow"
cfg_generator  = "bsp"; // "bsp" | "proc"
cfg_diag       = false; // true только в диагностических объектах _5/_6 (теневой замер flow field)

// --- файл результатов
results_path = working_directory + "pipeline_validation_c.csv";
if (!file_exists(results_path)) {
    var _f = file_text_open_write(results_path);
    file_text_write_string(_f, "run_id,config,pathfinder,generator,save_format,event,level,walls_requested,walls_achieved,enemy_count,duration_us,size_bytes,over_budget,calls,frames,combat_frames,enemy_frames\n");
    file_text_close(_f);
    show_debug_message("pipeline validation results file created: " + results_path);
}

// run_id уникален для каждого прогона
run_id = 0;
run_has_rows = false; // есть ли строки у текущего run_id - тогда следующий свежий уровень 1 начнёт новый прогон
if (file_exists(results_path)) {
    var _rf = file_text_open_read(results_path);
    var _is_header = true;
    while (!file_text_eof(_rf)) {
        var _line = file_text_read_string(_rf);
        file_text_readln(_rf);
        if (_is_header) { _is_header = false; continue; }
        if (string_length(_line) == 0) continue;
        var _comma = string_pos(",", _line);
        if (_comma <= 0) continue;
        var _rid = real(string_copy(_line, 1, _comma - 1));
        if (_rid > run_id) run_id = _rid;
        run_has_rows = true;
    }
    file_text_close(_rf);
}

frame_budget_us = 16667;

// --- накопитель поиска пути за текущий уровень
acc_level = -1;
acc_us = 0;
acc_calls = 0;
acc_frames = 0;
acc_combat_frames = 0;
acc_enemy_frames = 0;

// --- диагностика flow field (только _5/_6), пишется в отдельный файл
diag_path = working_directory + "pipeline_validation_diag.csv";
acc_diag_builds = 0;
acc_diag_us = 0;
acc_diag_reach = 0;
acc_diag_mismatch = 0;

level1_logged = false; // записан ли уровень 1 текущего прогона - иначе логгер появился слишком поздно
warned_order = false;
warned_generator = false;
announced = false;

function log_row(_event, _level, _wr, _wa, _ec, _us, _size, _calls = 0, _frames = 0, _combat = 0, _efr = 0) {
    var _over = (_event != "pathfinding" && _us > frame_budget_us) ? 1 : 0;
    var _save = instance_exists(GameControllerO) ? GameControllerO.save_format : "unknown";
    var _line = string(run_id) + "," + cfg_name + "," + cfg_pathfinder + "," + cfg_generator + "," + _save + "," +
        _event + "," + string(_level) + "," + string(_wr) + "," + string(_wa) + "," + string(_ec) + "," +
        string(_us) + "," + string(_size) + "," + string(_over) + "," +
        string(_calls) + "," + string(_frames) + "," + string(_combat) + "," + string(_efr) + "\n";
    var _f = file_text_open_append(results_path);
    file_text_write_string(_f, _line);
    file_text_close(_f);
    run_has_rows = true;
}

function flush_pathfinding() {
    // "уровень" без боевых кадров - это хвост после последней двери перед боссом
    if (acc_level >= 1 && acc_combat_frames > 0) {
        log_row("pathfinding", acc_level, 0, 0, 0, acc_us, 0, acc_calls, acc_frames, acc_combat_frames, acc_enemy_frames);
        if (cfg_diag && acc_diag_builds > 0) log_diag_row();
    }
    acc_level = -1;
    acc_us = 0;
    acc_calls = 0;
    acc_frames = 0;
    acc_combat_frames = 0;
    acc_enemy_frames = 0;
    acc_diag_builds = 0;
    acc_diag_us = 0;
    acc_diag_reach = 0;
    acc_diag_mismatch = 0;
}

// накопитель привязан к номеру уровня
function sync_level() {
    var _lvl = GameControllerO.levels_completed + 1;
    if (_lvl != acc_level) {
        flush_pathfinding();
        acc_level = _lvl;
    }
}

// зовётся из EnemyFlyO/Alarm_0 (каждый поиск A*) и SetupPathwayO/Step_0
function add_path_time(_us) {
    if (room != Combat_Room || !instance_exists(GameControllerO)) return;
    if (GameControllerO.game_paused || GameControllerO.slow_mo_timer > 0) return;
    sync_level();
    acc_us += _us;
    acc_calls++;
}

// диагностика (_5/_6): одна строка на уровень в pipeline_validation_diag.csv
function log_diag_row() {
    if (!file_exists(diag_path)) {
        var _h = file_text_open_write(diag_path);
        file_text_write_string(_h, "run_id,config,level,builds,normal_us,shadow_us,reached_cells_sum,mismatches,combat_frames\n");
        file_text_close(_h);
    }
    var _line = string(run_id) + "," + cfg_name + "," + string(acc_level) + "," + string(acc_diag_builds) + "," +
        string(acc_us) + "," + string(acc_diag_us) + "," + string(acc_diag_reach) + "," + string(acc_diag_mismatch) + "," +
        string(acc_combat_frames) + "\n";
    var _f = file_text_open_append(diag_path);
    file_text_write_string(_f, _line);
    file_text_close(_f);
}

// зовётся из SetupPathwayO/Step_0 сразу после обычного построения поля
function add_diag(_us, _reached, _mismatch) {
    if (room != Combat_Room || !instance_exists(GameControllerO)) return;
    if (GameControllerO.game_paused || GameControllerO.slow_mo_timer > 0) return;
    sync_level();
    acc_diag_builds++;
    acc_diag_us += _us;
    acc_diag_reach += _reached;
    acc_diag_mismatch += _mismatch;
}

function log_level_gen(_level, _wr, _wa, _ec, _us) {
    if (_level == 1) {
        // свежий уровень 1 при уже записанном прогоне - новый прогон
        if (run_has_rows) {
            flush_pathfinding();
            run_id++;
            run_has_rows = false;
        }
        level1_logged = true;
    }
    log_row("levelgen", _level, _wr, _wa, _ec, _us, 0);
}
function log_save(_level, _us, _size) {
    log_row("save", _level, 0, 0, 0, _us, _size);
}
function log_load(_level, _us, _size) {
    log_row("load", _level, 0, 0, 0, _us, _size);
}

// звать из MainMenuControllerO при старте НОВОГО прохождения
function start_new_run() {
    flush_pathfinding();
    run_id++;
    run_has_rows = false;
    level1_logged = false;
    show_debug_message("pipeline validation: new run #" + string(run_id) + " (" + cfg_name + ")");
}
