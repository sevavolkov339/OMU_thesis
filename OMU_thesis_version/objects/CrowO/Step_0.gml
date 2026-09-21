if (GameControllerO.game_paused) exit;

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

// если игрок обогнал ворону и оказался по другую сторону от неё, она перелетает
var _dx_player_crow = owner.x - x;
if (_dx_player_crow < -perch_switch_margin) {
    perch_side = 1; // игрок левее вороны, ворона летает справа от игрока
} else if (_dx_player_crow > perch_switch_margin) {
    perch_side = -1; // игрок правее вороны, ворона летает слева от игрока
}
var _perch_angle = (perch_side > 0 ? 0 : 180) + perch_angle_jitter;
perch_offset_x = lengthdir_x(perch_dist, _perch_angle);
perch_offset_y = lengthdir_y(perch_dist, _perch_angle);

// "домашняя" точка, рядом с игроком, с лёгким покачиванием в стороны, а не полёт
wander_phase_x += wander_speed_x;
wander_phase_y += wander_speed_y;
var _home_x = owner.x + perch_offset_x + sin(wander_phase_x) * wander_amp;
var _home_y = owner.y + owner.fly_visual_y + perch_offset_y + cos(wander_phase_y) * wander_amp;

switch (state) {
    case "hover":
        // подтягивается к своей точке с небольшой задержкой
        x = lerp(x, _home_x, follow_lerp);
        y = lerp(y, _home_y, follow_lerp);

        // ищем ближайшего врага в поле зрения
        var _nearest = noone;
        var _nearest_dist = vision_radius;
        with (EnemyO) {
            var _d = point_distance(other.x, other.y, x, y);
            if (_d <= _nearest_dist) {
                _nearest_dist = _d;
                _nearest = id;
            }
        }
        if (_nearest != noone) {
            target_enemy = _nearest;
            state = "charging";
        }
    break;

    case "charging":
        // враг пропал или убежал слишком далеко, прекращаем погоню и летим домой
        if (!instance_exists(target_enemy) || point_distance(x, y, target_enemy.x, target_enemy.y) > vision_radius * 5) {
            target_enemy = noone;
            state = "returning";
            break;
        }

        var _dir = point_direction(x, y, target_enemy.x, target_enemy.y);
        x += lengthdir_x(charge_speed, _dir);
        y += lengthdir_y(charge_speed, _dir);
        image_xscale = (lengthdir_x(1, _dir) >= 0) ? 1 : -1;

        // урон наносится только здесь
        if (point_distance(x, y, target_enemy.x, target_enemy.y) <= arrive_dist || place_meeting(x, y, target_enemy)) {
            // долетела, один удар и обратно на исходную точку
            audio_play_sound(Enemy_Hit_Snd, 0, 0);
            var _dmg = damage;
            if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
            target_enemy.hp -= _dmg;
            var _dmg_popup = instance_create_layer(target_enemy.x, target_enemy.y - 20, "DeadL", DamageO);
            _dmg_popup.dmg = _dmg;
            ShakeScr(target_enemy, 6, 0.6);

            target_enemy = noone;
            state = "returning";
        }
    break;

    case "returning":
        var _dir2 = point_direction(x, y, _home_x, _home_y);
        x += lengthdir_x(return_speed, _dir2);
        y += lengthdir_y(return_speed, _dir2);
        image_xscale = (lengthdir_x(1, _dir2) >= 0) ? 1 : -1;

        // вернулась, можно снова искать врагов и бить в них, пока они в радиусе
        if (point_distance(x, y, _home_x, _home_y) <= arrive_dist) {
            state = "hover";
        }
    break;
}
