// teleporting
if (teleporting) {
    teleport_timer++;
    
    // замораживаем угол и плавно выравниваем к 0
    image_angle = lerp(image_angle, 0, 0.3);
    spin = 0;
    
    // применяем побеление через image_blend
    image_blend = merge_colour(c_black, c_white, teleport_white);
    
    if (teleport_mode == "out") {
        switch (teleport_phase) {
            case 0: // белеет и сплющивается
                teleport_white = 1;
                image_xscale = lerp(image_xscale, teleport_base_xscale * 2.5, 0.3);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 0.1, 0.3);
                if (teleport_timer >= 12) {
                    teleport_phase = 1;
                    teleport_timer = 0;
                }
            break;
            
            case 1: // вытягивается вверх
                image_xscale = lerp(image_xscale, teleport_base_xscale * 0.05, 0.4);
                image_yscale = lerp(image_yscale, teleport_base_yscale * 8, 0.4);
                if (teleport_timer >= 10) {
                    teleport_phase = 2;
                    teleport_timer = 0;
                }
            break;
            
            case 2: // улетает вверх и исчезает
				instance_destroy(BallTrajectoryO)
                y -= 15;
                image_alpha = lerp(image_alpha, 0, 0.2);
                if (image_alpha < 0.05) {
                    image_alpha = 0;
                    teleporting = false;
                    instance_destroy();
                }
            break;
        }
    }
    
	else if (teleport_mode == "in") {
	    switch (teleport_phase) {
	        case 0: // падает сверху вытянутый
	            teleport_white = 1;
	            y += 8;
	            image_alpha = lerp(image_alpha, 1, 0.3);
	            if (teleport_timer >= 10) {
	                image_alpha = 1;
	                teleport_phase = 1;
	                teleport_timer = 0;
	            }
	        break;
        
	        case 1: // сплющивается при приземлении
	            teleport_white = 1;
	            image_xscale = lerp(image_xscale, teleport_base_xscale * 3, 0.4);
	            image_yscale = lerp(image_yscale, teleport_base_yscale * 0.1, 0.4);
	            if (teleport_timer >= 10) {
	                teleport_phase = 2;
	                teleport_timer = 0;
	            }
	        break;
        
	        case 2: // возвращается к нормальной форме с вращением
	            image_xscale = lerp(image_xscale, teleport_base_xscale, 0.2);
	            image_yscale = lerp(image_yscale, teleport_base_yscale, 0.2);
	            teleport_white = lerp(teleport_white, 0, 0.15);
	            image_angle += 100; // активно крутится
	            if (teleport_timer >= 18) {
	                image_xscale = teleport_base_xscale;
	                image_yscale = teleport_base_yscale;
	                image_alpha = 1;
	                teleport_white = 0;
	                image_blend = c_white;
	                teleporting = false;
	                spin = 8;
	            }
	        break;
	    }
	}
    
    exit;
}

// если скорость 0, ничего не делаем
if (speed <= 0) exit;

// трение
speed *= 0.994;
if (speed < min_speed) speed = 0;

// spin
if (spin > 0)
{
    image_angle += 14;
    spin--;
}


// применяем трение (замедление)
//if (speed > 0) {
// speed *= 0.98; // Постепенное замедление
//    if (speed < 0.1) speed = 0; // Останавливаем если слишком медленно
//}

// spin
//if (spin > 0) {
//    image_angle += 14;
//    spin--;
//}

// если мяч не движется - выход
if (speed == 0) exit;

// next pos
var next_x = x + lengthdir_x(speed, direction);
var next_y = y + lengthdir_y(speed, direction);

// флаг столкновения
var collision_occurred = false;
var old_direction = direction;

// wall collision
if (place_meeting(next_x, next_y, wall)) {
    collision_occurred = true;
    
    // нормаль поверхности
    var surface_normal = collision_normal(next_x, next_y, wall, 8, 2);
    
    if (surface_normal != -1) {
        // векторная формула отражения
        var incident_x = lengthdir_x(1, direction);
        var incident_y = lengthdir_y(1, direction);
        var normal_x = lengthdir_x(1, surface_normal);
        var normal_y = lengthdir_y(1, surface_normal);
        
        // скалярное произведение
        var dot = incident_x * normal_x + incident_y * normal_y;
        
        // вектор отражения: R = I - 2*(I·N)*N
        var reflect_x = incident_x - 2 * dot * normal_x;
        var reflect_y = incident_y - 2 * dot * normal_y;
        
        // угол отражения
        direction = point_direction(0, 0, reflect_x, reflect_y);
        
        // небольшая потеря энергии при отскоке
        //speed *= 0.85;
    } else {
        // fallback: простой отскок если нормаль не найдена
        if (place_meeting(x + lengthdir_x(speed, direction), y, wall)) {
            direction = 180 - direction;
        }
        if (place_meeting(x, y + lengthdir_y(speed, direction), wall)) {
            direction = -direction;
        }
        //speed *= 0.85;
    }
    
    // находим точку перед столкновением, а не после
    var safe_distance = 0;
    var max_check = min(speed, 20); // проверяем максимум 20 пикселей
    
    for (var dist = 0; dist <= max_check; dist += 0.5) {
        var check_x = x + lengthdir_x(dist, old_direction);
        var check_y = y + lengthdir_y(dist, old_direction);
        
        if (!place_meeting(check_x, check_y, wall)) {
            safe_distance = dist;
        } else {
            break;
        }
    }
    
    // если нашел безопасную дистанцию перемещается туда
    if (safe_distance > 0) {
        x = x + lengthdir_x(safe_distance, old_direction);
        y = y + lengthdir_y(safe_distance, old_direction);
    }
    
    // проверка застревания в стене после отскока
    if (place_meeting(x, y, wall)) {
        var push_normal = collision_normal(x, y, wall, 8, 2);
        if (push_normal != -1) {
            // отталкивает от стены
            x += lengthdir_x(3, push_normal);
            y += lengthdir_y(3, push_normal);
        } else {
            // если нормаль не найдена отталкиваем в случайном направлении
            x += lengthdir_x(3, random(360));
            y += lengthdir_y(3, random(360));
        }
    }
    
    // позиция после отскока
    next_x = x + lengthdir_x(speed, direction);
    next_y = y + lengthdir_y(speed, direction);
}

