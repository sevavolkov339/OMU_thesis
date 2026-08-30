if (instance_exists(parent_bomb)) {
    x = parent_bomb.x;
    y = parent_bomb.y;
}

// волна расширяется
wave_radius += wave_speed;
//wave_alpha = max(wave_alpha - 0.05, 0);

if (!blinking) {
    timer++;
    if (timer >= duration) {
        blinking = true;
        blink_timer = 0;
    }
} else {
    blink_timer++;
    if (blink_timer >= blink_duration) {
        instance_destroy();
        exit;
    }
}

// урон от круга пока он не начал мигать
if (!blinking) {
    var _hit_list = hit_enemies;
    with (EnemyO) {
        if (ds_list_find_index(_hit_list, id) == -1) {
            var _dist = point_distance(x, y, other.x, other.y);
            if (_dist <= other.radius) {
                ds_list_add(_hit_list, id);
				
				var _dmg = 2;
				if (instance_exists(InventoryControllerO) && InventoryControllerO.has_item("Beer")) _dmg *= 2;
				if (instance_exists(CritPowerUpO)) {
				    if (random(1) < 0.3) {
				        _dmg = _dmg * 2;
				        instance_create_layer(x, y - 20, "DeadL", KritDamageO);
				    }
				}
				hp -= _dmg;
                var _dmg_popup = instance_create_layer(x, y - 20, "DeadL", DamageO);
                _dmg_popup.dmg = _dmg;
                //hp -= 2;
                ShakeScr(id, 6, 0.6);
            }
        }
    }
}