if (GameControllerO.game_paused)
{

    speed = 0;
    hspeed = 0;
    vspeed = 0;
	image_speed = 0;

    exit;
}


if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

// вектор от йойо к игроку
var _owner_y = owner.y + owner.fly_visual_y;
var dx = owner.x - x;
var dy = _owner_y - y;
var dist = point_distance(x, y, owner.x, _owner_y);

// пружина начинает тянуть только когда верёвка натянута
if (dist > rope_length) {
    var pull = (dist - rope_length) / dist;
    vel_x += dx * pull * spring_strength;
    vel_y += dy * pull * spring_strength;
}

// инерция и трение
vel_x *= friction_spd;
vel_y *= friction_spd;

// столкновение с врагом
var _spd = point_distance(0, 0, vel_x, vel_y);
var _enemy_hit = instance_place(x + vel_x, y + vel_y, EnemyO);
if (_enemy_hit != noone && _spd > 0.5) {
    // урон
    if (!_enemy_hit.touching_ball) {
        FreezeScr(100);
        audio_play_sound(Enemy_Hit_Snd, 0, false);
        var _dmg = 1;
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
        _enemy_hit.hp -= _dmg;
        var _dmg_popup = instance_create_layer(_enemy_hit.x, _enemy_hit.y - 20, "DeadL", DamageO);
        _dmg_popup.dmg = _dmg;
        _enemy_hit.shake = 3;
        _enemy_hit.shake_timer = 10;
        ShakeScr(_enemy_hit, 6, 0.6);
        _enemy_hit.touching_ball = true;
    }
    
    // отскок от врага
    var _surface_normal = collision_normal(x + vel_x, y + vel_y, EnemyO, 8, 2);
    if (_surface_normal != -1) {
        var _inc_x = vel_x / _spd;
        var _inc_y = vel_y / _spd;
        var _norm_x = lengthdir_x(1, _surface_normal);
        var _norm_y = lengthdir_y(1, _surface_normal);
        var _dot = _inc_x * _norm_x + _inc_y * _norm_y;
        vel_x = (_inc_x - 2 * _dot * _norm_x) * _spd * bounce_damp;
        vel_y = (_inc_y - 2 * _dot * _norm_y) * _spd * bounce_damp;
    } else {
        var _push_dir = point_direction(_enemy_hit.x, _enemy_hit.y, x, y);
        vel_x = lengthdir_x(4, _push_dir);
        vel_y = lengthdir_y(4, _push_dir);
    }
    spin_dir *= -1;
    
    // выталкиваем йойо из врага
    var _push_dir = point_direction(_enemy_hit.x, _enemy_hit.y, x, y);
    x += lengthdir_x(6, _push_dir);
    y += lengthdir_y(6, _push_dir);
}

x += vel_x;
y += vel_y;

// вращение зависит от скорости
var _spd_cur = point_distance(0, 0, vel_x, vel_y);
if (_spd_cur > 0.1) {
    spin_angle += _spd_cur * 0.8;
    image_angle = floor(spin_angle / 10) * 10;
}