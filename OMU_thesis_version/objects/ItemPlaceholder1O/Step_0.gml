//if (GameControllerO.game_paused) exit;

//// анимация сбора
//if (collecting) {
//    squish_x = lerp(squish_x, 2.5, 0.2);
//    squish_y = lerp(squish_y, 0, 0.2);
//    squish_white = lerp(squish_white, 1, 0.15);
//    image_xscale = squish_x;
//    image_yscale = squish_y;
//    if (squish_white > 0.95) {
//        if (instance_exists(InventoryControllerO)) {
//            var all_items = EveryItemScr();
//            for (var _i = 0; _i < array_length(all_items); _i++) {
//                if (all_items[_i].obj == object_index) {
//                    InventoryControllerO.add_item(all_items[_i]);
//                    break;
//                }
//            }
//        }
//        gpu_set_fog(false, c_white, 0, 0);
//        instance_destroy();
//    }
//    exit;
//}
//// движение
//if (place_meeting(x + vx, y, WallO)) vx = -vx;
//if (place_meeting(x, y + vy, WallO)) vy = -vy;
//x += vx;
//y += vy;
//vx *= 0.95;
//vy *= 0.95;

//// проверка касания игрока
//if (instance_exists(PlayerBallerO)) {
//    if (place_meeting(x, y, PlayerBallerO)) {
//        collecting = true;
//    }
//}