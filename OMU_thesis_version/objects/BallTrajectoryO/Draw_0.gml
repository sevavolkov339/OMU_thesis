



// pause
if (GameControllerO.game_paused) exit;





if (!instance_exists(BulletBounceO)) exit;
if (global.alphadinamic <= 0) exit;

draw_set_alpha(global.alphadinamic);
var max_length = 1000;
var step = 2;
var line_width = 6;

// first line
var x_start = BulletBounceO.x;
var y_start = BulletBounceO.y;
var angle = point_direction(x_start, y_start, mouse_x, mouse_y);
var length = 0;
var hit = false;
var x_end, y_end;
var surface_normal = -1;

// точный поиск столкновения с учетом нормали
while (length < max_length) {
    var tx = x_start + lengthdir_x(length, angle);
    var ty = y_start + lengthdir_y(length, angle);
    
    // проверяем столкновение и получаем нормаль поверхности
    var normal_check = collision_normal(tx, ty, wall, 8, 2);
    if (normal_check != -1) {
        hit = true;
        surface_normal = normal_check;
        
        // точная подгонка к поверхности
        for (var i = 0; i < 10; i++) {
            length -= 0.5;
            tx = x_start + lengthdir_x(length, angle);
            ty = y_start + lengthdir_y(length, angle);
            
            var new_normal = collision_normal(tx, ty, wall, 8, 2);
            if (new_normal == -1) {
                length += 0.5; // возвращаемся к столкновению
                break;
            }
            surface_normal = new_normal; // обновляем нормаль
        }
        break;
    }
    length += step;
}

// если столкновение не найдено, рисуем до конца
if (!hit) {
    length = max_length;
    x_end = x_start + lengthdir_x(length, angle);
    y_end = y_start + lengthdir_y(length, angle);
} else {
    // точка столкновения (точно на поверхности)
    x_end = x_start + lengthdir_x(length, angle);
    y_end = y_start + lengthdir_y(length, angle);
}

// рисуем первую линию
var dx = x_end - x_start;
var dy = y_end - y_start;
var dist = point_distance(x_start, y_start, x_end, y_end);
if (dist > 0) {
    var ox = (line_width / 2) * -dy / dist;
    var oy = (line_width / 2) * dx / dist;
    
	
	draw_set_color(c_white);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(x_start + ox, y_start + oy);
    draw_vertex(x_start - ox, y_start - oy);
    draw_vertex(x_end - ox, y_end - oy);
    draw_vertex(x_end + ox, y_end + oy);
    draw_primitive_end();
}

// reflecting
if (!hit || surface_normal == -1) {
    draw_set_alpha(1);
    exit;
}

// используем векторную формулу отражения для большей точности
var incident_x = lengthdir_x(1, angle);
var incident_y = lengthdir_y(1, angle);
var normal_x = lengthdir_x(1, surface_normal);
var normal_y = lengthdir_y(1, surface_normal);

// скалярное произведение
var dot = incident_x * normal_x + incident_y * normal_y;

// вектор отражения: R = I - 2*(I·N)*N
var reflect_x = incident_x - 2 * dot * normal_x;
var reflect_y = incident_y - 2 * dot * normal_y;

// угол отражения
var angle_2 = point_direction(0, 0, reflect_x, reflect_y);

// отладочное сообщение
show_debug_message("Первая линия: угол=" + string(angle) + ", нормаль=" + string(surface_normal) + 
                  ", отражение=" + string(angle_2));




// second line
var offset_dist = 2; // маленькое смещение от стены
var x_start_2 = x_end + lengthdir_x(offset_dist, angle_2);
var y_start_2 = y_end + lengthdir_y(offset_dist, angle_2);

var length_2 = 0;
var hit_2 = false;
var x_end_2, y_end_2;
var surface_normal_2 = -1;

