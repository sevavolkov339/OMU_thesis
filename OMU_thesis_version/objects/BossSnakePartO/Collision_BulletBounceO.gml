//if (other.speed <= 0) exit;
//if (!instance_exists(boss_ref)) exit;

//if (!touching_ball) {
//    //touching_ball = true;
//    //hp -= 1;
//    //ShakeScr(id, 4, 0.4);
//    //shake_strength = 3;
//    //shake_duration = 15;
//    //shake_timer = 15;

// отскок мяча
//    //with (other) {
//    //    var surface_normal = collision_normal(x, y, other.id, 8, 2);
//    //    if (surface_normal != -1) {
//    //        var incident_x = lengthdir_x(1, direction);
//    //        var incident_y = lengthdir_y(1, direction);
//    //        var normal_x = lengthdir_x(1, surface_normal);
//    //        var normal_y = lengthdir_y(1, surface_normal);
//    //        var dot = incident_x * normal_x + incident_y * normal_y;
//    //        direction = point_direction(0, 0,
// incident_x - 2 * dot * normal_x
//    //            incident_y - 2 * dot * normal_y);
//    //        speed *= 0.85;
//    //    } else {
//    //        direction = point_direction(other.x, other.y, x, y);
//    //        speed *= 0.85;
//    //    }
//    //}

//    if (hp <= 0) {
//        var _boss = boss_ref;
//        instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
//        _boss.parts[part_index] = noone;
//        instance_destroy();
//    }
	
//    //var _boss = boss_ref;
//    //instance_create_layer(x, y, "EffectsL", ExplosionEnemyEffectO);
//    //_boss.parts[part_index] = noone;
//    //instance_destroy();	
//}