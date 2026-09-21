//if (instance_exists(PlayerBallerO)) {
//    if (PlayerBallerO.y < y - 10) {
//        layer = layer_get_id("EnemyBulletsL");
//    }
//	else if (PlayerBallerO.y > y - 10){
//        layer = layer_get_id("EffectsL");
//    }
//}

// вращение лопастей по часовой стрелке со ступенчатым эффектом
mill_spin_angle -= mill_spin_speed;
mill_visual_angle = floor(mill_spin_angle / mill_spin_step) * mill_spin_step;

// игрок "зашёл" за мельницу
player_behind_mill = instance_exists(PlayerBallerO) && position_meeting(PlayerBallerO.x, PlayerBallerO.y, id);