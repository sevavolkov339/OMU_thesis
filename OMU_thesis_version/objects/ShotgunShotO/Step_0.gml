if (!hit_dealt) {
    var _enemy = instance_place(x, y, EnemyO);
    if (_enemy != noone) {
        hit_dealt = true;
        var _dmg = damage;
        if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
        if (instance_exists(CritPowerUpO)) {
            if (random(1) < 0.3) {
                _dmg *= 2;
                instance_create_layer(_enemy.x, _enemy.y - 20, "DeadL", KritDamageO);
            }
        }
        _enemy.hp -= _dmg;
        var _dmg_popup = instance_create_layer(_enemy.x, _enemy.y - 20, "DeadL", DamageO);
        _dmg_popup.dmg = _dmg;
        _enemy.shake = 3;
        _enemy.shake_timer = 10;
        ShakeScr(_enemy, 6, 0.6);
    }
}

if (floor(image_index) >= sprite_get_number(sprite_index) - 1) {
    instance_destroy();
}
