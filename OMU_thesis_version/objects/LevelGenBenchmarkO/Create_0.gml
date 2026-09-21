methods = [
    { fn: GenerateProceduralRoomScr, name: "procedural" },
    { fn: GenerateBSPRoomScr, name: "bsp" },
    { fn: GenerateWFCRoomScr, name: "wfc" }
];

// fine steps up to the actual cap for this room, plus 50/100 to see
wall_targets = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 50, 100];
trials_per_config = 30;

grid_w = 16;
grid_h = 9;
cell_size = 24;

enemy_target = 4;
chest_target = 1;
item_target = 3;
min_spacing = 1.5;

item_objects = [BombO, BumerangO, OldTvO, PuffFishO, RockO, ShotgunO, ShurikenO, TrashCanO];
enemy_obj = EnemyFly_Test_1_forLevelGen_O;
player_obj = PlayerTestO;

depth = -100; // grid overlay draws above everything else

var _cam = view_camera[0];
origin_x = camera_get_view_x(_cam);
origin_y = camera_get_view_y(_cam);

method_index = 0;
density_index = 0;
trial_index = 0;
state = "generate";
state_timer = 0;
hold_frames = 20;
done = false;

spawned = [];
last_gen_time_us = 0;
last_result = undefined;

total_configs = array_length(methods) * array_length(wall_targets);

results_path = working_directory + "levelgen_benchmark.csv";
var _f = file_text_open_write(results_path);
file_text_write_string(_f, "method,wall_target,trial,gen_time_us,walls_placed,enemies_placed,chest_placed,items_placed\n");
file_text_close(_f);
show_debug_message("levelgen benchmark results file (reset): " + results_path);

function clear_spawned() {
    for (var i = 0; i < array_length(spawned); i++) {
        if (instance_exists(spawned[i])) instance_destroy(spawned[i]);
    }
    spawned = [];
}

function materialize(_spec) {
    for (var i = 0; i < array_length(_spec.floor); i++) {
        var _c = _spec.floor[i];
        array_push(spawned, instance_create_depth(origin_x + _c.gx * cell_size, origin_y + _c.gy * cell_size, 100, FloorTileO));
    }
    for (var i = 0; i < array_length(_spec.walls); i++) {
        var _c = _spec.walls[i];
        array_push(spawned, instance_create_depth(origin_x + _c.gx * cell_size, origin_y + _c.gy * cell_size, 0, _c.obj));
    }
    // player before enemy - enemy_obj reads player pos on create
    array_push(spawned, instance_create_depth(origin_x + _spec.player.gx * cell_size + cell_size / 2, origin_y + _spec.player.gy * cell_size + cell_size / 2, 0, player_obj));
    for (var i = 0; i < array_length(_spec.enemies); i++) {
        var _c = _spec.enemies[i];
        array_push(spawned, instance_create_depth(origin_x + _c.gx * cell_size + cell_size / 2, origin_y + _c.gy * cell_size + cell_size / 2, 0, enemy_obj));
    }
    for (var i = 0; i < array_length(_spec.chest); i++) {
        var _c = _spec.chest[i];
        array_push(spawned, instance_create_depth(origin_x + _c.gx * cell_size + cell_size / 2, origin_y + _c.gy * cell_size + cell_size / 2, 0, BoxChestO));
    }
    for (var i = 0; i < array_length(_spec.items); i++) {
        var _c = _spec.items[i];
        array_push(spawned, instance_create_depth(origin_x + _c.gx * cell_size + cell_size / 2, origin_y + _c.gy * cell_size + cell_size / 2, 0, _c.obj));
    }
}

function draw_outlined(_x, _y, _text) {
    draw_set_color(c_black);
    draw_text(_x - 1, _y - 1, _text);
    draw_text(_x,     _y - 1, _text);
    draw_text(_x + 1, _y - 1, _text);
    draw_text(_x - 1, _y,     _text);
    draw_text(_x + 1, _y,     _text);
    draw_text(_x - 1, _y + 1, _text);
    draw_text(_x,     _y + 1, _text);
    draw_text(_x + 1, _y + 1, _text);
    draw_set_color(c_white);
    draw_text(_x, _y, _text);
}
