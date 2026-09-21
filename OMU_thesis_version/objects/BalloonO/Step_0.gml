//if (GameControllerO.game_paused) exit;

//if (!instance_exists(owner)) {
//    instance_destroy();
//    exit;
//}

// позиция покоя, прямо над игроком
//var rest_x = owner.x;
//var rest_y = owner.y - rope_length;

// пружинная сила к позиции покоя
//var dx = rest_x - x;
//var dy = rest_y - y;
//vel_x += dx * spring_strength;
//vel_y += dy * spring_strength;

// движение игрока тянет шарик в противоположную сторону
//vel_x -= owner.hspeed * 0.25;
//vel_y -= owner.vspeed * 0.25;

// затухание
//vel_x *= damping;
//vel_y *= damping;

//x += vel_x;
//y += vel_y;

// угол спрайта по направлению нитки
//var string_dir = point_direction(owner.x, owner.y, x, y);
//image_angle = string_dir - 90;



if (GameControllerO.game_paused) exit;

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

// флоат, покачивание высоты
float_timer += float_speed;
var float_offset = sin(float_timer) * float_amplitude;

// целевая позиция над игроком с флоатом
var rest_x = owner.x;
var rest_y = owner.y + owner.fly_visual_y - rope_length + float_offset;

// пружина очень мягкая, большой delay
var dx = rest_x - x;
var dy = rest_y - y;
vel_x += dx * spring_strength;
vel_y += dy * spring_strength;

// движение игрока сдвигает шарик в противоположную сторону
vel_x -= owner.hspeed * 0.15;
vel_y -= owner.vspeed * 0.12;

// затухание
vel_x *= damping;
vel_y *= damping;

x += vel_x;
y += vel_y;

// угол нитки, шарик почти не вращается, только чуть-чуть
var string_dir = point_direction(owner.x, owner.y + owner.fly_visual_y, x, y);
var target_angle = string_dir - 90;
image_angle = lerp(image_angle, target_angle * 0.08, 0.05);