// поиск второго столкновения
while (length_2 < max_length) {
    var tx2 = x_start_2 + lengthdir_x(length_2, angle_2);
    var ty2 = y_start_2 + lengthdir_y(length_2, angle_2);
    
    // проверяем, не вернулись ли мы к первой точке
    if (point_distance(tx2, ty2, x_end, y_end) < 5) {
        length_2 += step;
        continue;
    }
    
    var normal_check_2 = collision_normal(tx2, ty2, wall, 8, 2);
    if (normal_check_2 != -1) {
        hit_2 = true;
        surface_normal_2 = normal_check_2;
        
        // точная подгонка к поверхности
        for (var i = 0; i < 10; i++) {
            length_2 -= 0.5;
            tx2 = x_start_2 + lengthdir_x(length_2, angle_2);
            ty2 = y_start_2 + lengthdir_y(length_2, angle_2);
            
            var new_normal_2 = collision_normal(tx2, ty2, wall, 8, 2);
            if (new_normal_2 == -1) {
                length_2 += 0.5;
                break;
            }
            surface_normal_2 = new_normal_2;
        }
        break;
    }
    length_2 += step;
}

// если второго столкновения нет, рисуем до конца
if (!hit_2) {
    length_2 = max_length;
    x_end_2 = x_start_2 + lengthdir_x(length_2, angle_2);
    y_end_2 = y_start_2 + lengthdir_y(length_2, angle_2);
} else {
    // точка столкновения (точно на поверхности)
    x_end_2 = x_start_2 + lengthdir_x(length_2, angle_2);
    y_end_2 = y_start_2 + lengthdir_y(length_2, angle_2);
}

// отладочное сообщение для второй линии
show_debug_message("Вторая линия: начало=(" + string(x_start_2) + "," + string(y_start_2) + 
                  "), конец=(" + string(x_end_2) + "," + string(y_end_2) + 
                  "), длина=" + string(length_2));

// рисуем вторую линию
var dx2 = x_end_2 - x_start_2;
var dy2 = y_end_2 - y_start_2;
var dist2 = point_distance(x_start_2, y_start_2, x_end_2, y_end_2);

if (dist2 > 0) {
    var ox2 = (line_width / 2) * -dy2 / dist2;
    var oy2 = (line_width / 2) * dx2 / dist2;
    
    // проверяем, не слишком ли короткая линия
    if (dist2 > 1) {
		draw_set_color(c_white);
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(x_start_2 + ox2, y_start_2 + oy2);
        draw_vertex(x_start_2 - ox2, y_start_2 - oy2);
        draw_vertex(x_end_2 - ox2, y_end_2 - oy2);
        draw_vertex(x_end_2 + ox2, y_end_2 + oy2);
        draw_primitive_end();
    }
    
    // отладочные маркеры
    //draw_set_color(c_yellow);
    //draw_circle(x_start_2, y_start_2, 3, false); // Начало второй линии
    //draw_set_color(c_green);
    //draw_circle(x_end_2, y_end_2, 3, false); // Конец второй линии
}



draw_set_alpha(1);


// визуализация нормалей (для отладки)
//draw_set_color(c_red);
//draw_line_width(x_end, y_end, 
// x_end + lengthdir_x(30, surface_normal)
//                y_end + lengthdir_y(30, surface_normal), 2);
//draw_text(x_end + 10, y_end + 10, "N1: " + string(round(surface_normal)));

//if (hit_2 && surface_normal_2 != -1) {
//    draw_set_color(c_blue);
//    draw_line_width(x_end_2, y_end_2, 
// x_end_2 + lengthdir_x(30, surface_normal_2)
//                    y_end_2 + lengthdir_y(30, surface_normal_2), 2);
//    draw_text(x_end_2 + 10, y_end_2 + 10, "N2: " + string(round(surface_normal_2)));
//}

// визуализация направления отражения
//draw_set_color(c_lime);
//draw_line_width(x_end, y_end, 
// x_end + lengthdir_x(40, angle_2)
//                y_end + lengthdir_y(40, angle_2), 1);
//draw_text(x_end + 20, y_end + 20, "Ref: " + string(round(angle_2)));

