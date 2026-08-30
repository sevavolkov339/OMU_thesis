if (GameControllerO.game_paused) exit;

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

orbit_angle = (orbit_angle + orbit_speed) mod 360;
x = owner.x + lengthdir_x(orbit_radius, orbit_angle);
y = owner.y + owner.fly_visual_y + lengthdir_y(orbit_radius, orbit_angle);

var _enemy_hit = instance_place(x, y, EnemyO);

// урон только если ЭТА птица только что коснулась врага
if (_enemy_hit != noone && _enemy_hit != was_touching_enemy) {
    FreezeScr(100);
    audio_play_sound(Enemy_Hit_Snd, 0, 0);
    var _dmg = damage;
    if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
    _enemy_hit.hp -= _dmg;
    var _dmg_popup = instance_create_layer(_enemy_hit.x, _enemy_hit.y - 20, "DeadL", DamageO);
    _dmg_popup.dmg = _dmg;
    ShakeScr(_enemy_hit, 6, 0.6);
}

was_touching_enemy = _enemy_hit;