// столкновение с врагом
var enemy_hit = instance_place(next_x, next_y, EnemyO);

if (enemy_hit != noone && speed > 0) {
    collision_occurred = true;
    
    // damage once
	if (!enemy_hit.touching_ball) {
	    FreezeScr(100);
	    audio_play_sound(Enemy_Hit_Snd, 0, false);
	    enemy_hit.hp -= 1.5;
	    enemy_hit.shake = 3;
	    enemy_hit.shake_timer = 10;
	    ShakeScr(enemy_hit, 6, 0.6);
	    enemy_hit.touching_ball = true;
	}
    
    // нормаль поверхности врага
    var surface_normal = collision_normal(next_x, next_y, EnemyO, 8, 2);
    
    if (surface_normal != -1) {
        var old_dir = direction;
        
        // векторная формула
        var incident_x = lengthdir_x(1, direction);
        var incident_y = lengthdir_y(1, direction);
        var normal_x = lengthdir_x(1, surface_normal);
        var normal_y = lengthdir_y(1, surface_normal);
        
        var dot = incident_x * normal_x + incident_y * normal_y;
        var reflect_x = incident_x - 2 * dot * normal_x;
        var reflect_y = incident_y - 2 * dot * normal_y;
        
        direction = point_direction(0, 0, reflect_x, reflect_y);
        speed *= 0.85;
        
        // безопасная позицию перед врагом
        var safe_dist = 0;
        var max_check_enemy = min(speed, 15);
        
        for (var d = 0; d <= max_check_enemy; d += 0.5) {
            var check_x = x + lengthdir_x(d, old_dir);
            var check_y = y + lengthdir_y(d, old_dir);
            
            if (!instance_place(check_x, check_y, EnemyO)) {
                safe_dist = d;
            } else {
                break;
            }
        }
        
        if (safe_dist > 0) {
            x = x + lengthdir_x(safe_dist, old_dir);
            y = y + lengthdir_y(safe_dist, old_dir);
        }
        
        // check if stuck in enemy
        var enemy_check = instance_place(x, y, EnemyO);
        if (enemy_check != noone) {
            // отталкиваемся от врага
            var push_dir = point_direction(enemy_check.x, enemy_check.y, x, y);
            x += lengthdir_x(5, push_dir);
            y += lengthdir_y(5, push_dir);
        }
        
        next_x = x + lengthdir_x(speed, direction);
        next_y = y + lengthdir_y(speed, direction);
    } else {
        // fallback
        var old_dir = direction;
        
        if (place_meeting(x + lengthdir_x(speed, direction), y, EnemyO)) {
            direction = 180 - direction;
        }
        if (place_meeting(x, y + lengthdir_y(speed, direction), EnemyO)) {
            direction = -direction;
        }
        speed *= 0.85;
        
        // safe pos
        var safe_dist = 0;
        for (var d = 0; d <= speed; d += 0.5) {
            var check_x = x + lengthdir_x(d, old_dir);
            var check_y = y + lengthdir_y(d, old_dir);
            
            if (!instance_place(check_x, check_y, EnemyO)) {
                safe_dist = d;
            } else {
                break;
            }
        }
        
        if (safe_dist > 0) {
            x = x + lengthdir_x(safe_dist, old_dir);
            y = y + lengthdir_y(safe_dist, old_dir);
        }
        
        next_x = x + lengthdir_x(speed, direction);
        next_y = y + lengthdir_y(speed, direction);
    }
}

// применяем движение только если не было столкновения в этом кадре
if (!collision_occurred || (!place_meeting(next_x, next_y, wall) && instance_place(next_x, next_y, EnemyO) == noone)) {
    x = next_x;
    y = next_y;
} else {
    // если все еще внутри объекта, пробуем отодвинуться
    var attempts = 8;
    for (var i = 1; i <= attempts; i++) {
        var try_x = x + lengthdir_x(i, direction + 180); // пробуем назад
        var try_y = y + lengthdir_y(i, direction + 180);
        
        if (!place_meeting(try_x, try_y, wall) && instance_place(try_x, try_y, EnemyO) == noone) {
            x = try_x;
            y = try_y;
            break;
        }
    }
}




