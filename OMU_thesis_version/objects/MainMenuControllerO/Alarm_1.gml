//GameControllerO.reset_run();
//GameControllerO.change_room();

if (!is_undefined(global.pending_room_name)) {
    var _room_id = asset_get_index(global.pending_room_name);
    global.pending_room_name = undefined;
    room_goto(_room_id);
} else {
    // новая игра всегда начинается с первого титульного экрана мира
    room_goto(World_1_Title_1_Room);
}