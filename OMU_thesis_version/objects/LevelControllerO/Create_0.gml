
// for loading game
//GameControllerO.apply_pending_inventory_and_powerups();

inventory_applied = false;


// settings
min_enemies = 1;
max_enemies = 10;
enemy_types = [
    EnemyFlowerO,
    EnemyFlyO,
	EnemyJawO,
	EnemySpitterO
];

min_objects = 1;
max_objects = 4;
object_types = [
    OldTvO,
    RockO,
    TrashCanO,
	ShurikenO,
	BombO,
	ShotgunO,
	BumerangO,
	PuffFishO
];
// STATES
enemies_spawned = false;
level_completed = false;
boss_objects_spawned = false; // отдельный флаг для спавна предметов в комнате босса (см. Step_0.gml)
// WORLDS
current_world_index = -1;
current_world_rooms = [];
current_room = room;
// level Counter
//levels_completed = 0;
//shop_every_n_levels = 6;
// other
slowing_down = false;
// functions
//{
//    current_world_index = irandom(array_length(worlds) - 1);
//    current_world_rooms = worlds[current_world_index];
//    show_debug_message("World changed to index: " + string(current_world_index));
//}
// function change_room()
//{
//    if (array_length(current_world_rooms) == 0)
//    {
//        show_debug_message("ERROR: world has no rooms");
//        return;
//    }
    
//    var coming_from_shop = (current_room == World_1_Store);
    
//    var next_room = current_room;
//    if (array_length(current_world_rooms) > 1)
//    {
//        while (next_room == current_room || next_room == World_1_Store)
//        {
//            next_room = current_world_rooms[irandom(array_length(current_world_rooms) - 1)];
//        }
//    }
//    else
//    {
//        next_room = current_world_rooms[0];
//    }
    
//    if (!coming_from_shop)
//    {
//        GameControllerO.levels_completed += 1;
//        show_debug_message("Levels completed: " + string(GameControllerO.levels_completed));
//    }
    
//    if (!coming_from_shop && GameControllerO.levels_completed % GameControllerO.shop_every_n_levels == 0)
//    {
//        current_room = World_1_Store;
//        room_goto(World_1_Store);
//        return;
//    }
    
//    current_room = next_room;
//    room_goto(next_room);
//}
function on_cutscene_finished()
{
    with (EffectsControllerO)
    {
        stop_elevator_effect();
    }
}
function start_level() {
    if (GameControllerO.coming_from_transition) {
        GameControllerO.coming_from_transition = false;
        instance_create_layer(0, 0, "UIL", FadeTransitionWhiteO);
    } else if (room != World_1_TransitionRoom && room != Death_Room) {
        instance_create_layer(0, 0, "UIL", FadeTransitionO);
    }
    //instance_create_layer(0, 0, "UIL", FadeTransitionO);
    ball_spawned = false;
    instance_create_layer(x, y, "UIL", CursorHandO);
    instance_create_layer(x, y, "UIL", AllBlackO);
    show_debug_message("ElevatorParent instances: " + string(instance_number(ElevatorParentO)));
    level_completed = false;
    enemies_spawned = false;
    var lifts = [];
    with (ElevatorParentO)
    {
        if (exitable && !used)
            array_push(lifts, id);
    }
    if (array_length(lifts) == 0)
    {
        show_debug_message("ERROR: no exitable elevators");
        return;
    }
    var lift = lifts[irandom(array_length(lifts) - 1)];
    lift.used = true;
    show_debug_message("elevator used: " + string(lift));
    instance_create_layer(x, y, "PlayerL", PlayerBallerO);
    with (PlayerBallerO)
    {
        x = lift.x;
        y = lift.y;
        start_elevator_exit(lift);
    }
    with (lift)
    {
        start_arrive_cutscene();
    }
    if (instance_exists(CameraControllerO))
    {
        with (CameraControllerO)
            camera_move_and_follow_object(lift, 0);
    }
}
//change_world();
level_started = false;
ball_spawned = false;

// сигарета: если этот уровень должен нанести отложенный урон
cigarette_hit_timer = -1;
if (instance_exists(GameControllerO)
    && variable_instance_exists(GameControllerO, "cigarette_pending_hit")
    && GameControllerO.cigarette_pending_hit) {
    GameControllerO.cigarette_pending_hit = false;
    cigarette_hit_timer = 1.5;
}