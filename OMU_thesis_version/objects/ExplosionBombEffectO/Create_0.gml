//shake cam
CameraControllerO.camera_shake(2, 15);

// сохраняем ссылку на конкретную бомбу
parent_bomb = instance_nearest(x, y, BombO);
if (instance_exists(parent_bomb)) {
    x = parent_bomb.x;
    y = parent_bomb.y;
}


timer = 0;
duration = 0.1 * room_speed;
blink_timer = 0;
blink_duration = 0.3 * room_speed;
blinking = false;
radius = 35;



// волна
wave_radius = 0;
wave_speed = 20;
wave_alpha = 1;
wave_width = 2.5;

var snd = audio_play_sound(BombExplosionDistorted_Snd, 1, false);
audio_sound_pitch(snd, random_range(0.8, 1.2));

var _sprites = [ParDitterS, ParDitterVar2S, ParS];
var _count = 20 + irandom(6);
for (var i = 0; i < _count; i++) {
    var _p = instance_create_layer(x, y, "EffectsL", ExplosionParticleO);
    var _angle = irandom(360);
    var _spd = 1.5 + random(3.5);
    _p.hspeed = lengthdir_x(_spd, _angle);
    _p.vspeed = lengthdir_y(_spd, _angle);
    _p.sprite_index = _sprites[irandom(2)];
    _p.image_index = irandom_range(1, 4);
}

// список врагов которым уже нанесли урон
hit_enemies = ds_list_create();

//// наносим урон всем врагам в радиусе сразу при появлении
//with (EnemyO) {
//    var _dist = point_distance(x, y, other.x, other.y);
//    if (_dist <= other.radius) {
//        ds_list_add(other.hit_enemies, id);
//        hp -= 2;
//        ShakeScr(id, 6, 0.6);
//        var _dir = point_direction(other.x, other.y, x, y);
//        // можно добавить knockback если нужно
//    }
//}